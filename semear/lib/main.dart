import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/initial_page.dart';
import 'package:semear/pages/welcome_page.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

void main() {
  runApp(
    BlocProvider(
      blocs: [
        Bloc(
          (i) => UserBloc(),
        ),
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
