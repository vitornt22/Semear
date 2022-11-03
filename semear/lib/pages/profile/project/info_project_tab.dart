// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/information_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/dialog_donation.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/widgets/column_text.dart';

class InfoProject extends StatelessWidget {
  InfoProject(
      {super.key,
      required this.type,
      required this.user,
      required this.category,
      required this.information});

  Information information;
  String category;
  String type;
  final user;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  Map title = {
    'missionary': ['Quem sou eu?', 'Onde atuo?'],
    'project': ['Quem somos nós?', 'Nosso Objetivo']
  };

  late List<String> list = title[category];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColumnText(
                    title: list[0],
                    text: information.whoAreUs ?? 'Nenhuma informação'),
                SizedBox(height: 10),
                ClipRRect(
                  child: Image(
                    image: NetworkImage(information.photo1!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                ColumnText(
                    title: list[1],
                    text: information.ourObjective ?? 'Não há informação'),
                SizedBox(height: 10),
                ClipRRect(
                  child: Image(
                    image: NetworkImage(information.photo2!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: type != 'me',
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ButtonFilled(
                      text: 'Doe para o nosso projeto',
                      onClick: () {
                        showDialog(
                            context: context,
                            builder: (context) => DonationDialog(
                                user: user, donor: userBloc.outUserValue));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
