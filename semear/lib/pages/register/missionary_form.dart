// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:semear/widgets/forms_field.dart';

class InfoMissionaryForm extends StatefulWidget {
  const InfoMissionaryForm({super.key});

  @override
  State<InfoMissionaryForm> createState() => _InfoMissionaryFormState();
}

class _InfoMissionaryFormState extends State<InfoMissionaryForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          FormsField(
            label: 'Nome Completo',
            hintText: 'ex: Francisca da Silva Feitosa',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            label: 'Igreja',
            hintText: 'ex: Assembleia de Deus',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            label: 'Email',
            hintText: 'ex: osvaldovieira@gmail.com',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            label: 'Nome de Usuário',
            hintText: 'ex: osvaldovieira',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            label: 'Senha',
            hintText: 'ex: osvaldovieira@gmail.com',
            sizeBoxHeigth: 10,
          ),
          FormsField(
            label: 'Confirmar Senha',
            hintText: 'ex: osvaldovieira@gmail.com',
            sizeBoxHeigth: 10,
          )
        ],
      ),
    );
  }
}

class DataMissionaryForm extends StatefulWidget {
  const DataMissionaryForm({super.key});

  @override
  State<DataMissionaryForm> createState() => _DataMissionaryFormState();
}

class _DataMissionaryFormState extends State<DataMissionaryForm> {
  bool? checkedValue = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          )
        ],
      ),
    );
  }
}

class DataBankForm extends StatelessWidget {
  const DataBankForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpansionTile(
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
                      label: 'Nome do Titular',
                      hintText: 'Ex: Joao Gomes da Silva',
                      sizeBoxHeigth: 10,
                    ),
                    FormsField(
                      label: 'CPF/CNPJ',
                      hintText: 'Digite o CPF OU CNPJ',
                      sizeBoxHeigth: 10,
                    ),
                    FormsField(
                      label: 'Banco',
                      hintText: 'Digite o CPF OU CNPJ',
                      sizeBoxHeigth: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: FormsField(
                            label: 'Agência',
                            sizeBoxHeigth: 10,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: FormsField(
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
                            label: 'Conta',
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: FormsField(
                            label: 'Digito',
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
        SizedBox(height: 10),
        ExpansionTile(
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
                      label: 'Tipo de Chave ',
                      sizeBoxHeigth: 10,
                    ),
                    FormsField(
                      label: 'Valor da Chave',
                      sizeBoxHeigth: 10,
                    ),
                  ],
                ),
              )
            ]),
      ],
    );
  }
}

class ProfileMissionaryForm extends StatelessWidget {
  const ProfileMissionaryForm({super.key});

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
                hintText: "Escreva um resumo da sua biografia",
              ),
            ),
          ),
        )
      ],
    );
  }
}
