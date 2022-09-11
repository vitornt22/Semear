// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:semear/pages/login_page.dart';
import 'package:semear/widgets/forms_field.dart';

class DonorRegister extends StatefulWidget {
  const DonorRegister({super.key});

  @override
  State<DonorRegister> createState() => _DonorRegisterState();
}

class _DonorRegisterState extends State<DonorRegister> {
  final int _currentStep = 0;

  TextEditingController controller = TextEditingController();

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 100),
                          FormsField(
                            keyboard: TextInputType.text,
                            controller: controller,
                            label: 'Nome Completo',
                            hintText: 'ex: Francisca da Silva Feitosa',
                            sizeBoxHeigth: 10,
                          ),
                          FormsField(
                            keyboard: TextInputType.text,
                            controller: controller,
                            label: 'Email',
                            hintText: 'ex: osvaldovieira@gmail.com',
                            sizeBoxHeigth: 10,
                          ),
                          FormsField(
                            keyboard: TextInputType.text,
                            controller: controller,
                            label: 'Nome de Usuário',
                            hintText: 'ex: osvaldovieira',
                            sizeBoxHeigth: 10,
                          ),
                          FormsField(
                            keyboard: TextInputType.text,
                            controller: controller,
                            label: 'Senha',
                            hintText: 'ex: osvaldovieira@gmail.com',
                            sizeBoxHeigth: 10,
                          ),
                          FormsField(
                            keyboard: TextInputType.text,
                            controller: controller,
                            label: 'Confirmar Senha',
                            hintText: 'ex: osvaldovieira@gmail.com',
                            sizeBoxHeigth: 10,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return LoginPage(
                                          category: 'donor',
                                          redirect: 'initial',
                                        );
                                      },
                                    ),
                                  );
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
