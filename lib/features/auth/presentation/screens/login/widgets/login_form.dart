import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vision_app/features/auth/domain/entities/user_entity.dart';
import 'package:vision_app/features/auth/presentation/providers/auth_app_provider.dart';
import 'package:vision_app/features/production/view/line_production_screen.dart';

import '../../../widgets/neumorphist_button.dart';
import '../../../widgets/neumorphist_input.dart';

class LoginForm extends StatelessWidget {

  LoginForm({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        children: [

          /// Correo
          NeumorphistInput(
            hintText: "Correo",
            controller: emailController,
            validator: (value) {
              if (value!.isEmpty) return "Campo vacío";
            },
          ),

          const SizedBox(height: 20,),

          /// Contraseña
          NeumorphistInput(
            forPassword: true,
            hintText: "Contraseña",
            controller: passwordController,
            validator: (value) {
              if (value!.isEmpty) return "Campo vacío";
              if (value! == "123") return "La contraseña es muy debil";
            },
          ),

          const SizedBox(height: 40,),

          /// Botón
          NeumorphistButton(
            text: "Ingresar",
            onTap: () async {
              AuthAppProvider authAppProvider = context.read();

              if (!_formKey.currentState!.validate()){
                return ;
              }

              Response response = await authAppProvider.login(
                emailController.text,
                passwordController.text
              );

              if (response.error == null){
                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LineProductionScreen(),));
                return ;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(response.error!))
              );


            },
          )

        ],
      )
    );
  }
}
