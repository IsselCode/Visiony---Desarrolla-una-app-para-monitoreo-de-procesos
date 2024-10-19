import 'package:flutter/material.dart';
import 'package:vision_app/core/app/decorations/active_neumorphist_decoration.dart';

class CustomIconButton extends StatelessWidget {

  VoidCallback onTap;
  IconData icon;

  CustomIconButton({
    super.key,
    required this.onTap,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          height: 30,
          width: 30,
          decoration: activeNeumorphistDecoration(radius: 10),
          child: Icon(icon),
        ),
      ),
    );
  }
}
