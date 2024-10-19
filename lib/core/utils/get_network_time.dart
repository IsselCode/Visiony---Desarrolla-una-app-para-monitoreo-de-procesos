import 'package:ntp/ntp.dart';

Future<DateTime> getNetworkTime() async {
  try {
    // Obtén la hora exacta desde un servidor NTP
    DateTime ntpTime = await NTP.now();
    // Si estamos en una zona horaria UTC-6, podemos restar 6 horas a la hora UTC
    DateTime horaLocal = ntpTime.toLocal();

    // retornar la hora obtenida
    return horaLocal;

  } catch (e) {
    throw UnimplementedError();
  }

}