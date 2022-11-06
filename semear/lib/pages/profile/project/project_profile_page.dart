// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/apis/api_profile.dart';
import 'package:semear/apis/api_settings.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/settings_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/church_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church/church_profile_page.dart';
import 'package:semear/pages/profile/followers_screen.dart';
import 'package:semear/pages/profile/following_screen.dart';
import 'package:semear/pages/profile/publication_click_page.dart';
import 'package:semear/pages/timeline/publication.dart';
import 'package:semear/pages/profile/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/pages/profile/project/donations_projects_tab.dart';
import 'package:semear/pages/profile/project/info_project_tab.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileProjectPage extends StatefulWidget {
  ProfileProjectPage(
      {super.key,
      required this.user,
      this.back,
      required this.type,
      this.controller});

  String type;
  User user;
  bool? back;
  var categoryData;
  PageController? controller;

  @override
  State<ProfileProjectPage> createState() => _ProfileProjectPageState();
}

class _ProfileProjectPageState extends State<ProfileProjectPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  ApiProfile api = ApiProfile();
  ApiSettings settings = ApiSettings();
  bool hasSite = true;
  int? idUser;
  Church? myChurch;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final settingsBloc = BlocProvider.getBloc<SettingBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(0);
    idUser = widget.user.id;
  }

  @override
  Widget build(BuildContext context) {
    myChurch = userBloc.outCategoryValue![idUser].church;

    print("MYCHURCH: $myChurch");

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: Visibility(
            visible: widget.back != true,
            child: IconButton(
              onPressed: () {
                if (widget.controller != null) {
                  widget.controller!.jumpToPage(0);
                }
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: StreamBuilder<Map<int, User?>>(
            stream: userBloc.outUser,
            initialData: userBloc.outUserValue,
            builder: (context, snapshot) => Text(
              snapshot.data![idUser]!.username ?? '',
              style: TextStyle(color: Color(0xffa23673A)),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 20, left: 10, top: 10),
                        child: StreamBuilder<Map<int, User?>>(
                            stream: userBloc.outUser,
                            initialData: userBloc.outUserValue,
                            builder: (context, snapshot) {
                              return CircleAvatar(
                                backgroundColor: Colors.green,
                                backgroundImage: NetworkImage(
                                  snapshot.data![idUser]!.information!
                                          .photoProfile ??
                                      'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                                ),
                                radius: 60,
                              );
                            }),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: StreamBuilder<Map<int, dynamic>>(
                                        stream: userBloc.outCategory,
                                        initialData: userBloc.outCategoryValue,
                                        builder: (context, snapshot) {
                                          return Text(
                                            snapshot.data![idUser].name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          );
                                        }),
                                  ),
                                  Visibility(
                                      visible:
                                          widget.type == 'me' ? true : false,
                                      child: MenuSettings(
                                        user: widget.user,
                                        categoryData: widget.categoryData,
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: StreamBuilder<Map<int, User?>>(
                                        stream: userBloc.outUser,
                                        initialData: userBloc.outUserValue,
                                        builder: (context, snapshot) {
                                          return Text(
                                            snapshot.data![idUser]!.information!
                                                    .resume ??
                                                ' ',
                                            style: TextStyle(fontSize: 15),
                                          );
                                        }),
                                  ),
                                  SizedBox(width: 30)
                                ],
                              ),
                              Visibility(
                                  visible: hasSite == true ? true : false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: StreamBuilder<Map<int, User?>>(
                                        stream: userBloc.outUser,
                                        initialData: userBloc.outUserValue,
                                        builder: (context, snapshot) {
                                          return Text(snapshot.data![idUser]!
                                                  .information!.site ??
                                              '');
                                        }),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      //Add location option click
                                    },
                                    child: StreamBuilder<Map<int, dynamic>>(
                                      stream: userBloc.outCategory,
                                      initialData: userBloc.outCategoryValue,
                                      builder: (context, snapshot) => Text(
                                        '${snapshot.data![idUser].adress.city}-${snapshot.data![idUser].adress.uf}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                            body: ChurchProfilePage(
                                              user: myChurch!.user!,
                                              type: 'other',
                                              first: true,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Minha Igreja',
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: Color.fromARGB(255, 255, 255, 255),
            child: Column(
              children: [
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.type == 'me'
                        ? Expanded(
                            child: ButtonFilled(
                              onClick: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      body: PublicationPage(),
                                    ),
                                  ),
                                );
                              },
                              text: 'Publicar',
                            ),
                          )
                        : getButton(context),
                    ButtonFilled(
                        text: 'Seguidores',
                        onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FollowersScreen(
                                        user: widget.user,
                                        first: true,
                                      )));
                        }),
                    Expanded(
                      child: ButtonFilled(
                        onClick: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FollowingScreen(
                                        user: widget.user,
                                        first: true,
                                      )));
                        },
                        text: 'Seguindo',
                      ),
                    ),
                    SizedBox()
                  ],
                ),
                Divider(),
              ],
            ),
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
                tabs: const [
                  Tab(
                    text: 'Publicações',
                    icon: Icon(
                      Icons.dashboard,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  Tab(
                    text: 'Doações',
                    icon: Icon(
                      Icons.monetization_on,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  Tab(
                    text: 'Informações',
                    icon: Icon(
                      Icons.info,
                      color: Colors.black,
                      size: 20,
                    ),
                  )
                ]),
          ),
        ),
        SliverFillRemaining(
          child: TabBarView(
            controller: _tabController,
            children: [
              StreamBuilder<Map<int, List<dynamic>>>(
                stream: profileBloc.outPublications,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data![idUser] != null) {
                      return createPublicationTable(
                          context, snapshot.data![idUser]);
                    }
                  }
                  getPublications();
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                },
              ),
              DonationsProject(
                  type: widget.type,
                  categoryData: widget.categoryData,
                  user: widget.user),
              InfoProject(
                  type: widget.type,
                  user: widget.user,
                  categoryData: widget.categoryData,
                  category: 'project',
                  information: widget.user.information!),
            ],
          ),
        ),
      ],
    );
  }

  Widget getButton(context) {
    return StreamBuilder<Map<int, bool>>(
      stream: settingsBloc.outFollowerController,
      initialData: settingsBloc.outFollowerValue,
      builder: (context, snapshot) {
        getLabel();
        if (snapshot.hasData && snapshot.data![idUser] != null) {
          return Padding(
              padding: const EdgeInsets.all(15),
              child: snapshot.data![idUser] == true
                  ? ButtonFilled(
                      loading: true,
                      onClick: unFolllowerClick,
                      text: 'sigo',
                    )
                  : ButtonFilled(
                      loading: true,
                      changeColor: true,
                      onClick: setFollowerClick,
                      text: 'Seguir',
                    ));
        }
        return SizedBox(
          height: 15,
          width: 15,
          child: CircularProgressIndicator(color: Colors.green),
        );
      },
    );
  }

  void setFollowerClick() async {
    print("FOLLOWING");
    settingsBloc.inLoading.add(true);
    final scaffold = ScaffoldMessenger.of(context);
    final value = await settings.setFollower(userBloc.outMyIdValue, idUser);
    if (value != null) {
      userBloc.updateUser(value);
      settingsBloc.changeFollower(idUser, true);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Você comecou a seguir ${userBloc.outUserValue![idUser]!.username!}',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao tentar seguir ${widget.user.username} ',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    settingsBloc.inLoading.add(false);
  }

  void unFolllowerClick() async {
    settingsBloc.inLoading.add(true);

    final scaffold = ScaffoldMessenger.of(context);
    print("UNFOLLOWING");
    final value = await settings.unFollow(userBloc.outMyIdValue, idUser);
    if (value != null) {
      userBloc.updateUser(value);
      settingsBloc.changeFollower(idUser, false);
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Você deixou de seguir  ${userBloc.outUserValue![idUser]!.username} ',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            'Erro ao tentar deixar de seguir ${userBloc.outUserValue![idUser]!.username} ',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    settingsBloc.inLoading.add(false);
  }

  void getLabel() {
    settings
        .getLabelFollower(userBloc.outMyIdValue, idUser)
        .then((value) => settingsBloc.changeFollower(idUser, value));
  }

  Widget createPublicationTable(BuildContext context, snapshot) {
    return Container(
      color: Colors.white,
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10,
        ),
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot[index].upload ?? CircleAvatar(),
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PublicationClickPage(
                        type: widget.type, publication: snapshot[index]),
                  ),
                );
              },
              onLongPress: () {
                //Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                //["url"]);
              });
        },
      ),
    );
  }

  void getPublications() async {
    api.getPublications(idUser).then((value) {
      profileBloc.addPublications(idUser, value);
    });
  }
}
