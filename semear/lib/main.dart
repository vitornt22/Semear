import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/followers_bloc.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/publication_bloc.dart';
import 'package:semear/blocs/publications_bloc.dart';
import 'package:semear/blocs/settings_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/pages/welcome_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    BlocProvider(
      blocs: [
        Bloc((i) => UserBloc()),
        Bloc((e) => PublicationBloc()),
        Bloc((p) => PublicationsBloc()),
        Bloc((s) => FollowersBloc()),
        Bloc((st) => SettingBloc()),
        Bloc((st) => ProfileBloc()),
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
