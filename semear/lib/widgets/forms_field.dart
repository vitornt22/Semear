// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class FormsField extends StatelessWidget {
  FormsField(
      {super.key, this.height, this.label, this.hintText, this.sizeBoxHeigth});
  String? label;
  double? height = 8;
  String? hintText;
  double? sizeBoxHeigth;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Text(
                label!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              )
            : SizedBox(),
        SizedBox(height: 10),
        SizedBox(
          height: 30,
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffa23673A)),
              ),
              floatingLabelStyle: TextStyle(color: Colors.green),
              filled: false,
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                gapPadding: 5,
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
        ),
        SizedBox(height: sizeBoxHeigth != null ? sizeBoxHeigth : 30)
      ],
    );
  }
}
