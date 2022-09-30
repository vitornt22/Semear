import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/pages/home_screen.dart';
import 'package:semear/pages/initial_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final userBloc = BlocProvider.getBloc<UserBloc>();

  @override
  void initState() {
    super.initState();
    userBloc.verificarToken().then((value) {
      if (value == true) {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => HomeScreen(user: 'ola'),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      } else {
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const InitialPage()),
          (route) => false, //if you want to disable back feature set to false
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(color: Colors.green),
      ),
    );
  }
}
