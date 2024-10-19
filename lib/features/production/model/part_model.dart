class PartModel {

  String uid;
  double tiempoAnalisis;
  String numeroPieza;
  String maquinaId;
  String lineaId;
  DateTime horaAnalisis;
  String estado;

  PartModel({
    required this.uid,
    required this.tiempoAnalisis,
    required this.numeroPieza,
    required this.maquinaId,
    required this.lineaId,
    required this.horaAnalisis,
    required this.estado,
  });

}