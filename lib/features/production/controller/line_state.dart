import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vision_app/features/production/model/line_model.dart';

const String REFERENCIA_LINEAS = "lineas";

class LineState extends ChangeNotifier {
  
  FirebaseFirestore firestore;
  
  LineState({
    required this.firestore,  
  });
  
  List<LineModel> productionLines = [];
  
  Future<void> getAllLines() async {
    CollectionReference ref = firestore.collection(REFERENCIA_LINEAS);
    QuerySnapshot snapshots = await ref.orderBy("nombre").get();

    List<LineModel> tempProductionLines = [];

    for (var snapshot in snapshots.docs){
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      LineModel newLine = LineModel(uid: data["uid"], name: data["nombre"], numero: data["numero"]);
      tempProductionLines.add(newLine);
    }

    productionLines = tempProductionLines;

    notifyListeners();
  }

  Future<List<LineModel>> searchLinesWithName(String searchText) async {
    String startText = searchText;
    String endText = searchText + '\uf8ff';

    CollectionReference ref = firestore.collection(REFERENCIA_LINEAS);
    QuerySnapshot snapshots = await ref.orderBy("nombre")
                                       .where("nombre", isGreaterThanOrEqualTo: startText)
                                       .where("nombre", isLessThanOrEqualTo: endText)
                                       .get();

    List<LineModel> tempProductionLines = [];

    for (var snapshot in snapshots.docs){
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      LineModel newLine = LineModel(uid: data["uid"], name: data["nombre"], numero: data["numero"]);
      tempProductionLines.add(newLine);
    }

    return tempProductionLines;
  }

  Future<void> addNewLine() async {
    // Referencia a coleccion
    CollectionReference ref = firestore.collection(REFERENCIA_LINEAS);

    // Obtener el documento con el número mas alto
    QuerySnapshot querySnapshot = await ref.orderBy("numero", descending: true).limit(1).get();

    int newLineNumber = 1;

    if (querySnapshot.docs.isNotEmpty){
      // Si existen documentos, tomar el número mas alto y sumar 1
      newLineNumber = querySnapshot.docs.first.get("numero") + 1;
    }

    // Crear un nuevo documento con el nuevo número de linea
    DocumentReference docRef = ref.doc();

    Map<String, dynamic> data = {
      "nombre": "linea $newLineNumber",
      "uid": docRef.id,
      "numero": newLineNumber
    };

    // Asignar datos
    await docRef.set(data).then((value) {
      // Crear y guardar nueva línea
      LineModel newLine = LineModel(uid: data["uid"], name: data["nombre"], numero: data["numero"]);
      // Añadir nuevo modelo a la lista de lineas
      productionLines.add(newLine);
      // Notificar a todas las pantallas el cambio
      notifyListeners();
    },);

  }

  Future<void> deleteLine(String uid) async {
    // Referencia a coleccion
    CollectionReference ref = firestore.collection(REFERENCIA_LINEAS);

    await ref.doc(uid).delete().then((value) {
      // Eliminamos la línea de la lista
      productionLines.removeWhere((element) => element.uid == uid,);
      // Notificar a todas las pantallas el cambio
      notifyListeners();
    },);
  }

}