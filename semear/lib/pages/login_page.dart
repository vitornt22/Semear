// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:semear/pages/home_screen.dart';
import 'package:semear/pages/initial_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, this.redirect, required this.category});
  String? redirect;
  String category;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromARGB(255, 235, 252, 236),
          appBar: AppBar(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  onPressed: () {
                    if (redirect == 'initial') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return InitialPage();
                          },
                        ),
                      );
                    } else {
                      if (FocusScope.of(context).isFirstFocus) {
                        FocusScope.of(context).unfocus();
                      }
                      Timer(Duration(milliseconds: 200), () {
                        Navigator.pop(context);
                      });
                    }
                  },
                  icon: Icon(Icons.arrow_back, color: Color(0xffa23673A)))),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 90,
                    child: Image.asset(
                      'assets/images/icon2.png',
                    ),
                  ),
                  SizedBox(height: 60),
                  Text(
                    'EMAIL',
                    style: TextStyle(
                        color: Color.fromRGBO(35, 103, 58, 0.98),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex: fulano@gmail.com',
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffa23673A), width: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'SENHA',
                    style: TextStyle(
                        color: Color(0xffa23673A),
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xffa23673A), width: 1),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    textAlign: TextAlign.end,
                    'Esqueceu Sua Senha?',
                    style: TextStyle(
                        color: Color(0xffa23673A),
                        fontSize: 15,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        primary: Color(0xffa23673A),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return HomeScreen(
                                  category: category, user: 'ola');
                            },
                          ),
                        );
                      },
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          thickness: 3,
                        ),
                      ),
                      Text(
                        ' Ou conecte-se com ',
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 3,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: SignInButton(
                          Buttons.Google,
                          text: 'Google',
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(width: 30),
                      SizedBox(
                        width: 150,
                        child: SignInButton(
                          Buttons.Facebook,
                          text: 'Facebook',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )),
    );
  }
}
