// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/blocs/edit_profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:http/http.dart' as http;

class EditAccount extends StatefulWidget {
  EditAccount({super.key, required this.user});

  User user;

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordSaves = TextEditingController();

  String? saveEmail, saveUsername;

  bool checkedValue = true;
  ApiForm apiForm = ApiForm();

  final editBloc = EditProfileBloc();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  late Future<Map<String, dynamic>> cep;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formCode = GlobalKey<FormState>();
  GlobalKey<FormState> formChange = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordSaves.text = '';
    emailController.text = userBloc.outUserValue![widget.user.id]!.email!;
    editBloc.inStatus.add(false);
    usernameController.text = userBloc.outUserValue![widget.user.id]!.username!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Apagar Conta',
                  style: TextStyle(color: Colors.redAccent, fontSize: 15),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.delete,
                  size: 20,
                  color: Colors.redAccent,
                )
              ],
            ),
          ),
        ),
        appBar: AppBar(
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(
                                  'Deseja alterar dos dados da sua conta?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Recusar'),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final navigator = Navigator.of(context);
                                      final scafolld =
                                          ScaffoldMessenger.of(context);
                                      editBloc.inLoading.add(true);
                                      final a = await submit();
                                      editBloc.inLoading.add(false);
                                      if (a != null) {
                                        navigator.popUntil(
                                            (route) => route.isFirst == true);
                                        scafolld.showSnackBar(snackBar(
                                            'Dados alterados!', 'success'));
                                        userBloc.updateUser(a);
                                        userBloc.updatePasswordOrEmail(
                                            'email', emailController.text);
                                      } else {
                                        navigator.pop();
                                        scafolld.showSnackBar(snackBar(
                                            'Dados alterados!', 'error'));
                                      }
                                    },
                                    child: const Text('Alterar'),
                                  ),
                                ],
                              ));
                      submit();
                    }
                  },
                  icon: Icon(Icons.check)),
            )
          ],
          backgroundColor: Colors.green,
          title: Row(
            children: const [
              Text('Dados da Conta'),
              SizedBox(width: 5),
              Icon(Icons.edit)
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    StreamBuilder<bool?>(
                        stream: editBloc.outCheckUsername,
                        initialData: editBloc.outCheckUsernameValue,
                        builder: (context, snapshot) {
                          return field(
                            'Username',
                            usernameController,
                            snapshot,
                          );
                        }),
                    StreamBuilder<bool?>(
                        stream: editBloc.outCheckEmail,
                        initialData: editBloc.outCheckEmailValue,
                        builder: (context, snapshot) {
                          return field('Email', emailController, snapshot);
                        }),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: textButton('Alterar Senha', () {
                      showDialog(
                          context: context,
                          builder: (context) => StreamBuilder<bool>(
                              stream: editBloc.outStatusController,
                              initialData: editBloc.outStatusControllerValue,
                              builder: (context, snapshot) {
                                confirmPasswordController.clear();
                                passwordController.clear();
                                return AlertDialog(
                                  title: Text('Enviar Código para meu email?'),
                                  content: StreamBuilder<bool>(
                                      stream: editBloc.outLoadingController,
                                      initialData:
                                          editBloc.outLoadingControllerValue,
                                      builder: (context, snap) {
                                        return snap.data == true
                                            ? CircularProgressIndicator(
                                                color: Colors.green)
                                            : sendCode();
                                      }),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar')),
                                    TextButton(
                                        onPressed: () {
                                          if (editBloc
                                                  .outStatusControllerValue ==
                                              true) {
                                            // await confirmation code
                                            if (formCode.currentState!
                                                .validate()) {
                                              editBloc.inLoading.add(true);
                                              Timer.periodic(
                                                  Duration(seconds: 5),
                                                  (timer) {
                                                codeController.clear();
                                                editBloc.inStatus.add(false);
                                                editBloc.inLoading.add(false);
                                                Navigator.of(context).pop();
                                                showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        changePasswordDialog());
                                              });
                                            }
                                          } else {
                                            editBloc.inStatus.add(true);
                                          }
                                        },
                                        child: Text('Enviar'))
                                  ],
                                );
                              }));
                    }),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  void changeChecked(data, snapshot, category) async {
    final value;
    if (category == 'Email') {
      value = await apiForm.checkEmail(data);
      editBloc.inCheckEmail.add(value);
    } else if (category == 'Username') {
      value = await apiForm.checkUsername(data);
      editBloc.inCheckUsername.add(value);
    }
  }

  Widget? getSuffix(category, snapshot, controller) {
    final value =
        category == 'Email' ? widget.user.email : widget.user.username;
    if (controller.text != value || controller.text.isNotEmpty) {
      if (snapshot.data == true) {
        return Icon(Icons.cancel);
      } else if (snapshot.data == false) {
        return Icon(Icons.check);
      }
    }
    return null;
  }

  Widget changePasswordDialog() {
    return AlertDialog(
      elevation: 10,
      title: Text('Mudar Senha'),
      content: StreamBuilder<bool>(
          stream: editBloc.outLoadingController,
          initialData: editBloc.outLoadingControllerValue,
          builder: (context, snapshot) {
            return snapshot.data == true
                ? SizedBox(
                    width: 10,
                    height: 10,
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : Container(
                    width: MediaQuery.of(context).size.height * 0.8,
                    child: Form(
                      key: formChange,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: passwordController,
                            validator: checkChangePasswrod,
                            decoration: InputDecoration(
                              labelText: 'Digite a nova Senha',
                            ),
                          ),
                          TextFormField(
                            controller: confirmPasswordController,
                            validator: checkConfirmPassword,
                            decoration: InputDecoration(
                              labelText: 'Confirmar a nova Senha',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, 'Recusar'),
          child: const Text('cancelar'),
        ),
        TextButton(
          onPressed: () async {
            final scafolld = ScaffoldMessenger.of(context);
            final navigator = Navigator.of(context);
            if (formChange.currentState!.validate()) {
              editBloc.inLoading.add(true);
              User? value = await changePassword();
              editBloc.inLoading.add(false);
              if (value != null) {
                userBloc.updateUser(value);
                userBloc.updatePasswordOrEmail('password', passwordSaves.text);

                navigator.pop();
                scafolld.showSnackBar(
                    snackBar('Senha Alterada com Sucesso', 'success'));
              } else {
                scafolld.showSnackBar(snackBar('Erro ao mudar senha', 'error'));
              }
            }
          },
          child: const Text('Alterar'),
        ),
      ],
    );
  }

  String? checkChangePasswrod(String? text) {
    if (text!.isEmpty) {
      return 'Campo nao pode ser vazio';
    } else if (text.length < 9) {
      return 'Senha deve ter no minimo 9 caracteres';
    }
    return null;
  }

  String? checkEmailField(String? text) {
    if (text!.isEmpty) {
      editBloc.inCheckEmail.add(null);
      return 'Campo nao pode ser vazio';
    } else if (text.contains('@') == false) {
      editBloc.inCheckEmail.add(true);
      return 'Email invalido';
    } else if (editBloc.outCheckEmailValue == true) {
      return 'Email já existe, tente outro';
    }
    return null;
  }

  String? checkUsernameField(String? text) {
    if (text!.isEmpty) {
      editBloc.inCheckUsername.add(null);

      return 'Campo nao pode ser vazio';
    } else if (editBloc.outCheckUsernameValue == true) {
      return 'Username já existe, tente outro';
    }
    return null;
  }

  String? checkConfirmPassword(String? text) {
    if (text!.isEmpty) {
      return 'Campo nao pode ser vazio';
    } else if (text.length < 9) {
      return 'Senha deve ter no minimo 9 caracteres';
    } else if (text != passwordController.text) {
      return 'Senhas nao coicidem';
    }
    return null;
  }

  snackBar(text, type) {
    final snackBar = SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      backgroundColor: type == 'success' ? Colors.green : Colors.redAccent,
    );
    return snackBar;
  }

  String? codeCheck(String? text) {
    if (text!.isEmpty) {
      return 'Campo nao pode ser vazio';
    }
    if (text.length < 5) {
      return 'Digite todos os caracteres';
    }
    return null;
  }

  Widget sendCode() {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return StreamBuilder<Object>(
              stream: editBloc.outStatusController,
              initialData: editBloc.outStatusControllerValue,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data == true,
                  child: Form(
                    key: formCode,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: codeController,
                          validator: codeCheck,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          decoration: InputDecoration(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Expanded(
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  'Enviamos um codigo para\no seu email,confirme para \nque possa alterar sua senha',
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 202, 49, 49)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Widget textButton(text, onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, left: 8),
          child: GestureDetector(
            onTap: onPressed,
            child: Text(
              text,
              style: TextStyle(color: Color.fromARGB(255, 17, 130, 20)),
            ),
          ),
        ),
      ],
    );
  }

  Widget field(text, controller, snapshot) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(children: [
        Text(
          text,
          style: TextStyle(color: Colors.green),
        ),
        TextFormField(
          validator: text == 'Email' ? checkEmailField : checkUsernameField,
          enabled: true,
          controller: controller,
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(
            suffix: getSuffix(text, snapshot, controller),
          ),
          onChanged: (value) {
            changeChecked(value, snapshot, text);
          },
        ),
      ]),
    );
  }

  Future<User?> returnFunction(jsonStr) async {
    final response = await http.patch(
      Uri.parse(
          "http://backend-semear.herokuapp.com/user/api/${widget.user.id}/"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonStr,
    );
    print("RESPONSE BODY ${response.body}");

    if (response.statusCode == 200) {
      final a = User.fromJson(jsonDecode(response.body));
      userBloc.updateUser(a);
      return a;
    }
    return null;
  }

  Future<User?> changePassword() async {
    final jsonStr = {
      "id": widget.user.id.toString(),
      "password": passwordController.text
    };

    passwordSaves.text = passwordController.text;

    return await returnFunction(jsonEncode(jsonStr));
  }

  Future<User?> submit() async {
    //var image = await imagem.readAsBytes();
    final jsonStr = {
      "id": widget.user.id.toString(),
      "username": usernameController.text,
      "email": emailController.text,
    };

    return await returnFunction(jsonEncode(jsonStr));
  }
}
