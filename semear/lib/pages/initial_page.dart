// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/home_screen.dart';
import 'package:semear/pages/login_page.dart';
import 'package:semear/pages/register/register_type.dart';

class InitialPage extends StatelessWidget {
  InitialPage({super.key});
  final userBloc = BlocProvider.getBloc<UserBloc>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: 0.2,
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.2), BlendMode.dstATop),
                  image: AssetImage('assets/images/projeto.jpg')),
              gradient: const LinearGradient(
                colors: [
                  Color(0xffa23673A),
                  Color.fromARGB(248, 37, 171, 82),
                  Color.fromARGB(248, 22, 101, 48),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image(
                  height: 100,
                  image: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(height: 100),
                SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginPage(
                              isRegister: false,
                            );
                          },
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        side: BorderSide(width: 1, color: Colors.white)),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return RegisterType();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Registrar',
                      style: TextStyle(color: Color(0xffa23673A)),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: StadiumBorder(),
                      backgroundColor: Color.fromARGB(255, 0, 93, 3),
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      userBloc.inMyId.add(0);
                      final user = User(id: 0, category: 'anonymous');
                      print("FINAL USER ${user.category}");
                      await userBloc.addUser(user);
                      navigator.push(
                        MaterialPageRoute(
                          builder: (context) {
                            return HomeScreen(
                              user: 'ola',
                            );
                          },
                        ),
                      );
                    },
                    child: Text(
                      'Entrar como doador Anônimo',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
