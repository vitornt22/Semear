// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/apis/api_settings.dart';
import 'package:semear/blocs/followers_bloc.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/settings_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/church_model.dart';
import 'package:semear/models/donor_model.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church/church_profile_page.dart';
import 'package:semear/pages/profile/donor/donor_profile_page.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';
import 'package:semear/widgets/button_filled.dart';

class FollowingScreen extends StatefulWidget {
  FollowingScreen({
    super.key,
    required this.first,
    required this.user,
  });
  User user;
  bool first;
  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  ApiProfile api = ApiProfile();
  TextEditingController searchController = TextEditingController();
  final followerBloc = BlocProvider.getBloc<FollowersBloc>();
  final settings = ApiSettings();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  final settingBloc = BlocProvider.getBloc<SettingBloc>();
  int? myId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myId = userBloc.outMyIdValue;
  }

  @override
  void dispose() {
    followerBloc.disableButtonReset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                const Text(
                  'Seguindo',
                  style: TextStyle(color: Colors.green),
                ),
                const SizedBox(width: 5),
                StreamBuilder<Map<int, List<dynamic>>>(
                  stream: followerBloc.outFollowing,
                  initialData: followerBloc.outFollowingValue,
                  builder: (context, snapshot) => snapshot.hasData
                      ? Text(
                          '${snapshot.data![widget.user.id] != null ? snapshot.data![widget.user.id]!.length : ''}',
                          style: const TextStyle(color: Colors.green),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.green,
              ),
            )),
        body: RefreshIndicator(
          onRefresh: () async {
            searchController.clear();
            initializer();
          },
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: SizedBox(
                      width: double.maxFinite,
                      height: 40,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: searchFunction,
                        decoration: InputDecoration(
                          prefixIcon: const IconTheme(
                            data: IconThemeData(
                              color: Colors.green,
                            ),
                            child: Icon(Icons.search),
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Color(0xffa23673A)),
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'Pesquisar',
                          suffix: IconButton(
                              onPressed: () {
                                searchController.text = '';
                                followerBloc.inFollowing
                                    .add(followerBloc.outListFollowingValue);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.grey,
                                size: 18,
                              )),
                          floatingLabelStyle:
                              const TextStyle(color: Colors.green),
                          fillColor: Colors.white,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            gapPadding: 5,
                            borderSide:
                                const BorderSide(color: Colors.green, width: 2),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Expanded(
                  child: StreamBuilder<Map<int, List<dynamic>>>(
                      stream: followerBloc.outFollowing,
                      initialData: followerBloc.outFollowingValue,
                      builder: (context, snapshot) {
                        if (searchController.text.isEmpty) {
                          initializer();
                        }
                        if (snapshot.hasData) {
                          if (snapshot.data![widget.user.id] != null ||
                              snapshot.data![widget.user.id]!.isNotEmpty) {
                            return listFollowing(
                                snapshot.data![widget.user.id]);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                'N??o segue nenhum projeto',
                                style: TextStyle(color: Colors.green),
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return const Text('ERRO');
                        }
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        );
                      }),
                )
              ],
            ),
          ),
        ));
  }

  void searchFunction(String query) {
    print(query);
    followerBloc.inSearch.add(query);
    var suggestions = followerBloc.outListFollowingValue;
    print("sugestoes: $suggestions");
    if (suggestions != null) {
      final sug = suggestions[widget.user.id]!.where((follower) {
        print(follower);
        final username = follower.user2.username.toLowerCase();
        final input = query.toLowerCase();
        return username.contains(input);
      }).toList();
      followerBloc.addSearchedFollowing(widget.user.id, sug);
    } else {
      followerBloc.addSearchedFollowing(widget.user.id, []);
    }
  }

  Widget listFollowing(data) {
    return data != null || data.isNotEmpty
        ? ListView.separated(
            separatorBuilder: (context, index) => const Divider(thickness: 1),
            itemCount: data.isEmpty ? 1 : data.length,
            itemBuilder: (context, index) {
              //print("INDEC NUMBER: ${data[index].user2.id}");

              return data.isEmpty
                  ? Text('Voc?? n??o est?? seguindo ningu??m')
                  : ListTile(
                      title: GestureDetector(
                        onTap: () {
                          // print("CATWEGORY DAT ${data[index].user2Data}");
                          // print("USERRRR ${data[index].user}");

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Scaffold(
                                    bottomSheet: Container(
                                      color: Colors.white,
                                      width: double.infinity,
                                      height: 80,
                                      child: ButtonFilled(
                                        text: widget.first == true
                                            ? 'Voltar ao meu perfil'
                                            : "Voltar aos coment??rios",
                                        onClick: () {
                                          print(
                                              "WIDGET.FIRST, ${widget.first}");
                                          widget.first == false
                                              ? Navigator.of(context).popUntil(
                                                  (route) =>
                                                      route
                                                          .settings.arguments ==
                                                      true)
                                              : Navigator.of(context).popUntil(
                                                  (route) =>
                                                      route.isFirst == true);
                                        },
                                      ),
                                    ),
                                    body: nextPage(
                                      data[index].user2.category,
                                      data[index].user2,
                                      data[index].user2Data,
                                    ))),
                          );
                        },
                        child: Text(
                          data[index].user2.id == myId
                              ? 'Voc??'
                              : data[index].user2.username ?? '',
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            category(data[index].user2.category) ?? '',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                      leading: data[index].user2.information.photoProfile !=
                              null
                          ? ClipOval(
                              child: Image.network(
                                data[index].user2.information.photoProfile ??
                                    '',
                                alignment: Alignment.bottomLeft,
                              ),
                            )
                          : ClipOval(
                              child: Image.asset(
                                'assets/images/avatar.png',
                                alignment: Alignment.bottomLeft,
                              ),
                            ),
                      trailing: Visibility(
                        visible: visibility(data[index]) ? true : false,
                        child: StreamBuilder<Map<int, Map<int, bool>>>(
                            stream: followerBloc.labelController,
                            initialData: followerBloc.outLabelValue,
                            builder: (context, snapshot) {
                              followerBloc.addLabelButton(
                                  userBloc.outUserValue![myId]!.id,
                                  data[index].user2.id);
                              if (snapshot.hasData) {
                                if (snapshot.data![userBloc.outUserValue![myId]!
                                        .id]![data[index].user2.id] !=
                                    null) {
                                  final check = snapshot.data![userBloc
                                      .outUserValue![myId]!
                                      .id]![data[index].user2.id];
                                  if (check == true) {
                                    return unFollow(data[index].user2);
                                  } else {
                                    return follow(data[index].user2);
                                  }
                                }
                              }

                              return const SizedBox(
                                height: 15,
                                width: 15,
                                child: CircularProgressIndicator(
                                    color: Colors.green),
                              );
                            }),
                      ),
                    );
            })
        : Text('teste');
  }

  Widget follow(data) {
    followerBloc.addDisable(data.id, false);
    return SizedBox(
      width: 100,
      child: StreamBuilder<Map<int, bool>>(
        stream: followerBloc.outDisabledButtons,
        initialData: followerBloc.outDisabledButtonsValue,
        builder: (context, snapshot) => OutlinedButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.green),
          ),
          onPressed: snapshot.data![data.id] == true
              ? null
              : () async {
                  followerBloc.addDisable(data.id, true);
                  final value = await settings.setFollower(
                      userBloc.outUserValue![myId]!.id, data.id);
                  if (value != null) {
                    userBloc.addUser(value);
                    settingBloc.changeFollower(data.id, true);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        'Voc?? comecou a seguir ${data.username}',
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.green,
                    ));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBarErrorFollow);
                  }
                  followerBloc.addDisable(data.id, false);
                },
          child: Text("Seguir"),
        ),
      ),
    );
  }

  bool visibility(data) {
    return userBloc.outUserValue![userBloc.outMyIdValue]!.category !=
            'anonymous' &&
        userBloc.outUserValue![myId]!.id != data.user2.id &&
        (data.user2.category == 'project' ||
            data.user2.category == 'missionary');
  }

  Widget unFollow(data) {
    return ElevatedButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => StreamBuilder(
            stream: followerBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) => AlertDialog(
              title: snapshot.data == true
                  ? const CircularProgressIndicator(color: Colors.green)
                  : Text("Deixar de seguir ${data.username}?"),
              actions: snapshot.data == true
                  ? []
                  : [
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('N??o'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Sim'),
                        onPressed: () async {
                          print("UNFOLLOWING");
                          final value = await settings.unFollow(
                              userBloc.outUserValue![myId]!.id, data.id);
                          if (value != null) {
                            userBloc.addUser(value);
                            settingBloc.changeFollower(data.id, false);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBarErrorFollow);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
            ),
          ),
        );
      },
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
      child: const Text('Deixar de Seguir'),
    );
  }

  void initializer() {
    api.getFollowing(widget.user.id).then((value) {
      followerBloc.addFollowing(widget.user.id, value);
    });
  }

  String? category(category) {
    Map<String, String> map = {
      'project': 'Projeto',
      'missionary': 'Mission??rio',
      'donor': 'Doador',
      'church': 'Igreja'
    };
    return map[category];
  }

  bool getMyChurch(data) {
    final id = userBloc.outMyIdValue;

    if (userBloc.outUserValue![id]!.category == 'church') {
      return profileBloc.outProjectsChurchValue![id]!.contains(data.id);
    }
    return false;
  }

  Widget nextPage(category, user, userdata) {
    print("ENTROU NEXTPAGE0");
    var categoryData = null;
    late final object;

    switch (category) {
      case 'project':
        categoryData = Project.fromJson(userdata);
        object = ProfileProjectPage(
          myChurch: getMyChurch(user),
          back: false,
          type: widget.user.id == userBloc.outUserValue![myId]!.id
              ? 'me'
              : 'other',
          user: user,
        );
        break;
      case 'missionary':
        categoryData = Missionary.fromJson(userdata);
        object = ProfileProjectPage(
          myChurch: false,
          type: widget.user.id == userBloc.outUserValue![myId]!.id
              ? 'me'
              : 'other',
          user: user,
        );
        break;
      case 'donor':
        categoryData = Donor.fromJson(userdata);
        object = DonorProfilePage(
            user: user,
            type: user.id == userBloc.outUserValue![myId]!.id ? 'me' : 'other');
        break;
      case 'church':
        categoryData = Church.fromJson(userdata);
        object = ChurchProfilePage(
          first: true,
          user: user,
          type: user.id == userBloc.outUserValue![myId]!.id ? 'me' : 'other',
        );
        break;
      default:
        break;
    }
    print("ITSS CATEGORYDATA $categoryData");
    addCategoryDataAndUser(user.id, categoryData, user);
    print("valueNexPAge ${object}");
    return object;
  }

  void addCategoryDataAndUser(id, data, user) {
    userBloc.addCategory(id, data);
    userBloc.addUser(user);
  }

  final snackBarErrorFollow = const SnackBar(
    content: Text('Erro ao tentar seguir'),
    backgroundColor: Colors.redAccent,
  );
}
