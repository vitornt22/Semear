// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';

class ValidationTab extends StatelessWidget {
  const ValidationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 200,
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: 40,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Validação'),
                    content: Container(
                      height: 500,
                      child: const Text(
                          'Raimundo Sousa, pediu para logar como missionário, sendo indicado por esta igreja'),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Recusar'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('Validar'),
                      ),
                    ],
                  ),
                );
              },
              child: ListTile(
                title: Text('Missionario:'),
                subtitle: Text('Joao Cardoso Silva'),
                trailing: Wrap(children: [
                  IconButton(
                    tooltip: 'Validar',
                    onPressed: () {},
                    icon: Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                      tooltip: 'Recusar',
                      onPressed: () {},
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                      )),
                ]),
              ),
            );
          }),
    );
  }
}
