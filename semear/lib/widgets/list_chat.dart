// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ListChat extends StatelessWidget {
  const ListChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: SizedBox(
              width: double.maxFinite,
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: IconTheme(
                    data: IconThemeData(
                      color: Colors.green,
                    ),
                    child: const Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffa23673A)),
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Pesquisar',
                  floatingLabelStyle: TextStyle(color: Colors.green),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 5,
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
        ),
        Divider(
          thickness: 2,
        ),
        Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(thickness: 1),
              itemCount: 100,
              itemBuilder: (context, index) {
                return Slidable(
                  endActionPane: ActionPane(
                    motion: StretchMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          print('DELETOU');
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      'Amigos do bem',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            'Olá recebi sua oferdddddddddddddddddddddddddddddddddddddta, muito obrigado!'),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Há 4h',
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.start,
                        )
                      ],
                    ),
                    leading: ClipOval(
                      child: Image.asset(
                        'assets/images/amigos.jpeg',
                        alignment: Alignment.bottomLeft,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 60,
                      child: Row(
                        children: [
                          index % 2 == 0
                              ? Expanded(
                                  child: CircleAvatar(
                                      radius: 5, backgroundColor: Colors.blue))
                              : SizedBox(width: 40),
                          Icon(
                            Icons.folder,
                            size: 20,
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
