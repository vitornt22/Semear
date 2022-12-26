// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/donation_model.dart';
import 'package:semear/models/user_model.dart';

class ValidationTab extends StatefulWidget {
  ValidationTab({super.key, required this.user});
  User user;

  @override
  State<ValidationTab> createState() => _ValidationTabState();
}

class _ValidationTabState extends State<ValidationTab> {
  final userBloc = BlocProvider.getBloc<UserBloc>();
  late final categoryData;
  User? user;
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();
  int? id;
  final styleGreen = TextStyle(color: Colors.green);

  ApiProfile api = ApiProfile();

  @override
  void initState() {
    super.initState();
    id = widget.user.id;
    categoryData = userBloc.outCategoryValue![id];
    user = userBloc.outUserValue![id];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: StreamBuilder<Map<int, dynamic>>(
            stream: profileBloc.outValidationsChurch,
            initialData: profileBloc.outValidationsChurchValue,
            builder: (context, snapshot) {
              getValidationsChurch();

              if (snapshot.hasData) {
                if (snapshot.data![id] != null) {
                  final list = snapshot.data![id];
                  return list.isEmpty
                      ? noText('Validações')
                      : SingleChildScrollView(
                          child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final person = snapshot.data![id]![index];

                                userBloc.addCategory(
                                    list[index]!.user.id, list[index]);
                                userBloc.addUser(list[index].user);
                                final idM = list[index].user.id;

                                return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              showDialogFunction(person));
                                    },
                                    child: listTile(list[index]));
                              }),
                        );
                }
              }
              return Center(
                  child: CircularProgressIndicator(color: Colors.green));
            }),
      ),
    );
  }

  Widget noText(text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Não há $text',
            style: TextStyle(color: Color.fromRGBO(17, 114, 20, 1)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget listTile(data) {
    return ListTile(
      trailing: Text('clique'),
      leading: data.user.information.photoProfile == null
          ? CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
              radius: 30,
            )
          : CircleAvatar(
              child: Image.network(data.user.information.photoProfile)),
      title: Text('${getCategory(data.user.category)})'),
      subtitle: Text('${getName(data)}'),
    );
  }

  Widget showDialogFunction(person) {
    profileBloc.inGettingLoading.add(false);
    return StreamBuilder<bool>(
        stream: profileBloc.outGettingLoad,
        initialData: false,
        builder: (context, snapshot) {
          return AlertDialog(
            title: Visibility(
              visible: snapshot.data == false,
              child: Text(person.user.category == 'project'
                  ? 'Informações de ${person.name}'
                  : 'Informações de ${person.fullName}'),
            ),
            content: snapshot.data == true ? circular() : informations(person),
            actions: snapshot.data == true
                ? []
                : <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Recusar'),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Voltar',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20)),
                              Icon(
                                Icons.arrow_back,
                                size: 15,
                                color: Colors.grey,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () =>
                                recuseAccount(person.user.id, context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Recusar',
                                    style: TextStyle(
                                        color: Colors.redAccent, fontSize: 20)),
                                Icon(
                                  Icons.cancel,
                                  size: 15,
                                  color: Colors.redAccent,
                                )
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              validateAccount(person.user.id, context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Validar',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 20)),
                              Icon(
                                Icons.check,
                                size: 15,
                                color: Colors.green,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
          );
        });
  }

  Widget textSize(text, double? size) {
    return Column(
      children: [
        Text(text),
        SizedBox(
          height: size ?? 10,
        )
      ],
    );
  }

  recuseAccount(id, context) {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: ((context) => AlertDialog(
              title: Text(
                  'Tem  certeza que deseja recusar? Isso apagará a conta.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    profileBloc.inGettingLoading.add(true);
                    await api.deleteAccount(id).then((value) {
                      profileBloc.inGettingLoading.add(false);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(getSnackBar('Excluída', value));
                    });
                  },
                  child: Text('Sim'),
                )
              ],
            )));
  }

  validateAccount(id, context) {
    profileBloc.inGettingLoading.add(true);
    final scaffold = ScaffoldMessenger.of(context);
    api.setAccountValidation(id).then((value) {
      profileBloc.inGettingLoading.add(false);
      Navigator.pop(context);
      scaffold.showSnackBar(getSnackBar('validada', value));
    });
  }

  getSnackBar(text, value) {
    final name = text == 'validada' ? 'validar' : 'apagar';
    final snackbar = SnackBar(
      backgroundColor: value == true ? Colors.green : Colors.redAccent,
      content: Text(
        value == true
            ? 'Conta $text com Sucesso! '
            : 'Erro ao tentar $name conta',
      ),
    );

    return snackbar;
  }

  Widget circular() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(color: Colors.green),
        ),
      ],
    );
  }

  Widget informations(project) {
    final category = project.user.category;
    final name =
        category == 'project' ? '${project.name}' : '${project.fullName}';
    final categoryText = category == 'project' ? 'Projeto' : 'Missionário';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textSize(
            'O(a) $categoryText $name, criou uma conta e agora '
            'solicita que a igreja ${project.church.name} valide'
            ' a ativação da conta para que o mesmo possua realizar '
            'as atividades da rede social',
            10),
        textSize('Informações: ', 10),
        textSize(name, 5),
        textSize('Email: ${project.user.email}', 5),
      ],
    );
  }

  Widget noValidations() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Não há validações a serem feitas ',
            style: TextStyle(color: Color.fromARGB(255, 17, 103, 19)),
          )
        ],
      ),
    );
  }

  getName(data) {
    final category = data.user.category;
    switch (category) {
      case 'project':
        return data.name;
      case 'missionary':
        return data.fullName;

      default:
    }
  }

  getCategory(category) {
    switch (category) {
      case 'project':
        return 'Projeto';
      case 'missionary':
        return 'Missionário';
      default:
    }
  }

  getValidationsChurch() async {
    await api
        .getDataChurch(categoryData.id, 'validations')
        .then(((value) => profileBloc.addValidationsChurch(id, value)));
  }
}
