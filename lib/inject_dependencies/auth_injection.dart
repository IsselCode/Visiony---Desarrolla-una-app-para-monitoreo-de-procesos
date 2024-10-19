import 'package:vision_app/features/auth/data/repositores/auth_repository_impl.dart';
import 'package:vision_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vision_app/inject_dependencies/inject_container.dart';

Future<void> init() async {

  // Repositorios
  locator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(auth: locator()),);

}