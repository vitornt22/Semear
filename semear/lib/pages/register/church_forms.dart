// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:semear/widgets/forms_field.dart';

class ValidationChurchForm extends StatefulWidget {
  const ValidationChurchForm({super.key});

  @override
  State<ValidationChurchForm> createState() => _ValidationChurchFormState();
}

class _ValidationChurchFormState extends State<ValidationChurchForm> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        FormsField(
          label: 'CNPJ',
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

class InfoChurchForms extends StatefulWidget {
  const InfoChurchForms({super.key});

  @override
  State<InfoChurchForms> createState() => _InfoChurchFormsState();
}

class _InfoChurchFormsState extends State<InfoChurchForms> {
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
          Row(
            children: [
              Expanded(
                child: FormsField(
                  label: 'Senha',
                  hintText: '',
                  sizeBoxHeigth: 10,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: FormsField(
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
                  label: 'Contato',
                  hintText: 'ex: (89)99929-2922',
                  sizeBoxHeigth: 10,
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: FormsField(
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
                ),
              ),
              SizedBox(width: 5),
              Expanded(
                child: FormsField(
                  label: 'Fundação',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DataChurchForms extends StatelessWidget {
  const DataChurchForms({super.key});

  @override
  Widget build(BuildContext context) {
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
            ],
          ),
        ),
      ],
    );
  }
}
