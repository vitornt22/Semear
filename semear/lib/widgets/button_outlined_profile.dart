// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class ButtonOutlinedProfile extends StatefulWidget {
  ButtonOutlinedProfile({super.key, required this.text, required this.onClick});

  Function onClick;
  String text;

  @override
  State<ButtonOutlinedProfile> createState() => _ButtonOutlinedProfileState();
}

class _ButtonOutlinedProfileState extends State<ButtonOutlinedProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: OutlinedButton(
        onPressed: () {
          if (widget.text == 'Seguir') {
            setState(() {
              widget.text == 'Sigo';
            });
          } else if (widget.text == "Sigo") {
            setState(() {
              widget.text = 'Seguir';
            });
          } else {
            widget.onClick();
          }
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffa23673a), width: 3),
                borderRadius: BorderRadius.circular(18)),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.add, color: Color(0xffa23673a)),
          SizedBox(width: 2),
          Text(
            widget.text,
            style: TextStyle(
              color: Color(0xffa23673a),
            ),
          ),
        ]),
      ),
    );
  }
}
