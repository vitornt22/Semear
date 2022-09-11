// ignore_for_file: use_full_hex_values_for_flutter_colors, unnecessary_const

import 'package:flutter/material.dart';

class CardTransaction extends StatelessWidget {
  const CardTransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        key: const PageStorageKey('1'),
        initiallyExpanded: false,
        textColor: const Color(0xffa23673A),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: const [
              SizedBox(),
              Expanded(
                child: Text(
                  'Doação de R\$ 1000,00 para Jesus visitando familias',
                ),
              ),
            ],
          ),
        ),
        children: [
          const Divider(
            thickness: 1,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              children: [
                Row(
                  children: const [
                    Expanded(child: Text('Doador:')),
                    Text('Joao Carlos Barbosa')
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: const [
                    Expanded(child: Text('Projeto:')),
                    Text('Jesus Visitando Familias')
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: const [
                    Expanded(child: Text('Forma:')),
                    Text('PIX')
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '1000,00',
                      style: TextStyle(color: Color(0xffa23673A), fontSize: 30),
                    ),
                    Icon(
                      Icons.monetization_on,
                      size: 50,
                      color: const Color(0xffa23673A),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
