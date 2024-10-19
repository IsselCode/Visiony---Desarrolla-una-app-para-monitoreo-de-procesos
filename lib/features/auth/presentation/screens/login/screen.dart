import 'package:flutter/material.dart';
import 'package:vision_app/features/auth/presentation/screens/login/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffECF0F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [

                Center(
                  child: Image.asset("assets/logos/logo.png", height: 200,)
                ),

                const SizedBox(height: 60,),

                LoginForm()

              ],
            ),
          ),
        ),
      )
    );
  }

}
