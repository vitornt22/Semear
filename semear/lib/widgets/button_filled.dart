// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:flutter/material.dart';

class ButtonFilled extends StatefulWidget {
  ButtonFilled({super.key, required this.text, required this.onClick});

  Function onClick;
  String text;

  @override
  State<ButtonFilled> createState() => _ButtonFilledState();
}

class _ButtonFilledState extends State<ButtonFilled> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton(
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
          backgroundColor: MaterialStateProperty.all<Color>(
            widget.text != "Seguir" ? Color(0xffa23673a) : Colors.transparent,
          ),
          shadowColor: MaterialStateProperty.all<Color>(
            widget.text != "Seguir" ? Color(0xffa23673a) : Colors.transparent,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffa23673a)),
                borderRadius: BorderRadius.circular(18)),
          ),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
            color: widget.text != "Seguir" ? Colors.white : Color(0xffa23673a),
          ),
        ),
      ),
    );
  }
}
