import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vision_app/features/production/model/line_model.dart';
import 'package:vision_app/features/production/model/machine_model.dart';

const String REFERENCIA_MAQUINAS = "maquinas";

class MachineState extends ChangeNotifier {
  
  FirebaseFirestore firestore;
  String uidLine;

  MachineState({
    required this.firestore,
    required this.uidLine
  });
  
  List<MachineModel> machines = [];
  
  Future<void> getAllMachines() async {
    // Referencia a coleccion Maquinas
    CollectionReference ref = firestore.collection(REFERENCIA_MAQUINAS);
    // Traemos todos los documentos de manera ascendente mediante el numero, donde
    // linea_id sea igual al valor del id de la linea que selecciono el usuario
    QuerySnapshot snapshots = await ref.orderBy("numero")
        .where("linea_id", isEqualTo: uidLine)
        .get();

    // Creamos una lista temporal para guardar las maquinas
    List<MachineModel> tempMachines = [];

    // Itearmos cada documentos que se haya traido desde firestore
    for (var snapshot in snapshots.docs){
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      MachineModel machineModel = MachineModel(
        uid: data["uid"],
        name: data["nombre"],
        numero: data["numero"],
        lineaId: data["linea_id"]
      );
      tempMachines.add(machineModel);
    }

    machines = tempMachines;

    notifyListeners();
  }

  Future<List<MachineModel>> searchMachinesWithName(String searchText) async {

    String startText = searchText;
    String endText = searchText + '\uf8ff';

    // Referencia a la coleccion maquinas
    CollectionReference ref = firestore.collection(REFERENCIA_MAQUINAS);
    // Obtener snapshots
    QuerySnapshot snapshots = await ref.orderBy("nombre")
                                       .where("linea_id", isEqualTo: uidLine)
                                       .where("nombre", isGreaterThanOrEqualTo: startText)
                                       .where("nombre", isLessThanOrEqualTo: endText)
                                       .get().onError((error, stackTrace) {
                                         print(error);
                                         throw Exception();
                                       },);

    List<MachineModel> tempMachines = [];

    for (var snapshot in snapshots.docs){
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      MachineModel newMachine = MachineModel(
        uid: data["uid"],
        name: data["nombre"],
        numero: data["numero"],
        lineaId: data["linea_id"]
      );
      tempMachines.add(newMachine);
    }

    return tempMachines;
  }

  Future<void> addNewMachine() async {
    // Referencia a coleccion
    CollectionReference ref = firestore.collection(REFERENCIA_MAQUINAS);

    // Obtener el documento con el número mas alto
    QuerySnapshot querySnapshot = await ref
                        .orderBy("numero", descending: true)
                        .where("linea_id", isEqualTo: uidLine)
                        .limit(1)
                        .get();

    int newMachineNumber = 1;

    if (querySnapshot.docs.isNotEmpty){
      // Si existen documentos, tomar el número mas alto y sumar 1
      newMachineNumber = querySnapshot.docs.first.get("numero") + 1;
    }

    // Crear un nuevo documento con el nuevo número de linea
    DocumentReference docRef = ref.doc();

    Map<String, dynamic> data = {
      "nombre": "maquina $newMachineNumber",
      "uid": docRef.id,
      "numero": newMachineNumber,
      "linea_id": uidLine
    };

    // Asignar datos
    await docRef.set(data).then((value) {
      // Crear y guardar nueva línea
      MachineModel newMachine = MachineModel(
        uid: data["uid"],
        name: data["nombre"],
        numero: data["numero"],
        lineaId: uidLine
      );
      // Añadir nuevo modelo a la lista de maquinas
      machines.add(newMachine);
      // Notificar a todas las pantallas el cambio
      notifyListeners();
    },);

  }

  Future<void> deleteMachine(String uid) async {
    // Referencia a coleccion
    CollectionReference ref = firestore.collection(REFERENCIA_MAQUINAS);

    await ref.doc(uid).delete().then((value) {
      // Eliminamos la línea de la lista
      machines.removeWhere((machine) => machine.uid == uid,);
      // Notificar a todas las pantallas el cambio
      notifyListeners();
    },);
  }

}