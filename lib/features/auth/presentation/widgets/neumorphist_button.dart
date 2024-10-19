import 'package:flutter/material.dart';

class NeumorphistButton extends StatefulWidget {

  String text;
  VoidCallback onTap;

  NeumorphistButton({
    super.key,
    required this.text,
    required this.onTap
  });

  @override
  State<NeumorphistButton> createState() => _NeumorphistButtonState();
}

class _NeumorphistButtonState extends State<NeumorphistButton> {
  bool active = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        active = !active;
        widget.onTap();
        setState(() {});
      },
      borderRadius: BorderRadius.circular(25),
      child: Container(
        margin: const EdgeInsets.all(3),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xffECF0F4),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              offset: active ? Offset(2,2) : Offset(-2,-2),
              color: Color.fromRGBO(0, 0, 0, 0.5),
              blurRadius: 10,
              blurStyle: active ? BlurStyle.normal : BlurStyle.inner
            ),
            BoxShadow(
              offset: active ? Offset(-2,-2) : Offset(2, 2),
              color: Color.fromRGBO(255, 255, 255, 1),
              blurRadius: 5,
              blurStyle: active ? BlurStyle.normal : BlurStyle.inner
            ),
          ]
        ),
        child: Center(child: Text(widget.text)),
      ),
    );
  }
}
