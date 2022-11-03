// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/settings_bloc.dart';

class ButtonFilled extends StatefulWidget {
  ButtonFilled(
      {super.key,
      this.loading,
      this.changeColor,
      required this.text,
      required this.onClick});

  Function onClick;
  bool? loading;
  bool? changeColor;
  String text;

  @override
  State<ButtonFilled> createState() => _ButtonFilledState();
}

class _ButtonFilledState extends State<ButtonFilled> {
  final settingsBloc = BlocProvider.getBloc<SettingBloc>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ElevatedButton(
        onPressed: () {
          widget.onClick();
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              widget.changeColor == true ? Colors.white : Color(0xffa23673a)),
          shadowColor: MaterialStateProperty.all<Color>(Color(0xffa23673a)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                side: const BorderSide(color: Color(0xffa23673a)),
                borderRadius: BorderRadius.circular(18)),
          ),
        ),
        child: StreamBuilder<bool>(
            stream: settingsBloc.loadingController,
            initialData: settingsBloc.outLoading,
            builder: (context, snapshot) {
              return snapshot.data == true && widget.loading == true
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                            visible: widget.changeColor == true,
                            child: SizedBox(
                              width: 5,
                            )),
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: widget.changeColor == true
                                ? Color(0xffa23673a)
                                : Colors.white,
                          ),
                        ),
                        Visibility(
                          visible: widget.changeColor == true,
                          child: Icon(
                            Icons.add,
                            size: 17,
                            color: Color(0xffa23673a),
                          ),
                        )
                      ],
                    );
            }),
      ),
    );
  }
}
