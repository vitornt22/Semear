// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors, must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:semear/pages/home_screen.dart';
import 'package:semear/pages/initial_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    super.key,
    required this.category,
    this.is_register,
  });

  String category;
  bool? is_register;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  GlobalKey<FormState> _formKKey = GlobalKey();

  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return InitialPage();
                        },
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_back, color: Color(0xffa23673A)))),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
              child: Form(
                key: _formKKey,
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
                          backgroundColor: Color(0xffa23673A),
                        ),
                        onPressed: () async {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (_formKKey.currentState!.validate()) {
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                          }

                          '''Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => HomeScreen(
                                  category: widget.category, user: 'ola'),
                            ),
                            (route) =>
                                false, //if you want to disable back feature set to false
                          );''';
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
                          ' Ou Registre-se ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(20),
                              backgroundColor: Colors.white),
                          onPressed: () {},
                          child: Text('Registre-se',
                              style: TextStyle(color: Colors.green)),
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
