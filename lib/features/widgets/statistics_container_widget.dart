import 'package:flutter/material.dart';
import 'package:vision_app/core/app/decorations/active_neumorphist_decoration.dart';

class StatisticsContainerWidget extends StatelessWidget {

  IconData icon;
  String title;
  int value;

  StatisticsContainerWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.value
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: activeNeumorphistDecoration(radius: 15),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10,),
          Text(title),
          const Spacer(),
          Text(value.toString())
        ],
      ),
    );
  }
}
