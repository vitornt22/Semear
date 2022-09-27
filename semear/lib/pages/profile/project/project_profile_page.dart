// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/widgets/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/pages/profile/project/donations_projects_tab.dart';
import 'package:semear/pages/profile/project/info_project_tab.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileProjectPage extends StatefulWidget {
  ProfileProjectPage(
      {super.key, required this.user, required this.type, this.controller});

  Stream<Map<String, dynamic>> user;
  String type;
  PageController? controller;

  @override
  State<ProfileProjectPage> createState() => _ProfileProjectPageState();
}

class _ProfileProjectPageState extends State<ProfileProjectPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool hasSite = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.animateTo(0);
  }

  _getGifs() async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://api.giphy.com/v1/gifs/trending?api_key=mTjlHb8OsXPjnxkEZ283j3mQ0QIKvtgG&limit=20&rating=g'));

    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
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
              },
              icon: Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'JesusVisitandoFamilias123',
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
                      const Padding(
                        padding: EdgeInsets.only(right: 20, left: 10, top: 10),
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/images/amigos.jpeg'),
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
                                      "Amigos do Bem",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  MenuSettings()
                                ],
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      "Projeto missionario e social com intuito de ajudar familias carentes residentes em periferias",
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
                                    child: Text('www.amigosdobem.com.br'),
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Picos-Pi",
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    "Assembleia de Deus",
                                    style: TextStyle(fontSize: 15),
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
                            onClick: () {},
                            text: 'Publicar',
                          )
                        : ButtonFilled(
                            text: 'Seguir',
                            onClick: () {},
                          ),
                    Expanded(
                      child: ButtonFilled(text: 'Admiradores', onClick: () {}),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(15),
                        child: ButtonFilled(
                          onClick: () {},
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
              FutureBuilder(
                future: _getGifs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return _createGifTable(context, snapshot);
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text("${snapshot.error}: ERROO"),
                      );
                    }
                  }
                  return Container(
                    width: 200.0,
                    height: 200.0,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 5.0,
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

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10,
      ),
      itemCount: 20,
      itemBuilder: (context, index) {
        return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: () {},
            onLongPress: () {
              Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                  ["url"]);
            });
      },
    );
  }
}
