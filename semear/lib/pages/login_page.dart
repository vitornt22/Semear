// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:semear/blocs/login_bloc.dart';
import 'package:semear/pages/home_screen.dart';
import 'package:semear/pages/initial_page.dart';
import 'package:semear/pages/register/register_type.dart';
import 'package:semear/validators/fields_validations.dart';
import 'package:semear/widgets/input_login_text.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    super.key,
    this.isRegister,
  });

  bool? isRegister;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginBloc = LoginBloc();

  Validations validations = Validations();
  bool showProgress = false;

  @override
  void initState() {
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
              child: StreamBuilder(
                stream: _loginBloc.outState,
                builder: (context, snapshot) => Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 90,
                          child: Image.asset(
                            'assets/images/icon2.png',
                          ),
                        ),
                        SizedBox(height: 60),
                        InputLoginField(
                          text: "Email",
                          stream: _loginBloc.outEmail,
                          onChanged: _loginBloc.changeEmail,
                        ),
                        InputLoginField(
                          text: "SENHA",
                          stream: _loginBloc.outPassword,
                          onChanged: _loginBloc.changePassword,
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: StreamBuilder<bool>(
                              initialData: false,
                              stream: _loginBloc.outVisibility,
                              builder: (context, valueBool) => Icon(
                                valueBool.data == true
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          textAlign: TextAlign.end,
                          'Esqueceu Sua Senha?',
                          style: TextStyle(
                              color: Color(0xffa23673A),
                              fontSize: 15,
                              fontWeight: FontWeight.w800),
                        ),
                        SizedBox(height: 20),
                        StreamBuilder<bool>(
                          stream: _loginBloc.outSubmitedValid,
                          builder: (context, data) => SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: StadiumBorder(),
                                backgroundColor: Color(0xffa23673A),
                              ),
                              onPressed: data.hasData
                                  ? () async {
                                      print("SNAPSHOT ${snapshot.data}");
                                      print("DATA 2 ${data.data}");

                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }
                                      _loginBloc.submit().then((a) {
                                        if (a == true) {
                                          print("A é igual a true");
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext contex) =>
                                                  HomeScreen(user: 'ola'),
                                            ),

                                            (route) =>
                                                false, //if you want to disable back feature set to false
                                          );
                                        } else if (a == false) {
                                          print("A é igual a FALSE");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      });
                                    }
                                  : null,
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900),
                              ),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<dynamic>(
                                    builder: (BuildContext context) =>
                                        RegisterType(),
                                  ),
                                  //if you want to disable back feature set to false
                                );
                              },
                              child: Text('Registre-se',
                                  style: TextStyle(color: Colors.green)),
                            )),
                          ],
                        )
                      ],
                    ),
                    Visibility(
                      visible:
                          snapshot.data == LoginState.loading ? true : false,
                      child: Container(
                        width: double.maxFinite,
                        color: Colors.transparent,
                        child: Center(
                            heightFactor: 15,
                            child:
                                CircularProgressIndicator(color: Colors.green)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  final snackBar = SnackBar(
    content: Text(
      'Email ou senha são inválidos',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );
}
