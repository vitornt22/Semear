// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/apis/api_profile.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/models/church_model.dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church/church_profile_page.dart';
import 'package:semear/pages/profile/followers_screen.dart';
import 'package:semear/pages/profile/following_screen.dart';
import 'package:semear/pages/profile/publication_click_page.dart';
import 'package:semear/pages/timeline/publication.dart';
import 'package:semear/widgets/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/pages/profile/project/donations_projects_tab.dart';
import 'package:semear/pages/profile/project/info_project_tab.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileProjectPage extends StatefulWidget {
  ProfileProjectPage(
      {super.key,
      required this.user,
      required this.categoryData,
      required this.type,
      this.controller});

  String type;
  User user;
  var categoryData;
  PageController? controller;

  @override
  State<ProfileProjectPage> createState() => _ProfileProjectPageState();
}

class _ProfileProjectPageState extends State<ProfileProjectPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  ApiProfile api = ApiProfile();
  bool hasSite = true;
  Church? myChurch;
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    myChurch = widget.categoryData.church;

    print("MYCHURCH: $myChurch");

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: Visibility(
            visible: widget.type == 'me' ? false : true,
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
          title: Text(
            widget.user.username!,
            style: TextStyle(color: Color(0xffa23673A)),
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
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              widget.user.information!.photoProfile!),
                          radius: 60,
                        ),
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
                                    child: Text(
                                      widget.categoryData.name,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible:
                                          widget.type == 'me' ? true : false,
                                      child: MenuSettings())
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.user.information!.resume!,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(width: 30)
                                ],
                              ),
                              Visibility(
                                  visible: hasSite == true ? true : false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Text(
                                        widget.user.information!.site ?? ''),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text(
                                      widget.type == 'me'
                                          ? '${widget.categoryData.adress.city}-${widget.categoryData.adress.uf}'
                                          : '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
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
                        ? ButtonFilled(
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                            body: PublicationPage(),
                                          )));
                            },
                            text: 'Publicar',
                          )
                        : ButtonFilled(
                            text: 'Seguir',
                            onClick: () {},
                          ),
                    Expanded(
                      child: ButtonFilled(
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
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15),
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
                        )),
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
                    if (snapshot.data![widget.user.id] != null) {
                      return createPublicationTable(
                          context, snapshot.data![widget.user.id]);
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
              DonationsProject(),
              InfoProject(category: 'project'),
            ],
          ),
        ),
      ],
    );
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
                image: snapshot[index].upload,
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.green,
                      ),
                      body: PublicationClickPage(publication: snapshot[index]),
                    ),
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
    api.getPublications(widget.user.id).then((value) {
      profileBloc.addPublications(widget.user.id, value);
    });
  }
}
