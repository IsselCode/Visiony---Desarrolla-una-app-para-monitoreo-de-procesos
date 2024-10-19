
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:vision_app/firebase_options.dart';

import "auth_injection.dart" as auth;

GetIt locator = GetIt.instance;

Future<void> injectContainer() async {

  /// Casos de uso

  /// Repositorios

  /// Datasources

  /// Core

  /// External

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
  );

  FirebaseAuth authentication = FirebaseAuth.instance;

  locator.registerLazySingleton(() => authentication,);


  /// Caracteristicas
  await auth.init();

}