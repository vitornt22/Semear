import 'package:flutter/material.dart';

// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:semear/pages/login_page.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';
import 'package:semear/pages/register/formsFields/forms_field.dart';
import 'package:semear/pages/register/project_forms.dart';

class ProjectRegister extends StatefulWidget {
  const ProjectRegister({super.key});

  @override
  State<ProjectRegister> createState() => _ProjectRegisterState();
}

class _ProjectRegisterState extends State<ProjectRegister> {
  int _currentStep = 0;
  bool showProgress = false;

  TextEditingController cnpjController = TextEditingController();
  TextEditingController denominationController = TextEditingController();
  TextEditingController ministeryController = TextEditingController();

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
                    onStepContinue: () {
                      if (_currentStep < 2) {
                        setState(() {
                          _currentStep++;
                        });
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginPage(
                                category: 'project',
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
                        content: validationProjectForm(),
                      ),
                      Step(
                        isActive: _currentStep >= 1,
                        title: Text("Dados"),
                        content: ContactProjectForm(),
                      ),
                      Step(
                        isActive: _currentStep >= 2,
                        title: Text("Descrição"),
                        content: InfoProjectForm(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget validationProjectForm() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 55),
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
                child: CircularProgressIndicator(),
              )),
        ],
      ),
    );
  }
}
