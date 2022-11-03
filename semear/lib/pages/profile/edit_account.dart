// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/register/formsFields/city_state_field.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';

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

  bool checkedValue = true;
  ApiForm apiForm = ApiForm();
  late Future<Map<String, dynamic>> cep;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailController.text = widget.user.email!;
    usernameController.text = widget.user.username!;
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
              SizedBox(height: 100),
              field('Username', usernameController),
              field('Email', emailController),
              textButton('Alterar Senha', () {})
            ],
          ),
        ));
  }

  bool isMissionaryOrProjet() {
    if (widget.user.category == 'missionary' ||
        widget.user.category == 'project') {
      return true;
    }
    return false;
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

  Widget field(text, controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(children: [
        Text(
          text,
          style: TextStyle(color: Colors.green),
        ),
        TextFormField(
          controller: controller,
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(),
        ),
      ]),
    );
  }
}
