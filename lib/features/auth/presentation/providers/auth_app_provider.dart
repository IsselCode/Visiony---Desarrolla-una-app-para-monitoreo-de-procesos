import 'package:flutter/material.dart';
import 'package:vision_app/features/auth/domain/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthAppProvider extends ChangeNotifier {

  AuthRepository authRepository;

  AuthAppProvider({
    required this.authRepository
  });


  UserEntity? user;

  Future<Response> login(String email, String password) async {

    Response response = await authRepository.login(email, password);

    if (response.error == null){
      user = response.user;
    }

    return response;

  }


}