// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:semear/pages/register/church_register.dart';
import 'package:semear/pages/register/donor_register.dart';
import 'package:semear/pages/register/missionary_register.dart';
import 'package:semear/pages/register/project_register.dart';
import 'package:semear/widgets/outlined_button.dart';

class RegisterType extends StatefulWidget {
  const RegisterType({super.key});

  @override
  State<RegisterType> createState() => _RegisterTypeState();
}

class _RegisterTypeState extends State<RegisterType> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
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
            AppBar(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image(
                    height: 100,
                    image: AssetImage('assets/images/logo.png'),
                  ),
                  SizedBox(height: 50),
                  Text(
                    'Registre-se como:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(height: 50),
                  OutlinedButtonGenerator(
                    text: 'Projeto',
                    icon: Icons.folder,
                    size: 50,
                    page: ProjectRegister(),
                  ),
                  SizedBox(height: 20),
                  OutlinedButtonGenerator(
                    text: 'Igreja',
                    icon: Icons.church,
                    size: 50,
                    page: ChurchRegister(),
                  ),
                  SizedBox(height: 20),
                  OutlinedButtonGenerator(
                    text: 'Doador',
                    icon: Icons.monetization_on,
                    size: 50,
                    page: DonorRegister(),
                  ),
                  SizedBox(height: 20),
                  OutlinedButtonGenerator(
                    text: 'Missionário',
                    icon: Icons.person,
                    size: 50,
                    page: MissionaryRegister(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
