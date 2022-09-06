import 'package:flutter/material.dart';

class MenuSettings extends StatelessWidget {
  MenuSettings({super.key, this.color});

  Color? color;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.more_vert,
        color: color != null ? color : Colors.grey,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.mode_edit_sharp),
            title: Text('Editar Perfil'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.photo),
            title: Text('Publicações Salvas'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Apagar Conta'),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
          ),
        ),
      ],
    );
  }
}
