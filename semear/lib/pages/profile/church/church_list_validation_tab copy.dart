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
    return Container(
      color: Colors.white,
      child: StreamBuilder<Map<int, List<dynamic>>>(
          stream: profileBloc.outValidationsChurch,
          initialData: profileBloc.outMissionariesChurchValue,
          builder: (context, snapshot) {
            getValidationsChurch();

            if (snapshot.hasData) {
              if (snapshot.data![id] != null) {
                if (snapshot.data![id]!.isNotEmpty) {
                  return Expanded(
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: snapshot.data![id]!.isEmpty
                          ? 1
                          : snapshot.data![id]!.length,
                      itemBuilder: (context, index) {
                        final person = snapshot.data![id]![index];
                        return snapshot.data![id]!.isEmpty
                            ? noValidations()
                            : GestureDetector(
                                onTap: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text(person.user.category ==
                                              'project'
                                          ? 'Informações de ${person.name}'
                                          : 'Informações de ${person.name}'),
                                      content: informations(person),
                                      actions: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Recusar'),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text('Voltar',
                                                      style: TextStyle(
                                                          color: Colors.grey)),
                                                  Icon(
                                                    Icons.arrow_back,
                                                    size: 15,
                                                    color: Colors.grey,
                                                  )
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Recusar'),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text('Recusar',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .redAccent)),
                                                  Icon(
                                                    Icons.cancel,
                                                    size: 15,
                                                    color: Colors.redAccent,
                                                  )
                                                ],
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(
                                                  context, 'Recusar'),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text('Validar',
                                                      style: TextStyle(
                                                          color: Colors.green)),
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
                                    ),
                                  );
                                },
                                child: ListTile(
                                  title: Text(
                                      '${getCategory(person.user.category)}:'),
                                  subtitle: Text(
                                      person.user.category == 'project'
                                          ? '${person.name}'
                                          : '${person.fullName}'),
                                  trailing: StreamBuilder<Map<int, bool>>(
                                      stream: profileBloc.outLoadingAccount,
                                      initialData:
                                          profileBloc.outLoadingAccountValue,
                                      builder: (context, snapshot) {
                                        return snapshot.data![person.user.id] ==
                                                true
                                            ? SizedBox(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: Colors.green))
                                            : Wrap(children: [
                                                IconButton(
                                                  tooltip: 'Validar',
                                                  onPressed: () async {
                                                    profileBloc
                                                        .addLoadingAccount(
                                                            person.user.id,
                                                            true);
                                                    await validateAccount(
                                                        person.user.id);
                                                    profileBloc
                                                        .addLoadingAccount(
                                                            person.user.id,
                                                            false);
                                                  },
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
                                              ]);
                                      }),
                                ),
                              );
                      },
                    ),
                  );
                }
              }
            }
            return Center(
                child: CircularProgressIndicator(color: Colors.green));
          }),
    );
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

  validateAccount(id) {
    final scaffold = ScaffoldMessenger.of(context);
    api.setAccountValidation(id).then((value) {
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

  Widget informations(project) {
    final category = project.user.category;
    final name = category == 'project'
        ? 'Nome: ${project.name}'
        : 'Nome: ${project.fullName}';
    final categoryText = category == 'project' ? 'Projeto' : 'Missionário';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textSize(
            'O $categoryText $name, criou uma conta e agora '
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
