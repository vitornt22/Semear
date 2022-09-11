// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class OutlinedButtonGenerator extends StatelessWidget {
  OutlinedButtonGenerator({
    super.key,
    required this.text,
    this.icon,
    this.radius,
    required this.size,
    this.page,
    this.color,
  });

  double? radius;
  Color? color;
  String text;
  IconData? icon;
  double size;
  Widget? page;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: OutlinedButton(
        onPressed: () {
          if (page != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return page!;
                },
              ),
            );
          }
        },
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius == 0 ? 5 : 25)),
          side: BorderSide(
              width: 1, color: color != null ? color! : Colors.white),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                color: color ?? Colors.white,
              ),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                  color: color ?? Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
