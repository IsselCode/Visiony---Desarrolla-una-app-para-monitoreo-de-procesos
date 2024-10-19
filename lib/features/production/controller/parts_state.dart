import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/part_model.dart';

const String PARTS_COLLECTION = "piezas";

class PartsState extends ChangeNotifier {

  StreamSubscription? _streamSubscription;

  FirebaseFirestore firestore;
  String uidMachine;
  String uidLine;

  PartsState({
    required this.firestore,
    required this.uidMachine,
    required this.uidLine
  });

  List<PartModel> streamParts = [];
  List<PartModel> showParts = [];

  bool _filterActivated = false;
  bool get filterActivated => _filterActivated;
  set filterActivated(bool value) {
    _filterActivated = value;

    if (!value){
      showParts = streamParts;
    }

    notifyListeners();
  }

  // 1. Accedo a la colección 'piezas' en Firestore.
  // 2. Filtrar los documentos para que solo se incluyan aquellos donde el campo
  // 'linea_id' coincida con el ID de la línea que estoy usando.
  // 3. También filtro por el ID de la máquina, para asegurarme de que solo 
  // obtengo los documentos que pertenecen a la máquina actual.
  // 4. Ordeno estos documentos por el campo 'hora_analisis',
  // de manera que los resultados se presenten en orden cronológico.
  // 5. Limito el número de documentos que quiero recibir a un máximo de 100.
  // 6. Ahora, configuro un stream que me permitirá recibir actualizaciones en tiempo real.
  // 7. Me suscribo a este stream para que, cada vez que haya una actualización
  // en los datos, pueda manejarla.
  // 8. Dentro del 'listen', convierto cada documento del snapshot en un objeto
  // de tipo 'PartModel' y actualizo mi lista interna 'streamParts'.
  // 9. Creo un nuevo objeto 'PartModel' utilizando los datos del documento y lo agrego a la lista.
  // 10. convierto el timestamp a una fecha.
  void startListening() {
    // Primero, configuro una consulta a Firestore para acceder a la colección llamada 'piezas'.
    _streamSubscription = firestore.collection(PARTS_COLLECTION).where("linea_id", isEqualTo: uidLine)
        .where("maquina_id", isEqualTo: uidMachine).orderBy("hora_analisis", descending: true)
        .limit(100).snapshots().listen((snapshot) {
          streamParts = snapshot.docs.map((doc) {
            final data = doc.data()! as Map<String, dynamic>;
            return PartModel(
              uid: doc.id,
              tiempoAnalisis: data["tiempo_analisis"],
              numeroPieza: data["numero_pieza"],
              maquinaId: data["maquina_id"],
              lineaId: data["linea_id"],
              horaAnalisis: (data["hora_analisis"] as Timestamp).toDate(),
              estado: data["estado"]
            );
          },).toList();

          if (!filterActivated) {
            showParts = streamParts;
          }

          // Finalmente, notifico a los widgets de la aplicación que la lista
          // 'streamParts' ha cambiado, para que se actualicen con los nuevos datos.
          notifyListeners();
    },);

  }

  Future<List<PartModel>> searchPartsWithNumber(String searchText) async {

    try {
      // Defino las variables startText y endText. endText se usa para crear un rango de búsqueda.
      String startText = searchText.toUpperCase();
      String endText = searchText.toUpperCase() + '\uf8ff';

      //
      QuerySnapshot snapshots = await firestore
          .collection(PARTS_COLLECTION)
          .where("linea_id", isEqualTo: uidLine)
          .where("maquina_id", isEqualTo: uidMachine)
          .where("numero_pieza", isGreaterThanOrEqualTo: startText)
          .where("numero_pieza", isLessThanOrEqualTo: endText)
          .orderBy("hora_analisis", descending: true)
          .limit(10)
          .get();

      List<PartModel> tempParts = [];

      for (QueryDocumentSnapshot snap in snapshots.docs) {
        final data = snap.data()! as Map<String, dynamic>;

        PartModel newPart = PartModel(
            uid: snap.id,
            tiempoAnalisis: data["tiempo_analisis"],
            numeroPieza: data["numero_pieza"],
            maquinaId: data["maquina_id"],
            lineaId: data["maquina_id"],
            horaAnalisis: (data["hora_analisis"] as Timestamp).toDate(),
            estado: data["estado"]
        );

        tempParts.add(newPart);
      }
      return tempParts;
    } catch (e) {
      throw Exception();
    }



  }

  Future<void> searchPartsByDateRange(List<DateTime> dates) async {

    try {

      QuerySnapshot snapshots = await firestore
          .collection(PARTS_COLLECTION)
          .where("linea_id", isEqualTo: uidLine)
          .where("maquina_id", isEqualTo: uidMachine)
          .where("hora_analisis", isGreaterThanOrEqualTo: dates[0])
          .where("hora_analisis", isLessThanOrEqualTo: dates[1])
          .orderBy("hora_analisis", descending: true)
          .limit(50)
          .get();

      List<PartModel> tempParts = [];

      for (QueryDocumentSnapshot snap in snapshots.docs) {
        final data = snap.data()! as Map<String, dynamic>;

        PartModel newPart = PartModel(
            uid: snap.id,
            tiempoAnalisis: data["tiempo_analisis"],
            numeroPieza: data["numero_pieza"],
            maquinaId: data["maquina_id"],
            lineaId: data["maquina_id"],
            horaAnalisis: (data["hora_analisis"] as Timestamp).toDate(),
            estado: data["estado"]
        );

        tempParts.add(newPart);
      }

      showParts = tempParts;

      notifyListeners();

    } catch (e) {
      throw Exception();
    }



  }

  @override
  void dispose() {
    // Cancelar la suscripción al stream
    _streamSubscription?.cancel();
    // Asegurarse de que la referencia al stream sea eliminada
    _streamSubscription = null;
    super.dispose();
  }

}






