import 'package:flutter/material.dart';

class PostSettings extends StatelessWidget {
  const PostSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 50,
      color: Color.fromARGB(255, 245, 239, 239),
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.add),
            title: Text('Seguir Projeto'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.save_alt_rounded),
            title: Text('Salvar Publicação'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.send),
            title: Text('Enviar Mensagem'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Fazer Doação'),
          ),
        ),
      ],
    );
  }
}
