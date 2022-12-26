import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/blocs/profile_bloc.dart';
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
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  final api = ApiProfile();
  int? id;

  @override
  void initState() {
    super.initState();
    print("WELCOME PAGEEE");
    userBloc.verificarToken().then((value) {
      id = userBloc.outMyIdValue;
      if (userBloc.outUserValue != null) {
        if (userBloc.outUserValue![id]!.category == 'church') {
          getChurchProjects();
        }
      }
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
              builder: (BuildContext context) => InitialPage()),
          (route) => false, //if you want to disable back feature set to false
        );
      }
    });
  }

  getChurchProjects() async {
    final categoryData = userBloc.outCategoryValue![id];
    print('ESPERANDO PARA ADICIONAR PROJETOS DA IGREJAAA');
    await api
        .getDataChurch(categoryData.id, 'projects')
        .then((value) => profileBloc.addProjectsChurch(id, value));
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
