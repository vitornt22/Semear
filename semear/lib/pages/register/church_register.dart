// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:flutter/material.dart';
import 'package:semear/models/city.dart';
import 'package:semear/models/uf.dart';
import 'package:semear/pages/login_page.dart';
import 'package:semear/pages/register/validations.dart';
import 'package:semear/widgets/alert.dart';
import 'package:semear/widgets/forms_field.dart';

Validations validations = Validations();

class ChurchRegister extends StatefulWidget {
  const ChurchRegister({super.key});

  @override
  State<ChurchRegister> createState() => _ChurchRegisterState();
}

class _ChurchRegisterState extends State<ChurchRegister> {
  int _currentStep = 0;
  bool enableCity = false;
  final AutovalidateMode _validate = AutovalidateMode.onUserInteraction;

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
  TextEditingController controller = TextEditingController();

  bool valida = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> erros = [];
  String compare = "";
  int? ufCode;

  static Future<List<UF>> getUfs(String? query) async {
    http.Response response = await http.get(Uri.parse(
        "https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome"));

    final List ufs = json.decode(response.body);
    return ufs.map((json) => UF.fromJson(json)).where((user) {
      final nameLower = user.nome!.toLowerCase();
      final queryLower = query!.toLowerCase();

      return nameLower.contains(queryLower);
    }).toList();
  }

  Future<List<City>> getCities(String? query) async {
    http.Response response = await http.get(Uri.parse(
        "https://servicodados.ibge.gov.br/api/v1/localidades/estados/$ufCode/municipios"));
    final List cities = json.decode(response.body);
    return cities.map((json) => City.fromJson(json)).where((user) {
      final nameLower = user.nome!.toLowerCase();
      final queryLower = query!.toLowerCase();

      return nameLower.contains(queryLower);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    getCities(cityController.text).then((map) => print(map));
  }

  Future<Map> verifyCnpj() async {
    print('CNPJ ${cnpjController.text}');
    http.Response response = await http
        .get(Uri.parse("https://publica.cnpj.ws/cnpj/${cnpjController.text}"));

    print(response.body);
    return json.decode(response.body);
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
                  child: Form(
                    autovalidateMode: _validate,
                    key: _formKey,
                    child: Stepper(
                        type: StepperType.horizontal,
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
                        onStepContinue: () async {
                          print(cnpjController.text);
                          String id = "", activity = "", statusRegister = "";
                          int statusCode = 0;

                          if (_currentStep < 1) {
                            if (cnpjController.text.length == 14) {
                              valida =
                                  compare == cnpjController.text ? true : false;
                              //Aguardando validação de cnpj
                              if (valida == false) {
                                Map verify = await verifyCnpj();
                                try {
                                  id = verify["natureza_juridica"]["id"];
                                  statusRegister = verify["estabelecimento"]
                                      ["situacao_cadastral"];
                                  activity = verify["estabelecimento"]
                                      ["atividade_principal"]["id"];
                                } catch (e) {
                                  statusCode = verify["status"];
                                }

                                if (statusCode == 429) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertBox(
                                          title:
                                              "Aguarde um pouco até a próxima requisição",
                                          text:
                                              "Possuimos um limite para requisição de validação, aguarde um pouco até conseguir novamente",
                                          sizeBox: 40);
                                    },
                                  );
                                } else if ((id == "3220" || id == "3999") &&
                                    activity == "9491000" &&
                                    statusRegister == "Ativa") {
                                  compare = cnpjController.text;
                                  setState(() {
                                    valida = true;
                                    _currentStep++;
                                  });
                                } else {
                                  valida = false;
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertBox(
                                          title: "CNPJ INVÁLIDO",
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
                            } else {
                              setState(() {
                                valida = false;
                              });
                            }
                          }

                          if (_currentStep < 2 &&
                              _formKey.currentState!.validate() &&
                              valida == true) {
                            setState(() {
                              _currentStep++;
                            });
                          } else if (_currentStep > 2) {
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginPage(
                                    category: 'church',
                                    redirect: 'initial',
                                  );
                                },
                              ),
                            );
                          }
                        },
                        steps: [
                          Step(
                              isActive: _currentStep >= 0,
                              title: Text("Validação"),
                              content: validationChurchForm()),
                          Step(
                            isActive: _currentStep >= 1,
                            title: Text("Informações"),
                            content: infoChurchForms(),
                          ),
                          Step(
                            isActive: _currentStep >= 2,
                            title: Text("Dados"),
                            content: dataChurchForms(),
                          ),
                        ]),
                  ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 55),
          FormsField(
            keyboard: TextInputType.number,
            cnpjController: cnpjController,
            formkey: _formKey,
            mask: '##############',
            controller: cnpjController,
            validator: validations.checkCnpjValidation,
            label: 'CNPJ',
            hintText: 'ex: 11.111.111/0001-11',
          ),
          FormsField(
            keyboard: TextInputType.text,
            validator: validations.checkEmpty,
            controller: denominationController,
            label: 'Denominação',
            hintText: 'ex: Assembleia de Deus',
          ),
          FormsField(
            keyboard: TextInputType.text,
            controller: ministeryController,
            label: 'Ministério',
            hintText: 'ex: Missão',
          )
        ],
      ),
    );
  }

  Widget infoChurchForms() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormsField(
            autofill: const [AutofillHints.email],
            keyboard: TextInputType.emailAddress,
            controller: emailController,
            label: 'Email',
            validator: validations.checkEmail,
            hintText: 'ex: semear@gmail.com',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            keyboard: TextInputType.text,
            controller: nameController,
            label: 'Nome de Usuário',
            validator: validations.checkEmpty,
            hintText: 'ex: semear123',
            sizeBoxHeigth: 10,
          ),
          Row(
            children: [
              Expanded(
                child: FormsField(
                  keyboard: TextInputType.text,
                  controller: passwordController,
                  label: 'Senha',
                  hintText: '',
                  sizeBoxHeigth: 10,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: FormsField(
                  keyboard: TextInputType.text,
                  controller: confirmPasswordController,
                  label: 'Confirmar Senha',
                  hintText: '',
                  sizeBoxHeigth: 10,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormsField(
                  mask: '(##)#####-####',
                  keyboard: TextInputType.number,
                  controller: contactController,
                  label: 'Contato',
                  hintText: 'ex: (89)99929-2922',
                  sizeBoxHeigth: 10,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: FormsField(
                  keyboard: TextInputType.text,
                  controller: zipCodeController,
                  mask: "#####-###",
                  label: 'CEP',
                  hintText: 'ex: 64690-000',
                  sizeBoxHeigth: 10,
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
                  controller: adressController,
                  label: 'Endereço',
                  hintText: 'ex: Rua.Odomirio Ribeiro',
                  sizeBoxHeigth: 10,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: FormsField(
                  keyboard: TextInputType.text,
                  controller: numberController,
                  label: 'Nº',
                  hintText: 'ex: 217',
                  sizeBoxHeigth: 10,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 50,
                  child: TypeAheadFormField(
                    hideOnEmpty: true,
                    enabled: stateController.text.isEmpty ? false : true,
                    hideSuggestionsOnKeyboardHide: true,
                    hideKeyboard: stateController.text.isEmpty ? true : false,
                    getImmediateSuggestions: false,
                    suggestionsCallback: (pattern) =>
                        getCities(cityController.text),
                    itemBuilder: (context, City item) => ListTile(
                      title: Text("${item.nome}"),
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                      onChanged: (context) {
                        if (stateController.text.isEmpty) {
                          cityController.text = "";

                          setState(() {
                            ufCode = null;
                          });
                        }
                      },
                      controller: cityController,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              cityController.text = "";
                            },
                            icon: Icon(
                              Icons.cancel,
                              size: 15,
                            )),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffa23673A)),
                        ),
                        floatingLabelStyle: TextStyle(color: Colors.green),
                        filled: false,
                        hintText: "Cidade",
                        focusedBorder: OutlineInputBorder(
                          gapPadding: 5,
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    onSuggestionSelected: (City val) {
                      if (stateController.text.isNotEmpty) {
                        cityController.text = val.nome!;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TypeAheadFormField(
                    hideOnEmpty: true,
                    suggestionsCallback: (pattern) =>
                        getUfs(stateController.text),
                    itemBuilder: (context, UF item) => ListTile(
                      title: Text("${item.nome}"),
                    ),
                    textFieldConfiguration: TextFieldConfiguration(
                        controller: stateController,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(style: BorderStyle.solid)),
                          suffixIcon: IconButton(
                              onPressed: () {
                                stateController.text = "";
                                setState(() {
                                  ufCode = null;
                                });
                              },
                              icon: Icon(
                                Icons.cancel,
                                size: 15,
                              )),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffa23673A)),
                          ),
                          floatingLabelStyle: TextStyle(color: Colors.green),
                          filled: false,
                          hintText: "UF",
                          focusedBorder: OutlineInputBorder(
                            gapPadding: 5,
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        onChanged: (context) {
                          if (stateController.text.isEmpty) {
                            setState(() {
                              enableCity = false;
                              ufCode = null;
                            });
                          }
                        }),
                    onSuggestionSelected: (UF val) {
                      stateController.text = val.nome!;
                      setState(() {
                        ufCode = val.id;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: FormsField(
                  keyboard: TextInputType.text,
                  controller: districtController,
                  validator: validations.checkEmpty,
                  label: 'Bairro',
                  hintText: 'ex: Bela Vista',
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: FormsField(
                  keyboard: TextInputType.datetime,
                  controller: fundationController,
                  label: 'Fundação',
                ),
              ),
            ],
          ),
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Divider(
                        thickness: 1,
                        color: Colors.green,
                      ),
                      FormsField(
                        keyboard: TextInputType.text,
                        controller: controller,
                        label: 'Nome do Titular',
                        hintText: 'Ex: Joao Gomes da Silva',
                        sizeBoxHeigth: 10,
                      ),
                      FormsField(
                        keyboard: TextInputType.text,
                        controller: controller,
                        label: 'CPF/CNPJ',
                        hintText: 'Digite o CPF OU CNPJ',
                        sizeBoxHeigth: 10,
                      ),
                      FormsField(
                        keyboard: TextInputType.text,
                        controller: controller,
                        label: 'Banco',
                        hintText: 'Digite o CPF OU CNPJ',
                        sizeBoxHeigth: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: FormsField(
                              keyboard: TextInputType.text,
                              controller: controller,
                              label: 'Agência',
                              sizeBoxHeigth: 10,
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: FormsField(
                              keyboard: TextInputType.text,
                              controller: controller,
                              label: 'Digito',
                              sizeBoxHeigth: 10,
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
                              controller: controller,
                              label: 'Conta',
                            ),
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: FormsField(
                              keyboard: TextInputType.text,
                              controller: controller,
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
        SizedBox(height: 10),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Divider(
                      thickness: 1,
                      color: Colors.green,
                    ),
                    FormsField(
                      keyboard: TextInputType.text,
                      controller: controller,
                      label: 'Tipo de Chave ',
                      sizeBoxHeigth: 10,
                    ),
                    FormsField(
                      keyboard: TextInputType.text,
                      controller: controller,
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
}
