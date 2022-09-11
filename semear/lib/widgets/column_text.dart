// ignore_for_file: use_full_hex_values_for_flutter_colors, must_be_immutable

import 'package:flutter/material.dart';

class ColumnText extends StatelessWidget {
  ColumnText({super.key, required this.title, required this.text});

  String title;
  String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          textAlign: TextAlign.start,
          title,
          style: const TextStyle(
            color: Color(0xffa23673A),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Text(text),
      ],
    );
  }
}
