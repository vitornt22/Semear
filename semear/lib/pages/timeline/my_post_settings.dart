import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_settings.dart';
import 'package:semear/blocs/settings_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/publication_model.dart';

class MyPostSettings extends StatefulWidget {
  MyPostSettings({super.key, required this.publication});

  Publication publication;

  @override
  State<MyPostSettings> createState() => _MyPostSettingsState();
}

class _MyPostSettingsState extends State<MyPostSettings> {
  final settingBloc = SettingBloc();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final api = ApiSettings();
  int? myId;

  @override
  void initState() {
    super.initState();
    myId = userBloc.outMyIdValue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget follow() {
    return GestureDetector(
      onTap: () async {
        print("FOLLOWING");
        final value = await api.setFollower(
            userBloc.outUserValue![myId]!.id, widget.publication.user!.id);
        if (value != null) {
          userBloc.updateUser(value);
          settingBloc.changeFollower(widget.publication.id, false);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Você comecou a seguir ${widget.publication.user!.username}'),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarErrorFollow);
        }
      },
      child: const ListTile(
        leading: Icon(Icons.add),
        title: Text('Seguir Projeto'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 50,
      color: const Color.fromARGB(255, 245, 239, 239),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => [
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Editar Publicação'),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.delete),
            title: Text('Apagar Publicação'),
          ),
        ),
      ],
    );
  }

  final snackBarErrorFollow = const SnackBar(
    content: Text('Erro ao tentar seguir'),
    backgroundColor: Colors.redAccent,
  );
}
