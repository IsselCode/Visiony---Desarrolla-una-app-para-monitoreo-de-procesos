import 'package:flutter/material.dart';

class LegendItemWidget extends StatelessWidget {

  Color color;
  String title;

  LegendItemWidget({
    super.key,
    required this.color,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Contenedor de color
        Container(
          width: 40,
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: color
          ),
        ),
        const SizedBox(width: 10,),
        Text(title)

      ],
    );
  }
}
