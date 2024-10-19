import 'package:flutter/material.dart';

class NeumorphistInput extends StatelessWidget {

  String hintText;
  TextEditingController controller;
  String? Function(String? value)? validator;
  bool forPassword;

  NeumorphistInput({
    super.key,
    required this.hintText,
    required this.controller,
    this.forPassword = false,
    this.validator
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: const Color(0xffECF0F4),
            boxShadow: const [
              BoxShadow(
                offset: Offset(-2,-2),
                color: Color.fromRGBO(0, 0, 0, 0.5),
                blurRadius: 5,
                blurStyle: BlurStyle.inner
              ),
              BoxShadow(
                  offset: Offset(2,2),
                  color: Color.fromRGBO(255, 255, 255, 1),
                  blurRadius: 4,
                  blurStyle: BlurStyle.inner
              ),
            ]
          ),
          height: 40,
          width: double.infinity,
        ),
        Center(
          child: TextFormField(
            obscureText: forPassword,
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 13),
              border: const OutlineInputBorder(
                  borderSide: BorderSide.none
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0)
            ),
          ),
        )
      ],
    );
  }
}
