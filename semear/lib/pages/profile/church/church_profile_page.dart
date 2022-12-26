// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/church_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church/church_list_validation_tab.dart';
import 'package:semear/pages/profile/church/create_project.dart';
import 'package:semear/pages/profile/church_projects.dart';
import 'package:semear/pages/profile/edit_profile.dart';
import 'package:semear/pages/profile/following_screen.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';
import 'package:semear/pages/profile/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';

class ChurchProfilePage extends StatefulWidget {
  ChurchProfilePage(
      {super.key,
      this.back,
      required this.user,
      required this.type,
      required this.first});

  String type;
  bool? back;
  User user;
  bool first;
  @override
  State<ChurchProfilePage> createState() => _ChurchProfilePageState();
}

class _ChurchProfilePageState extends State<ChurchProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool hasSite = true;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();
  ApiProfile api = ApiProfile();
  late final categoryData;
  String link = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
  late final user;
  int? id;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.type == 'me' ? 3 : 2, vsync: this);
    _tabController.animateTo(0);
    id = widget.user.id;
    categoryData = userBloc.outCategoryValue![id];
    user = userBloc.outUserValue![id];
    getMissionariesChurch();
    getProjectsChurch();
  }

  @override
  Widget build(BuildContext context) {
    final large = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: () async {
        await getProjectsChurch();
        await getMissionariesChurch();
        await updateData();
      },
      edgeOffset: 100,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: Visibility(
                visible: widget.back == null ? true : false,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              backgroundColor: Colors.white,
              centerTitle: true,
              actions: [
                MenuSettings(
                  color: Colors.black,
                  user: widget.user,
                  categoryData: Church(),
                ),
                SizedBox(
                  width: 15,
                )
              ],
              title: StreamBuilder<Map<int, User?>>(
                  stream: userBloc.outUser,
                  initialData: userBloc.outUserValue,
                  builder: (context, snapshot) {
                    return Text(
                      'Igreja:  ${snapshot.data![id]!.username}',
                      style: TextStyle(color: Color(0xffa23673A)),
                    );
                  }),
            ),
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Column(
                    children: [
                      ClipRRect(
                        child: StreamBuilder<Map<int, User?>>(
                            stream: userBloc.outUser,
                            initialData: userBloc.outUserValue,
                            builder: (context, snapshot) {
                              final information =
                                  snapshot.data![id]!.information;
                              print("INFORMATIOM $information");
                              return information != null &&
                                      information.photo1 != null
                                  ? SizedBox(
                                      height: 200,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                        information.photo1!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Stack(children: [
                                      Container(
                                        width: double.infinity,
                                        height: 200,
                                        color: Colors.grey,
                                      ),
                                      Visibility(
                                        visible: widget.type == 'me',
                                        child: Positioned(
                                          bottom: 30,
                                          right: 40,
                                          child: IconButton(
                                            tooltip: 'Adicionar capa ',
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditProfile(
                                                              user: user)));
                                            },
                                            icon: Icon(
                                              Icons.add_a_photo,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(
                                height: 150,
                                color: Colors.white,
                                padding: const EdgeInsets.only(right: 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: StreamBuilder<
                                                        Map<int, dynamic>>(
                                                    stream:
                                                        userBloc.outCategory,
                                                    initialData: userBloc
                                                        .outCategoryValue,
                                                    builder:
                                                        (context, snapshot) {
                                                      return Text(
                                                        "${snapshot.data![id].name} ",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: StreamBuilder<
                                                      Map<int, dynamic>>(
                                                  stream: userBloc.outCategory,
                                                  initialData:
                                                      userBloc.outCategoryValue,
                                                  builder: (context, snapshot) {
                                                    return Text(
                                                      snapshot.data![id]!
                                                              .ministery ??
                                                          "",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    );
                                                  }),
                                            ),
                                            SizedBox(width: 30)
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            StreamBuilder<Map<int, dynamic>>(
                                                stream: userBloc.outCategory,
                                                initialData:
                                                    userBloc.outCategoryValue,
                                                builder: (context, snapshot) {
                                                  return Expanded(
                                                    child: Text(
                                                      '', // '${snapshot.data![id]!.adress.city}-${snapshot.data![id].adress.uf}',
                                                      maxLines: 10,
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  );
                                                }),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder<Map<int, dynamic>>(
                      stream: userBloc.outUser,
                      initialData: userBloc.outUserValue,
                      builder: (context, snapshot) {
                        // print("photoProfile ${snapshot.data![id]}");
                        return Positioned(
                          top: 10,
                          left: 10,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(link),
                            radius: 50,
                          ),
                        );
                      }),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Container(
                    height: 90,
                    padding: EdgeInsets.only(bottom: 10),
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ButtonFilled(
                              text: 'Seguindo',
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowingScreen(
                                      user: widget.user,
                                      first: true,
                                    ),
                                  ),
                                );
                              }),
                        ),
                        widget.type == 'me'
                            ? Expanded(
                                child: ButtonFilled(
                                    text: 'Criar projeto',
                                    onClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateProject(user: user)),
                                      );
                                    }))
                            : Expanded(child: SizedBox()),
                        Visibility(
                            visible: widget.type == 'me',
                            child: ButtonFilled(
                              text: 'Publicar',
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChurchProjectsPage(
                                      user: user,
                                    ),
                                  ),
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SliverAppBar(
              elevation: 20,
              pinned: true,
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20.0),
                child: TabBar(
                    labelColor: Colors.black,
                    controller: _tabController,
                    indicatorColor: Colors.green,
                    tabs: [
                      Tab(
                        text: 'Projetos',
                        icon: Icon(
                          Icons.folder,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      Tab(
                        text: 'Missionários',
                        icon: Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      Visibility(
                        visible: widget.type == 'me',
                        child: Tab(
                          text: 'Validações',
                          icon: Icon(
                            Icons.check,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      )
                    ]),
              ),
            ),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(color: Colors.white, child: grid()),
                  missionaryTab(),
                  Visibility(
                    visible: widget.type == 'me',
                    child: ValidationTab(user: widget.user),
                  ),
                ],
              ),
            ),
          ],
        ),
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

  Widget missionaryTab() {
    return Container(
      color: Colors.white,
      child: StreamBuilder<Map<int, dynamic>>(
          stream: profileBloc.outMissionariesChurch,
          initialData: profileBloc.outMissionariesChurchValue,
          builder: (context, snapshot) {
            getMissionariesChurch();

            if (snapshot.hasData) {
              if (snapshot.data![id] != null) {
                final list = snapshot.data![id];
                return list.isEmpty
                    ? noText('missionários')
                    : SingleChildScrollView(
                        child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              userBloc.addCategory(
                                  list[index]!.user.id, list[index]);
                              userBloc.addUser(list[index].user);
                              final idM = list[index].user.id;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileProjectPage(
                                          myChurch: false,
                                          user: list[index].user,
                                          type: 'other'),
                                    ),
                                  );
                                },
                                child: ListTile(
                                    leading: StreamBuilder<Map<int, dynamic>>(
                                        stream: userBloc.outUser,
                                        initialData: userBloc.outUserValue,
                                        builder: (context, snapshot) {
                                          final information = snapshot
                                              .data![idM]
                                              .information!
                                              .photoProfile;
                                          return information == null
                                              ? CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/images/avatar.png'),
                                                  radius: 30,
                                                )
                                              : CircleAvatar(
                                                  child: Image.network(
                                                      information),
                                                );
                                        }),
                                    title: Text(
                                        '${getCategory(list[index].user.category)}:'),
                                    subtitle: Text(list[index].fullName)),
                              );
                            }),
                      );
              } else {
                profileBloc.addMissionariesChurch(id, null);
              }
            }
            return Center(
                child: CircularProgressIndicator(color: Colors.green));
          }),
    );
  }

  Widget grid() {
    return StreamBuilder<Map<int, dynamic>>(
        stream: profileBloc.outProjectsChurch,
        initialData: profileBloc.outProjectsChurchValue,
        builder: (context, snapshot) {
          getProjectsChurch();

          if (snapshot.hasData) {
            if (snapshot.data![id] != null) {
              final list = snapshot.data![id];
              return list.isEmpty
                  ? noText('projetos')
                  : GridView.builder(
                      padding: const EdgeInsets.all(20.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width ~/ 180).toInt(),
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        userBloc.addUser(list[index].user);
                        userBloc.addCategory(list[index].user.id, list[index]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    bottomSheet: Container(
                                      color: Colors.white,
                                      width: double.infinity,
                                      height: 80,
                                      child: ButtonFilled(
                                        text: widget.first == true
                                            ? 'Voltar ao meu perfil'
                                            : "Voltar aos comentários",
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
                                    body: ProfileProjectPage(
                                      myChurch: true,
                                      back: false,
                                      user: list[index].user,
                                      type: widget.type,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Image.asset(
                                      'assets/images/folder.png',
                                      scale: 1,
                                    ),
                                    Positioned(
                                      left: 30,
                                      top: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: SizedBox(
                                          width: 70,
                                          height: 70,
                                          child: Image.network(list[index]!
                                                  .user
                                                  .information
                                                  .photoProfile ??
                                              link),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    list[index].user.username,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onLongPress: () {},
                        );
                      },
                    );
            } else {
              profileBloc.addProjectsChurch(id, null);
            }
          }
          return Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        });
  }

  Widget noText(text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        'Não há $text',
        style: TextStyle(color: Color.fromRGBO(17, 114, 20, 1)),
        textAlign: TextAlign.center,
      ),
    );
  }

  updateData() async {
    await api.getDataChurch(categoryData.id, 'information').then((value) {
      userBloc.addUser(value.user);
      userBloc.addCategory(value.user.id, value);
    });
  }

  getProjectsChurch() async {
    await api.getDataChurch(categoryData.id, 'projects').then(((value) {
      profileBloc.addProjectsChurch(id, value);
    }));
  }

  getMissionariesChurch() async {
    await api.getDataChurch(categoryData.id, 'missionaries').then(((value) {
      profileBloc.addMissionariesChurch(id, value);
    }));
  }
}
