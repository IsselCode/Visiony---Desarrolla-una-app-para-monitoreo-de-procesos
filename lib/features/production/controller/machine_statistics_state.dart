import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vision_app/core/utils/get_network_time.dart';

class MachineStatisticsState extends ChangeNotifier {

  FirebaseFirestore firestore;
  String uidLine;
  String uidMachine;

  MachineStatisticsState({
    required this.firestore,
    required this.uidMachine,
    required this.uidLine
  });

  int okParts = 0;
  int notOkParts = 0;
  List<List<int>> partBySixHourIntervals = List.filled(6, [0, 0, 0]);

  Future<void> getAllData() async {
    DateTime currentDate = await getNetworkTime();

    okParts = await getParts("ok", currentDate);
    notOkParts = await getParts("no ok", currentDate);

    notifyListeners();

    partBySixHourIntervals = await getPartBySixHourIntervals(currentDate);

    notifyListeners();
  }

  Future<int> getParts(String parts, DateTime currentDate) async {

    // Obtener el inicio del dia
    DateTime initDate = DateTime(currentDate.year, currentDate.month, currentDate.day);

    // Obtener el final del dia (23:59:59)
    DateTime endDate = DateTime(currentDate.year, currentDate.month, currentDate.day, 23, 59, 59);

    // Hacer la consulta con un rango de fechas y obtener el conteo
    AggregateQuerySnapshot snap = await getPartsQuery(initDate, endDate, parts);

    return snap.count ?? 0;

  }

  Future<List<List<int>>> getPartBySixHourIntervals(DateTime currentDate) async {
    // Crear una lista para almacenar los conteos por cada hora
    List<List<int>> tempPartList = [];

    // Trucar a la hora completa (sin minutos ni segundos)
    DateTime currentTimeWithoutMinutes = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
      currentDate.hour
    );

    // Iterar sobre las últimas 6 horas
    for (int i = 0; i < 6; i++) {
      // Calcular el inicio y final de la hora actual menos 'i'
      DateTime initDate = currentTimeWithoutMinutes.subtract(Duration(hours: i));
      DateTime endDate = currentTimeWithoutMinutes.subtract(Duration(hours: i - 1));

      // ejecutamos el query con los argumentos correctos
      AggregateQuerySnapshot snap1 = await getPartsQuery(initDate, endDate, "ok");

      AggregateQuerySnapshot snap2 = await getPartsQuery(initDate, endDate, "no ok");

      // Obtener el número de documentos que cumplen con la condición
      int ok = snap1.count ?? 0;
      int notOk = snap2.count ?? 0;

      tempPartList.add([initDate.hour, ok, notOk]);
    }

    return tempPartList;
  }

  Future<AggregateQuerySnapshot> getPartsQuery(DateTime initDate, DateTime endDate, String parts) async {
    CollectionReference colRef = firestore.collection("piezas");

    AggregateQuerySnapshot querySnap = await colRef
        .where("hora_analisis", isGreaterThanOrEqualTo: initDate)
        .where("hora_analisis", isLessThanOrEqualTo: endDate)
        .where("linea_id", isEqualTo: uidLine)
        .where("maquina_id", isEqualTo: uidMachine)
        .where("estado", isEqualTo: parts).count().get();
    return querySnap;
  }

}







