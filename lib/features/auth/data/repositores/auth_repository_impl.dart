import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vision_app/features/auth/domain/entities/user_entity.dart';
import 'package:vision_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:vision_app/firebase_options.dart';

class AuthRepositoryImpl implements AuthRepository {

  

  FirebaseAuth auth;

  AuthRepositoryImpl({
    required this.auth
  });

  @override
  Future<Response> login(String email, String password) async {

    try {

      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

      UserEntity entity = UserEntity(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? ""
      );

      return Response(user: entity);

    } on FirebaseAuthException catch (e) {

      print(e.message);

      String errorMessage = "Error desconocido";

      if (e.code == "invalid-credential") {
        errorMessage = "Credenciales incorrectas";
      }

      return Response(error: errorMessage);

    }

  }

}