// ignore_for_file: use_full_hex_values_for_flutter_colors, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/models/church_model.dart';
import 'package:semear/pages/login_page.dart';
import 'package:semear/pages/register/formsFields/city_state_field.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';
import 'package:semear/pages/register/validations.dart';
import 'package:semear/widgets/alert.dart';
import 'package:semear/pages/register/formsFields/forms_field.dart';
import 'package:semear/widgets/circular_progress.dart';
import 'package:semear/widgets/erroScreen.dart';

import '../../models/bank.dart';

Validations validations = Validations();
ApiForm apiForm = ApiForm();

class ChurchRegister extends StatefulWidget {
  const ChurchRegister({super.key});

  @override
  State<ChurchRegister> createState() => _ChurchRegisterState();
}

class _ChurchRegisterState extends State<ChurchRegister> {
  int _currentStep = 0;
  Bank? selectedItem;
  bool showProgress = false;

  TextEditingController denominationController = TextEditingController();
  TextEditingController ministeryController = TextEditingController();
  TextEditingController cnpjController = TextEditingController();
  TextEditingController nameController = TextEditingController();
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
  TextEditingController fundationController = TextEditingController();
  //PROVISORIO
  //bank
  TextEditingController titularNamecontroller = TextEditingController();
  TextEditingController agencyController = TextEditingController();
  TextEditingController agencyDigitController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController accountDigitController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController codeController = TextEditingController();

  // PI
  TextEditingController keyTypeController = TextEditingController();
  TextEditingController keyValueController = TextEditingController();

  bool valida = true;

  final List<GlobalKey<FormState>> _formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>()
  ];

  List<String> erros = [];
  String compare = "";
  int ufCode = 0;
  int stop = 1;
  String siglaUF = "LL";
  String? dropdownValue;
  static List<String> keyTypes = <String>['CNPJ', 'EMAIL', 'CELULAR'];

  late Future<Map<String, dynamic>> cep;
  Future<Church?>? _futureChurch;

  Future<Church?>? submitData() async {
    http.Response response = await http.post(
      Uri.parse('https://backend-semear.herokuapp.com/church/api/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "user": {
          "username": usernameController.text,
          "email": emailController.text,
          "category": "church",
          "can_post": true,
          "password": passwordController.text
        },
        "adress": {
          "zip_code": zipCodeController.text,
          "adress": adressController.text,
          "number": numberController.text,
          "city": cityController.text,
          "uf": stateController.text,
          "district": districtController.text
        },
        "bankData": {
          "holder": titularNamecontroller.text,
          "cnpj": cnpjController.text,
          "bank": codeController.text,
          "agency": agencyController.text,
          "digitAgency": agencyDigitController.text,
          "account": accountController.text,
          "digitAccount": accountDigitController.text
        },
        "pix": {
          "typeKey": keyTypeController.text,
          "valueKey": keyValueController.text
        },
        "cnpj": cnpjController.text,
        "ministery": ministeryController.text,
        "name": nameController.text
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Church.fromJson(json.decode(response.body));
    } else {
      print("STATUS CODE ${response.statusCode}");
      throw Exception('Falha ao registrar');
    }
  }

  getCep() async {
    String cep = zipCodeController.text.replaceAll(RegExp(r'[^\w\s]+'), '');
    http.Response response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json"));

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    apiForm.getCities(cityController.text, siglaUF).then((map) => print(map));
    getCep().then((map) => print(map));
  }

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
                    image: const AssetImage('assets/images/projeto.jpg')),
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
                  child: Stepper(
                      type: StepperType.horizontal,
                      currentStep: _currentStep,
                      physics: const ScrollPhysics(),
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() {
                            _currentStep--;
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      onStepContinue: () async {
                        if (_formKey[_currentStep].currentState!.validate()) {
                          switch (_currentStep) {
                            case 0:
                              //Define vars to validate cnpj
                              setState(() {
                                showProgress = true;
                              });
                              verifica();
                              break;
                            case 1:
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

                                  if (cont == 2) {
                                    setState(() {
                                      _currentStep++;
                                    });
                                  }
                                  setState(() {
                                    showProgress = false;
                                  });
                                });
                              });

                              break;
                            case 2:
                              _futureChurch = submitData();

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FutureBuilder<Church?>(
                                  future: _futureChurch,
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

                                    return const LoadingScreen();
                                  },
                                );
                              }));
                              break;
                          }
                        }
                      },
                      steps: [
                        Step(
                          isActive: _currentStep >= 0,
                          title: const Text("Validação"),
                          content: Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: _formKey[0],
                            child: validationChurchForm(),
                          ),
                        ),
                        Step(
                          isActive: _currentStep >= 1,
                          title: const Text("Informações"),
                          content: Form(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            key: _formKey[1],
                            child: infoChurchForms(),
                          ),
                        ),
                        Step(
                          isActive: _currentStep >= 2,
                          title: const Text("Dados"),
                          content: Form(
                            key: _formKey[2],
                            child: dataChurchForms(),
                          ),
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget validationChurchForm() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 55),
              FieldClass(controller: cnpjController, id: 'cnpj'),
              FieldClass(
                controller: denominationController,
                id: 'basic',
                label: 'Denominação',
                hint: 'Ex: Assembleia de Deus',
              ),
              FormsField(
                keyboard: TextInputType.text,
                controller: ministeryController,
                label: 'Ministério',
                hintText: 'ex: Missão',
              )
            ],
          ),
          Center(
              heightFactor: 15,
              child: Visibility(
                visible: showProgress,
                child: const CircularProgressIndicator(),
              )),
        ],
      ),
    );
  }

  Widget infoChurchForms() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FieldClass(controller: emailController, id: 'email'),
              //MODIFICAR PARA CHECAR SE EXISTE
              FieldClass(
                controller: usernameController,
                id: 'basic',
                label: 'Nome de Usuário',
                hint: 'ex:semear123',
              ),
              Row(
                children: [
                  Expanded(
                    child: FieldClass(
                      controller: passwordController,
                      id: 'password',
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: FieldClass(
                      controller: confirmPasswordController,
                      id: 'password',
                      validator: (text) {
                        text = confirmPasswordController.text;
                        String text2 = passwordController.text;
                        if (text.length != text2.length || text != text2) {
                          return "Senhas não coincidem";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: FieldClass(
                        controller: contactController, id: 'contact'),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                      child: FieldClass(
                    controller: zipCodeController,
                    id: 'zipCode',
                    onChangedVar: (String text) {
                      cep = getCep().then((map) {
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
                  )),
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
                      )),
                  const SizedBox(width: 5),
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
              const SizedBox(
                height: 10,
              )
            ],
          ),
          Visibility(
              visible: showProgress,
              child: const Center(
                heightFactor: 20,
                child: CircularProgressIndicator(),
              ))
        ],
      ),
    );
  }

  Widget dataChurchForms() {
    return Column(
      children: [
        Card(
          elevation: 10,
          color: Colors.white,
          child: ExpansionTile(
              textColor: const Color(0xffa23673A),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    SizedBox(),
                    Expanded(
                      child: Text(
                        'Conta Bancária',
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 1,
                        color: Colors.green,
                      ),
                      FieldClass(
                        controller: titularNamecontroller,
                        id: 'basic',
                        label: 'Nome do Titular',
                      ),
                      FieldClass(controller: cnpjController, id: 'cnpj'),
                      FieldClass(
                        controller: bankController,
                        id: 'bank',
                        codeBankController: codeController,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: FieldClass(
                                id: 'agency',
                                controller: agencyController,
                              )),
                          const SizedBox(width: 5),
                          Expanded(
                            child: FieldClass(
                              id: 'digit',
                              controller: agencyDigitController,
                              label: 'Digito',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: FormsField(
                              keyboard: TextInputType.text,
                              controller: accountController,
                              label: 'Conta',
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: FormsField(
                              keyboard: TextInputType.text,
                              controller: accountDigitController,
                              label: 'Digito',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ]),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 10,
          color: Colors.white,
          child: ExpansionTile(
            textColor: const Color(0xffa23673A),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(),
                  Expanded(
                    child: Text(
                      'PIX',
                    ),
                  ),
                ],
              ),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      color: Colors.green,
                    ),
                    InputDecorator(
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                            validator: validations.checkEmpty,
                            isExpanded: true,
                            hint: const Text('Tipo de chave'),
                            value: dropdownValue,
                            alignment: Alignment.center,
                            onChanged: (String? selectedValue) {
                              setState(() {
                                dropdownValue = selectedValue;
                                keyTypeController.text = selectedValue!;
                              });
                            },
                            items: keyTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
                      ),
                    ),
                    FormsField(
                      keyboard: TextInputType.text,
                      controller: keyValueController,
                      label: 'Valor da Chave',
                      sizeBoxHeigth: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void verifica() {
    String cnpjCheck = cnpjController.text,
        id = "",
        activity = "",
        statusRegister = "";
    int statusCode = 0;

    apiForm.checkCnpj(cnpjController.text).then((value) async {
      if (value == true) {
        cnpjController.text = '                 ';
      } else {
        valida = compare == cnpjCheck ? true : false;
        if (valida == false && compare != cnpjCheck) {
          Map verify = await apiForm.verifyCnpj(cnpjController.text);

          try {
            id = verify["natureza_juridica"]["id"];
            statusRegister = verify["estabelecimento"]["situacao_cadastral"];
            activity = verify["estabelecimento"]["atividade_principal"]["id"];
          } catch (e) {
            statusCode = verify["status"];
          }

          if (statusCode == 429) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertBox(
                    title: "Aguarde um pouco até a próxima requisição",
                    text:
                        "Possuimos um limite para requisição de validação, aguarde um pouco até conseguir novamente",
                    sizeBox: 40);
              },
            );
          } else if ((id == "3220" || id == "3999") &&
              activity == "9491000" &&
              statusRegister == "Ativa") {
            print(verify);

            setState(() {
              compare = cnpjController.text;
              valida = true;
              _currentStep++;
            });
          } else if (cnpjController.text != 'CNPJ já existe') {
            setState(() {
              valida = false;
              compare = "";
            });
            showDialog(
              context: context,
              builder: (context) {
                return AlertBox(
                    title: "CNPJ INVÁLIDO OU JÁ EXISTENTE",
                    text:
                        "Para que possamos comprovar que é uma igreja, o CNPJ deve estar ativo, e ser cadastrado como atividade de organizações religiosas. ",
                    sizeBox: 80);
              },
            );
          }
        } else {
          setState(() {
            _currentStep++;
          });
        }
      }
      setState(() {
        showProgress = false;
      });
    });
  }
}
