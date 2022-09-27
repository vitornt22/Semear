// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/models/donor_model.dart';
import 'package:semear/pages/login_page.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';
import 'package:semear/pages/register/formsFields/forms_field.dart';
import 'package:semear/widgets/circular_progress.dart';
import 'package:semear/widgets/erroScreen.dart';

class DonorRegister extends StatefulWidget {
  const DonorRegister({super.key});

  @override
  State<DonorRegister> createState() => _DonorRegisterState();
}

class _DonorRegisterState extends State<DonorRegister> {
  Future<Donor?>? submitData() async {
    http.Response response = await http.post(
      Uri.parse('https://backend-semear.herokuapp.com/donor/api/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user": {
          "username": usernameController.text.toString(),
          "email": emailController.text.toString(),
          "category": "donor",
          "can_post": false,
          "password": passwordController.text.toString()
        },
        "fullName": fullNameController.text.toString()
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Donor.fromJson(json.decode(response.body));
    } else {
      print("STATUS CODE ${response.statusCode}");
      throw Exception('Falha ao registrar');
    }
  }

  Future<Donor?>? _futureDonor;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool showProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Container(
                  height: 800,
                  color: Colors.white,
                  child: Theme(
                    data: ThemeData(
                      colorScheme: Theme.of(context)
                          .colorScheme
                          .copyWith(primary: Colors.green),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(height: 100),
                                  FieldClass(
                                    controller: fullNameController,
                                    id: 'basic',
                                    hint: 'Ex: Antonio José de Sousa',
                                    label: 'Nome completo',
                                  ),
                                  FieldClass(
                                      controller: emailController, id: 'email'),
                                  FormsField(
                                    keyboard: TextInputType.text,
                                    controller: usernameController,
                                    label: 'Nome de Usuário',
                                    hintText: 'ex: osvaldovieira',
                                    sizeBoxHeigth: 10,
                                  ),
                                  FieldClass(
                                      controller: passwordController,
                                      id: 'password'),
                                  FieldClass(
                                    controller: confirmPasswordController,
                                    id: 'password',
                                    validator: (text) {
                                      text = confirmPasswordController.text;
                                      String text2 = passwordController.text;
                                      if (text.length != text2.length ||
                                          text != text2) {
                                        return "Senhas não coincidem";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              showProgress = true;
                                            });
                                            int cont = 0;
                                            apiForm
                                                .checkEmail(
                                                    emailController.text)
                                                .then((value) async {
                                              if (value == true) {
                                                emailController.text =
                                                    'email existente';
                                              } else {
                                                setState(() {
                                                  cont++;
                                                });
                                              }

                                              apiForm
                                                  .checkUsername(
                                                      usernameController.text)
                                                  .then((value) {
                                                if (value == true) {
                                                  usernameController.text =
                                                      'Nome de usuário já existe';
                                                } else {
                                                  setState(() {
                                                    cont++;
                                                  });
                                                }

                                                if (cont == 2) {
                                                  _futureDonor = submitData();

                                                  Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) {
                                                    return FutureBuilder<
                                                        Donor?>(
                                                      future: _futureDonor,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasData) {
                                                          return LoginPage(
                                                            isRegister: true,
                                                          );
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return ErrorScreen(
                                                            text:
                                                                '${snapshot.error}',
                                                          );
                                                        }

                                                        return LoadingScreen();
                                                      },
                                                    );
                                                  }));
                                                }
                                                setState(() {
                                                  showProgress = false;
                                                });
                                              });
                                            });
                                          }
                                        },
                                        child: Text('Cadastrar'),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Voltar'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Visibility(
                                visible: showProgress,
                                child: Center(
                                  heightFactor: 15,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
