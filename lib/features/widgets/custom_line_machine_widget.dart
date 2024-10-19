import 'package:flutter/material.dart';
import 'package:vision_app/core/app/decorations/active_neumorphist_decoration.dart';

class CustomLineMachineWidget extends StatelessWidget {

  String image;
  String name;
  VoidCallback onLongPress;
  VoidCallback onTap;


  CustomLineMachineWidget({
    super.key,
    required this.image,
    required this.name,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Container(
        decoration: activeNeumorphistDecoration(radius: 25),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
                left: 0,
                right: 0,
                top: -60,
                child: Image.asset(image)
            ),
            Positioned(
                bottom: 25,
                right: 0,
                left: 0,
                child: Text(name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)
            )
          ],
        ),
      ),
    );
  }
}
