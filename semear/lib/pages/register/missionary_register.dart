import 'package:flutter/material.dart';

// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:semear/pages/home_screen.dart';
import 'package:semear/pages/login_page.dart';
import 'package:semear/pages/register/missionary_form.dart';
import 'package:semear/pages/register/project_forms.dart';

import 'church_forms.dart';

class MissionaryRegister extends StatefulWidget {
  const MissionaryRegister({super.key});

  @override
  State<MissionaryRegister> createState() => _MissionaryRegisterState();
}

class _MissionaryRegisterState extends State<MissionaryRegister> {
  int _currentStep = 0;

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
                        if (_currentStep < 3) {
                          setState(() {
                            _currentStep++;
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return LoginPage(
                                  category: 'missionary',
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
                          title: Text("Informações"),
                          content: InfoMissionaryForm(),
                        ),
                        Step(
                          isActive: _currentStep >= 1,
                          title: Text("Endereço"),
                          content: DataMissionaryForm(),
                        ),
                        Step(
                          isActive: _currentStep >= 2,
                          title: Text("Dados bancários"),
                          content: DataBankForm(),
                        ),
                        Step(
                          isActive: _currentStep >= 3,
                          title: Text("Perfil"),
                          content: ProfileMissionaryForm(),
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
}
