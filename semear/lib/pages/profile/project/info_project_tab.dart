// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/widgets/column_text.dart';

class InfoProject extends StatelessWidget {
  InfoProject({super.key, required this.category});

  String category;
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
                  text:
                      'Somos o projeto Jesus Visitando Familias da Igreja Assembleia de Deus Missao em Fronteiras-PI, fundado em 2021. ',
                ),
                SizedBox(height: 10),
                ClipRRect(
                  child: Image(
                    image: AssetImage('assets/images/projeto.jpg'),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                ColumnText(
                  title: list[1],
                  text:
                      ' O nosso principal objetivo é sair às ruas para proclamar as boas novas de salvação e levar o amor de Jesus para vida carentes.Através das doações levamos alimentos, cobertores e mantimentos para ao menos amenizar o sofrimento daqueles que se encontram em situações assim.',
                ),
                SizedBox(height: 10),
                ClipRRect(
                  child: Image(
                    image: AssetImage('assets/images/projeto2.jpeg'),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ButtonFilled(
                    text: 'Seja um Apoiador',
                    onClick: () {},
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
