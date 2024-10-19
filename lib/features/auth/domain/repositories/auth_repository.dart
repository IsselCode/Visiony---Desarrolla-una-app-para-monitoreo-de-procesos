import 'package:vision_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {

  Future<Response> login(String email, String password);

}