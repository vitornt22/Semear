// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/information_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/dialog_donation.dart';
import 'package:semear/pages/profile/edit_profile.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/widgets/column_text.dart';

class InfoProject extends StatefulWidget {
  InfoProject(
      {super.key,
      required this.type,
      required this.user,
      required this.categoryData,
      required this.category,
      required this.information});

  Information? information;
  String category;
  String type;

  User user;
  final categoryData;

  @override
  State<InfoProject> createState() => _InfoProjectState();
}

class _InfoProjectState extends State<InfoProject> {
  final userBloc = BlocProvider.getBloc<UserBloc>();
  int? id;

  Map title = {
    'missionary': ['Quem sou eu?', 'Onde atuo?'],
    'project': ['Quem somos nós?', 'Nosso Objetivo']
  };

  late List<String> list = title[widget.category];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(id);
    id = widget.user.id;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Color.fromRGBO(255, 255, 255, 1),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: StreamBuilder<Map<int, User?>>(
              stream: userBloc.outUser,
              initialData: userBloc.outUserValue,
              builder: (context, snapshot) {
                return snapshot.data![id]!.information != null
                    ? informations(context, snapshot.data![id]!.information)
                    : widget.type != 'me'
                        ? Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Ainda não há informações",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 23, 113, 26)),
                            ),
                          )
                        : Container(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      body: EditProfile(
                                        user: widget.user,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text('Adicionar Informações'),
                            ),
                          );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget informations(context, data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ColumnText(title: list[0], text: data.whoAreUs ?? 'Nenhuma informação'),
        SizedBox(height: 10),
        Visibility(
          visible: data.whoAreUs != null,
          child: ClipRRect(
            child: data.photo1 != null
                ? Image(
                    image: NetworkImage(data.photo1!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey,
                  ),
          ),
        ),
        SizedBox(height: 10),
        ColumnText(
            title: list[1], text: data.ourObjective ?? 'Não há informação'),
        SizedBox(height: 10),
        Visibility(
          visible: data.ourObjective != null,
          child: ClipRRect(
            child: Image(
              image: NetworkImage(data.photo2 ?? ''),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: widget.type == 'me',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Scaffold(
                        body: EditProfile(user: widget.user),
                      ),
                    ),
                  );
                },
                child: Text(
                  'Editar Informações',
                  style: TextStyle(color: Color.fromARGB(255, 37, 128, 40)),
                ),
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.type != 'me',
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: ButtonFilled(
              text: 'Doe para o nosso projeto',
              onClick: () {
                showDialog(
                    context: context,
                    builder: (context) => DonationDialog(
                        user: widget.user, donor: userBloc.outUserValue));
              },
            ),
          ),
        ),
        SizedBox(height: 20)
      ],
    );
  }
}
