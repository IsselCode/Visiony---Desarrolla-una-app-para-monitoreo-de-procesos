import 'package:flutter/material.dart';

BoxDecoration activeNeumorphistDecoration({bool activeRadius = true, double? radius, double? bottomLeft, double? bottomRight, double? topLeft, double? topRight}) {
  return BoxDecoration(
      color: const Color(0xffECF0F4),
      borderRadius: !activeRadius ? null : radius != null
        ? BorderRadius.circular(radius)
        : BorderRadius.only(
          bottomLeft: Radius.circular(bottomLeft ?? 0),
          bottomRight: Radius.circular(bottomRight ?? 0),
          topLeft: Radius.circular(topLeft ?? 0),
          topRight: Radius.circular(topRight ?? 0),
      ),
      boxShadow: const [
        BoxShadow(
            offset: Offset(2, 2),
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurRadius: 5,
            blurStyle: BlurStyle.inner
        ),
        BoxShadow(
            offset: Offset(-2, -2),
            color: Color.fromRGBO(255, 255, 255, 1),
            blurRadius: 5,
            blurStyle: BlurStyle.inner
        ),
      ]
  );
}