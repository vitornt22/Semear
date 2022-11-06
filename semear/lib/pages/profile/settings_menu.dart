// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:semear/models/saved_publication.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/edit_account.dart';
import 'package:semear/pages/profile/edit_profile.dart';
import 'package:semear/pages/profile/saved_publications.dart';

class MenuSettings extends StatelessWidget {
  MenuSettings(
      {super.key, this.color, required this.categoryData, required this.user});

  Color? color;
  User user;
  final categoryData;

  @override
  Widget build(BuildContext context) {
    final perfil = PopupMenuItem(
      child: GestureDetector(
        onTap: () {
          next(context, EditProfile());
        },
        child: const ListTile(
          leading: Icon(Icons.mode_edit_sharp),
          title: Text('Editar Perfil'),
        ),
      ),
    );
    getList() {
      final list = <PopupMenuEntry>[
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              next(
                  context,
                  SavedPublications(
                    type: user.category!,
                    user: user,
                  ));
            },
            child: const ListTile(
              leading: Icon(Icons.photo),
              title: Text('Publicações Salvas'),
            ),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              next(
                  context,
                  EditAccount(
                    user: user,
                  ));
            },
            child: const ListTile(
              leading: Icon(Icons.account_box),
              title: Text('Minha conta'),
            ),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
          ),
        ),
      ];

      if (NotisDonor()) {
        list.insert(0, perfil);
      }
      return list;
    }

    return PopupMenuButton(
        icon: Icon(
          Icons.more_vert,
          color: color ?? Colors.grey,
        ),
        itemBuilder: (BuildContext context) => getList());
  }

  bool NotisDonor() {
    return user.category != 'donor';
  }

  void next(context, obj) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => obj),
    );
  }
}
