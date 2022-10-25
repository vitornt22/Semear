// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors, prefer_typing_uninitialized_variables, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/services.dart';

class FormsField extends StatefulWidget {
  FormsField(
      {super.key,
      this.digit,
      this.autofill,
      this.cnpjController,
      this.onChangedVar,
      required this.keyboard,
      this.formkey,
      this.mask,
      this.validator,
      required this.controller,
      this.height,
      this.obscureText,
      this.label,
      this.hintText,
      this.sizeBoxHeigth});

  bool? obscureText = false;
  bool? digit;
  var onChangedVar;
  List<String>? autofill;
  GlobalKey<FormState>? formkey;
  TextInputType keyboard;
  TextEditingController? cnpjController;
  late String? mask;
  String? Function(String? value)? validator;
  String? label;
  double? height = 8;
  String? hintText;
  double? sizeBoxHeigth;
  TextEditingController controller;

  @override
  State<FormsField> createState() => _FormsFieldState();
}

class _FormsFieldState extends State<FormsField> {
  late Widget iconCancel;
  var mask;
  late TextEditingController controller = TextEditingController();

  resetFields() {
    widget.controller.text = "";
    setState(() {
      widget.formkey = GlobalKey<FormState>();
    });
  }

  @override
  void initState() {
    super.initState();
    mask = MaskTextInputFormatter(mask: widget.mask);
    iconCancel = SizedBox();
    if (widget.cnpjController != null) {
      controller = widget.cnpjController!;
    } else {
      controller = widget.controller;
    }
    print(controller);
  }

  void onChanged(String text) {
    print(controller.text);
    if (text.isEmpty) {
      setState(() {
        iconCancel = SizedBox();
      });
    } else {
      setState(() {
        iconCancel = IconButton(
          onPressed: () {
            resetFields();
          },
          icon: Icon(Icons.cancel, size: 20, color: Colors.grey),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Text(
                widget.label!,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              )
            : SizedBox(),
        SizedBox(height: 10),
        TextFormField(
          obscureText: widget.obscureText ?? false,
          onChanged: widget.onChangedVar ?? onChanged,
          validator: widget.validator ??
              (value) {
                return null;
              },
          inputFormatters: widget.digit == true
              ? [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))]
              : [mask],
          autofillHints: widget.autofill ?? [],
          keyboardType: widget.keyboard,
          controller: widget.controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 8),
            errorBorder: OutlineInputBorder(
                borderSide: BorderSide(style: BorderStyle.solid)),
            suffixIcon: iconCancel,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffa23673A)),
            ),
            floatingLabelStyle: TextStyle(color: Colors.green),
            filled: false,
            hintText: widget.hintText,
            focusedBorder: OutlineInputBorder(
              gapPadding: 2,
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
        ),
        SizedBox(height: widget.sizeBoxHeigth ?? 30)
      ],
    );
  }
}
