// ignore_for_file: must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/saved_publication.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/initial_page.dart';
import 'package:semear/pages/profile/edit_account.dart';
import 'package:semear/pages/profile/edit_profile.dart';
import 'package:semear/pages/profile/saved_publications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuSettings extends StatelessWidget {
  MenuSettings(
      {super.key, this.color, required this.categoryData, required this.user});

  Color? color;
  User user;
  final categoryData;
  final userBloc = BlocProvider.getBloc<UserBloc>();

  @override
  Widget build(BuildContext context) {
    final sair = PopupMenuItem(
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                'Deseja realmente sair da conta e fazer login depois?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Recusar');
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.clear();
                    navigator.push(
                      MaterialPageRoute(
                        builder: (context) => InitialPage(),
                      ),
                    );
                  },
                  child: const Text('Sim'),
                ),
              ],
            ),
          );
        },
        child: const ListTile(
          leading: Icon(Icons.logout),
          title: Text('Sair'),
        ),
      ),
    );
    final perfil = PopupMenuItem(
      child: GestureDetector(
        onTap: () {
          next(context, EditProfile(user: user));
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
                    idCategory: categoryData.id,
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
      ];

      if (NotisDonor()) {
        list.insert(0, perfil);
      }
      if (user.id == userBloc.outMyIdValue) {
        list.add(sair);
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
