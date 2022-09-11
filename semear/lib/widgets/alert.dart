// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class AlertBox extends StatelessWidget {
  AlertBox({
    super.key,
    required this.title,
    required this.text,
    required this.sizeBox,
  });

  String title, text;
  double sizeBox;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        height: sizeBox,
        child: Text(text),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok"))
      ],
    );
  }
}
