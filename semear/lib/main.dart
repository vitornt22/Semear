import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/donation_bloc.dart';
import 'package:semear/blocs/followers_bloc.dart';
import 'package:semear/blocs/notification_bloc.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/publication_bloc.dart';
import 'package:semear/blocs/publications_bloc.dart';
import 'package:semear/blocs/search_bloc.dart';
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
        Bloc((d) => DonationBloc()),
        Bloc((s) => FollowersBloc()),
        Bloc((st) => SettingBloc()),
        Bloc((st) => ProfileBloc()),
        Bloc((nt) => NotificationBloc()),
        Bloc((as) => SearchBloc())
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
