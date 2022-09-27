// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

class InputLoginField extends StatelessWidget {
  const InputLoginField(
      {super.key,
      this.suffixIcon,
      this.obscure,
      this.maxLines,
      required this.text,
      this.hint,
      this.controller,
      required this.stream,
      this.onChanged});

  final TextEditingController? controller;
  final String text;
  final int? maxLines;
  final String? hint;
  final Stream<String> stream;
  final Function(String)? onChanged;
  final bool? obscure;
  final IconButton? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
              color: Color.fromRGBO(35, 103, 58, 0.98),
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
        StreamBuilder<String>(
          stream: stream,
          builder: (contex, snapshot) => TextFormField(
            onChanged: onChanged,
            controller: controller,
            validator: (String? text) {
              if (text!.isEmpty) {
                return "Email não pode ser vazio";
              }
              return null;
            },
            obscureText: obscure ?? false,
            maxLines: maxLines,
            minLines: 1,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              hintText: hint,
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xffa23673a), width: 1),
              ),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
