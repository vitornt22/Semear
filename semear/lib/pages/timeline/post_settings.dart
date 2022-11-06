import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_settings.dart';
import 'package:semear/blocs/settings_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/pages/profile/dialog_donation.dart';

class PostSettings extends StatefulWidget {
  PostSettings({super.key, required this.publication});

  Publication publication;

  @override
  State<PostSettings> createState() => _PostSettingsState();
}

class _PostSettingsState extends State<PostSettings> {
  final settingBloc = BlocProvider.getBloc<SettingBloc>();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final api = ApiSettings();
  int? myId;

  @override
  void initState() {
    super.initState();
    myId = userBloc.outMyIdValue;
    final save;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initializer();
    return PopupMenuButton(
      elevation: 50,
      color: const Color.fromARGB(255, 245, 239, 239),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: StreamBuilder<Map<int, bool>>(
              stream: settingBloc.outFollowerController,
              initialData: settingBloc.outFollowerValue,
              builder: (context, snapshot) {
                if (snapshot.data![widget.publication.user!.id] != null) {
                  return snapshot.data![widget.publication.user!.id] == false
                      ? follow()
                      : unFollow();
                }
                return CircularProgressIndicator(color: Colors.green);
              }),
        ),
        PopupMenuItem(
          child: StreamBuilder<Map<int, bool>>(
            stream: settingBloc.outSavedController,
            initialData: settingBloc.outSavedValue,
            builder: (context, snapshot) =>
                snapshot.data![widget.publication.id] == true
                    ? unSavePublication()
                    : savePublication(),
          ),
        ),
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.send),
            title: Text('Enviar Mensagem'),
          ),
        ),
        PopupMenuItem(
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => DonationDialog(
                      user: widget.publication.user!.category == 'project'
                          ? widget.publication.project
                          : widget.publication.missionary,
                      donor: userBloc.outUserValue![myId]!.id));
            },
            child: const ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text('Fazer Doação'),
            ),
          ),
        ),
      ],
    );
  }

  void initializer() async {
    api
        .getLabelFollower(
            userBloc.outUserValue![myId]!.id, widget.publication.user!.id)
        .then((value) {
      settingBloc.changeFollower(widget.publication.user!.id, value);
      print("VALOR AQUI NA FUNCAO: $value");
    });

    api
        .getLabelPublicationSaved(
            userBloc.outUserValue![myId]!.id, widget.publication.id)
        .then((value) {
      settingBloc.changeSavedPublication(widget.publication.id, value);
    });
  }

  Widget follow() {
    return GestureDetector(
      onTap: () async {
        print("FOLLOWING");
        final value = await api.setFollower(
            userBloc.outUserValue![myId]!.id, widget.publication.user!.id);
        if (value != null) {
          userBloc.updateUser(value);
          settingBloc.changeFollower(widget.publication.user!.id, true);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Você comecou a seguir ${widget.publication.user!.username}',
              textAlign: TextAlign.center,
            ),
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

  Widget unFollow() {
    return GestureDetector(
      onTap: () async {
        print("UNFOLLOWING");
        final value = await api.unFollow(
            userBloc.outUserValue![myId]!.id, widget.publication.user!.id);
        if (value != null) {
          userBloc.updateUser(value);
          settingBloc.changeFollower(widget.publication.user!.id, false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarErrorFollow);
        }
      },
      child: const ListTile(
        leading: Icon(Icons.add),
        title: Text('Deixar de seguir Projeto'),
      ),
    );
  }

  Widget savePublication() {
    return GestureDetector(
      onTap: () async {
        print("SavePublication");
        final value = await api.savePublication(
            userBloc.outUserValue![myId]!.id, widget.publication.id);
        print("VALOR DO RETORNO DE SALVAR $value");
        if (value == true) {
          api.getUser(userBloc.outUserValue![myId]!.id).then((v) {
            print("VALORRR: $v");
            userBloc.updateUser(v);
            settingBloc.changeSavedPublication(widget.publication.id, true);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarErrorFollow);
        }
      },
      child: const ListTile(
        leading: Icon(Icons.save_alt_outlined),
        title: Text('Salvar Publicação'),
      ),
    );
  }

  Widget unSavePublication() {
    return GestureDetector(
      onTap: () async {
        print("UNFOLLOWING");
        final value = await api.unSavePublication(
            userBloc.outUserValue![myId]!.id, widget.publication.id);

        print("VALOR $value");

        if (value == true) {
          api.getUser(userBloc.outUserValue![myId]!.id).then((v) {
            userBloc.updateUser(v);
            settingBloc.changeSavedPublication(widget.publication.id, false);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBarErrorFollow);
        }
      },
      child: const ListTile(
        leading: Icon(Icons.save_as),
        title: Text('Remover dos salvos'),
      ),
    );
  }

  final snackBarErrorFollow = const SnackBar(
    content: Text('Erro ao tentar seguir'),
    backgroundColor: Colors.redAccent,
  );
}
