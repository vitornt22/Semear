// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:semear/widgets/forms_field.dart';

class ValidationProjectForm extends StatefulWidget {
  const ValidationProjectForm({super.key});

  @override
  State<ValidationProjectForm> createState() => _ValidationProjectFormState();
}

class _ValidationProjectFormState extends State<ValidationProjectForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        FormsField(
          label: 'Nome',
          hintText: 'ex: 11.111.111/0001-11',
        ),
        FormsField(
          label: 'Denominação',
          hintText: 'ex: Assembleia de Deus',
        ),
        FormsField(
          label: 'Ministério',
          hintText: 'ex: Missão',
        )
      ],
    ));
  }
}

class ContactProjectForm extends StatefulWidget {
  const ContactProjectForm({super.key});

  @override
  State<ContactProjectForm> createState() => _ContactProjectFormState();
}

class _ContactProjectFormState extends State<ContactProjectForm> {
  bool? checkedValue = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormsField(
            label: 'Email',
            hintText: 'ex: semear@gmail.com',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            label: 'Nome de Usuário',
            hintText: 'ex: semear123',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            label: 'Senha',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            label: 'Confirmar Senha',
            sizeBoxHeigth: 10,
          ),
          Row(
            children: [
              Expanded(
                child: FormsField(
                  label: 'Contato',
                  hintText: 'ex: (89)99929-2922',
                  sizeBoxHeigth: 5,
                ),
              ),
              SizedBox(width: 2),
            ],
          ),
          CheckboxListTile(
            activeColor: Colors.green,
            title: Text("Usar Endereço da Igreja"),
            contentPadding: EdgeInsets.all(2),
            value: checkedValue,
            onChanged: (newValue) {
              setState(() {
                checkedValue = newValue;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
          checkedValue == false
              ? ExpansionTile(
                  title: Text('Endereço'),
                  initiallyExpanded: true,
                  children: [
                    Column(
                      children: [
                        FormsField(
                          label: 'CEP',
                          hintText: 'ex: 64690-000',
                          sizeBoxHeigth: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: FormsField(
                                label: 'Endereço',
                                hintText: 'ex: Rua.Odomirio Ribeiro',
                                sizeBoxHeigth: 10,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: FormsField(
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
                              flex: 5,
                              child: FormsField(
                                label: 'Cidade',
                                hintText: 'ex: Rua.Odomirio Ribeiro',
                                sizeBoxHeigth: 10,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: FormsField(
                                label: 'UF',
                                hintText: 'ex: PI',
                                sizeBoxHeigth: 10,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: FormsField(
                                label: 'Bairro',
                                hintText: 'ex: Bela Vista',
                                sizeBoxHeigth: 10,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: FormsField(
                                label: 'Fundação',
                                hintText: 'ex: 22/07/1992',
                                sizeBoxHeigth: 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}

class InfoProjectForm extends StatelessWidget {
  const InfoProjectForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: const [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/amigos.jpeg'),
              radius: 70,
            ),
            Positioned(
              bottom: 0,
              left: 100,
              child: Icon(
                Icons.add_a_photo_outlined,
              ),
            )
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // if you need this
            side: BorderSide(
              color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              width: 2,
            ),
          ),
          color: Color.fromARGB(255, 255, 248, 248),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 8, //or null
              decoration: InputDecoration.collapsed(
                hintText: "Resumo da descrição do projeto",
              ),
            ),
          ),
        )
      ],
    );
  }
}
