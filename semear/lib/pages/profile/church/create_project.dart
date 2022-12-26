import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/user_model.dart';

// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:semear/pages/register/formsFields/city_state_field.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';
import 'package:semear/validators/fields_validations.dart';
import 'package:semear/widgets/circular_progress.dart';
import 'package:semear/widgets/erroScreen.dart';

ApiForm apiForm = ApiForm();
Validations validations = Validations();

class CreateProject extends StatefulWidget {
  CreateProject({super.key, required this.user});
  User? user;
  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  int _currentStep = 0;
  late int? id = widget.user!.id;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  late var church = userBloc.outCategoryValue![id];
  late var user = userBloc.outUserValue![id];

  TextEditingController nameController = TextEditingController();
  TextEditingController churchController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();

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
          "username": usernameController.text.toString(),
          "category": "project",
          "can_post": true,
          "email": null.toString(),
          "password": null,
          "is_active": true
        },
        "adress": adressMap,
        "church": null,
        "id_church": idChurch,
        "id_adress": idAdress,
        "name": nameController.text,
        "information": null
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      print("STATUS CODE ${response.statusCode}");
      throw Exception('Falha ao registrar');
    }
  }

  final List<GlobalKey<FormState>> _formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  late Future<Map<String, dynamic>> cep;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Criar Novo Projeto'),
          backgroundColor: Colors.green,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          )),
      body: SafeArea(
        child: StreamBuilder<Project?>(
            stream: profileBloc.outProjectCreated,
            initialData: profileBloc.outProjectCreatedValue,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                profileBloc.inProjectCreated.add(null);
                Navigator.pop(context);
              } else if (snapshot.hasError) {
                final snackBar = SnackBar(
                  content: Text('Erro'),
                  backgroundColor: Colors.redAccent,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              return Stack(
                children: [
                  Container(
                    color: Colors.white,
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

                              if (_formKey[_currentStep]
                                  .currentState!
                                  .validate()) {
                                switch (_currentStep) {
                                  case 0:
                                    setState(() {
                                      showProgress = true;
                                    });

                                    apiForm
                                        .checkUsername(usernameController.text)
                                        .then((value) {
                                      if (value == true) {
                                        usernameController.text =
                                            'Nome de usuário já existe';
                                      } else {
                                        setState(() {
                                          _currentStep++;
                                        });
                                      }
                                    });

                                    break;
                                  case 1:
                                    setState(() {
                                      showProgress = true;

                                      if (checkedValue == true) {
                                        idAdress = church.adress.id;
                                        print('ADRESSS: $idAdress');
                                        idChurch = church.id;
                                        submiDataFunction();
                                      } else {
                                        idAdress = 0;
                                        idChurch = church.id;
                                        adressMap = {
                                          "zip_code": zipCodeController.text,
                                          "adress": adressController.text,
                                          "number": numberController.text,
                                          "city": cityController.text,
                                          "uf": stateController.text,
                                          "district": districtController.text
                                        };
                                        submiDataFunction();
                                      }
                                      showProgress = false;
                                    });

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
                                  child: projectForm(),
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
              );
            }),
      ),
    );
  }

  void submiDataFunction() async {
    setState(() {
      showProgress = true;
    });
    await submitData()!.then((value) {
      profileBloc.inProjectCreated.add(value);
    });
    setState(() {
      showProgress = false;
    });
  }

  Widget projectForm() {
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
              //FieldClass(controller: emailController, id: 'email'),
              //MODIFICAR PARA CHECAR SE EXISTE
              FieldClass(
                controller: usernameController,
                id: 'username',
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
