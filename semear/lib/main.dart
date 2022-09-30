import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/publication_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/pages/welcome_page.dart';

void main() {
  runApp(
    BlocProvider(
      blocs: [
        Bloc((i) => UserBloc()),
        Bloc((i) => PublicationBloc()),
      ],
      dependencies: const [],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        debugShowMaterialGrid: false,
        home: WelcomePage(),
        //home: HomeScreen(),
      ),
    ),
  );
}

//InitialPage(),
