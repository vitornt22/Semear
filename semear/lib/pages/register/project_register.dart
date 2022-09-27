import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';

// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:semear/pages/login_page.dart';
import 'package:semear/pages/register/formsFields/city_state_field.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';
import 'package:semear/pages/register/validations.dart';
import 'package:semear/widgets/circular_progress.dart';
import 'package:semear/widgets/erroScreen.dart';

ApiForm apiForm = ApiForm();
Validations validations = Validations();

class ProjectRegister extends StatefulWidget {
  const ProjectRegister({super.key});

  @override
  State<ProjectRegister> createState() => _ProjectRegisterState();
}

class _ProjectRegisterState extends State<ProjectRegister> {
  int _currentStep = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController churchController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();

  //PROVISORIO
  //bank
  TextEditingController titularNamecontroller = TextEditingController();
  TextEditingController agencyController = TextEditingController();
  TextEditingController agencyDigitController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController accountDigitController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  // PI
  TextEditingController keyTypeController = TextEditingController();
  TextEditingController keyValueController = TextEditingController();
  Future<Project?>? _futureProject;

  bool showProgress = false;
  Map? adressMap;
  int idAdress = 0;
  int idChurch = 0;

  bool checkedValue = true;

  Future<Project?>? submitData() async {
    print("ADRESS MAP: $adressMap");

    print('CHURCH: $idChurch');
    http.Response response = await http.post(
      Uri.parse('https://backend-semear.herokuapp.com/project/api/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user": {
          "username": usernameController.text,
          "email": emailController.text,
          "category": "missionary",
          "can_post": true,
          "password": passwordController.text
        },
        "adress": adressMap,
        "church": null,
        "id_church": idChurch,
        "id_adress": idAdress,
        "name": nameController.text
      }),
    );

    print(
      jsonEncode({
        "user": {
          "username": usernameController.text,
          "email": emailController.text,
          "category": "missionary",
          "can_post": true,
          "password": passwordController.text
        },
        "id_church": idChurch,
        "id_adress": idAdress,
        "fullName": nameController.text,
        "church": idChurch,
        "adress": adressMap
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      print("STATUS CODE ${response.statusCode}");
      throw Exception('Falha ao registrar');
    }
    return null;
  }

  final List<GlobalKey<FormState>> _formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  late Future<Map<String, dynamic>> cep;

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
              child: Container(
                color: Colors.white,
                child: Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(primary: Colors.green),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Stepper(
                      type: StepperType.vertical,
                      currentStep: _currentStep,
                      physics: ScrollPhysics(),
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() {
                            _currentStep--;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      onStepContinue: () {
                        print('Checked= $checkedValue');

                        if (_formKey[_currentStep].currentState!.validate()) {
                          switch (_currentStep) {
                            case 0:
                              int cont = 0;

                              setState(() {
                                showProgress = true;
                              });

                              apiForm
                                  .checkEmail(emailController.text)
                                  .then((value) async {
                                if (value == true) {
                                  emailController.text = 'email existente';
                                } else {
                                  setState(() {
                                    cont++;
                                  });
                                }

                                apiForm
                                    .checkUsername(usernameController.text)
                                    .then((value) {
                                  if (value == true) {
                                    usernameController.text =
                                        'Nome de usuário já existe';
                                  } else {
                                    setState(() {
                                      cont++;
                                    });
                                  }

                                  apiForm
                                      .checkCnpj(churchController.text)
                                      .then((value) {
                                    if (value == false) {
                                      churchController.text =
                                          'Igreja não existe!';
                                    } else {
                                      cont++;
                                    }

                                    if (cont == 3) {
                                      setState(() {
                                        _currentStep++;
                                      });
                                    }
                                    setState(() {
                                      showProgress = false;
                                    });
                                  });
                                });
                              });

                              break;
                            case 1:
                              setState(() {
                                showProgress = true;
                              });
                              if (checkedValue == true) {
                                apiForm
                                    .getChurch(churchController.text)
                                    .then((value) {
                                  setState(() {
                                    print(value['id']);
                                    idAdress = value['adress']['id'];
                                    print('ADRESSS: $idAdress');
                                    idChurch = value['id'];
                                  });

                                  submiDataFunction();
                                });
                              } else {
                                apiForm
                                    .getChurch(churchController.text)
                                    .then((value) {
                                  setState(() {
                                    idAdress = 0;
                                    adressMap = {
                                      "zip_code": zipCodeController.text,
                                      "adress": adressController.text,
                                      "number": numberController.text,
                                      "city": cityController.text,
                                      "uf": stateController.text,
                                      "district": districtController.text
                                    };
                                  });
                                  submiDataFunction();
                                });
                              }

                              break;
                          }
                        }
                      },
                      steps: [
                        Step(
                          isActive: _currentStep >= 0,
                          title: Text("Informações"),
                          content: Form(
                            key: _formKey[0],
                            child: infoMissionaryForm(),
                          ),
                        ),
                        Step(
                          isActive: _currentStep >= 1,
                          title: Text("Endereço"),
                          content: Form(
                            key: _formKey[1],
                            child: addresForm(),
                          ),
                        ),
                      ],
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

  void submiDataFunction() {
    _futureProject = submitData();
    setState(() {
      showProgress = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return FutureBuilder<Project?>(
            future: _futureProject,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return LoginPage(
                  isRegister: true,
                );
              } else if (snapshot.hasError) {
                return ErrorScreen(
                  text: '${snapshot.error}',
                );
              }

              return LoadingScreen();
            },
          );
        },
      ),
    );
  }

  Widget infoMissionaryForm() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FieldClass(
                controller: nameController,
                id: 'basic',
                hint: 'Ex: Jesus Visitando Familias',
                label: 'Nome do Projeto',
              ),
              FieldClass(controller: emailController, id: 'email'),
              //MODIFICAR PARA CHECAR SE EXISTE
              FieldClass(
                controller: usernameController,
                id: 'username',
              ),
              FieldClass(
                controller: churchController,
                id: 'church',
              ),
              FieldClass(
                controller: passwordController,
                id: 'password',
              ),
              FieldClass(
                controller: confirmPasswordController,
                id: 'password',
                label: 'Confirma Senha',
                validator: (text) {
                  text = confirmPasswordController.text;
                  String text2 = passwordController.text;
                  if (text.length != text2.length || text != text2) {
                    return "Senhas não coincidem";
                  }
                  return null;
                },
              ),
            ],
          ),
          Visibility(
            visible: showProgress,
            child: Center(
              heightFactor: 15,
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget addresForm() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CheckboxListTile(
            activeColor: Colors.green,
            title: Text("Usar Endereço da Igreja"),
            contentPadding: EdgeInsets.all(2),
            value: checkedValue,
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          checkedValue == false
              ? ExpansionTile(
                  title: Text(''),
                  initiallyExpanded: true,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: FieldClass(
                                controller: contactController, id: 'contact')),
                        SizedBox(width: 5),
                        Expanded(
                          child: FieldClass(
                            controller: zipCodeController,
                            id: 'zipCode',
                            onChangedVar: (String text) {
                              cep = apiForm
                                  .getCep(zipCodeController.text)
                                  .then((map) {
                                String? erro = map['erro'];

                                print('ERRO RECEIVE $erro');
                                if (erro != "true") {
                                  print("ENTROU NA 1 $map");
                                  cityController.text = map["localidade"];
                                  stateController.text = map["uf"];
                                  districtController.text = map['bairro'];
                                  adressController.text = map['logradouro'];
                                } else {
                                  print("ENTRANDO AQUI: $map");
                                  setState(() {
                                    cityController.clear();
                                    stateController.text = "";
                                    districtController.text = "";
                                    adressController.clear;
                                  });
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    CityState(
                        cityController: cityController,
                        stateController: stateController),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: FieldClass(
                            id: 'basic',
                            controller: districtController,
                            hint: 'Bela Vista',
                            label: 'Bairro',
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: FieldClass(
                            controller: numberController,
                            id: 'number',
                            label: 'Nº',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: FieldClass(
                            id: 'basic',
                            controller: adressController,
                            label: 'Logradouro',
                            hint: 'R. Odomirio Ribeiro',
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
