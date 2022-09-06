// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/pages/church_list_validation.dart';
import 'package:semear/pages/missionary_tab.dart';
import 'package:semear/pages/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class ChurchProfilePage extends StatefulWidget {
  ChurchProfilePage({super.key, required this.user, this.controller});

  String user;
  PageController? controller;

  @override
  State<ChurchProfilePage> createState() => _ChurchProfilePageState();
}

class _ChurchProfilePageState extends State<ChurchProfilePage>
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
            visible: widget.user == 'me' ? false : true,
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
          actions: [
            MenuSettings(color: Colors.black),
            SizedBox(
              width: 15,
            )
          ],
          title: Text(
            'AdFront123',
            style: TextStyle(color: Color(0xffa23673A)),
          ),
        ),
        SliverToBoxAdapter(
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    child: Image(
                      image: AssetImage('assets/images/igreja.jpg'),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            height: 120,
                            color: Colors.white,
                            padding: const EdgeInsets.only(right: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: const [
                                      Expanded(
                                        child: Text(
                                          "Assembleia de Deus",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Icon(Icons.add)
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: const [
                                      Expanded(
                                        child: Text(
                                          "Ministério Missão",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(width: 30)
                                    ],
                                  ),
                                  SizedBox(height: 20),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/Adlogo.jpg'),
                  radius: 50,
                ),
              ),
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
                      child: ButtonFilled(text: 'Admiradores', onClick: () {}),
                    ),
                    Expanded(
                      child: ButtonFilled(
                        onClick: () {},
                        text: 'Seguindo',
                      ),
                    ),
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
                tabs: const [
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
                  Tab(
                    text: 'Validações',
                    icon: Icon(
                      Icons.check,
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
              Container(
                color: Colors.white,
                child: GridView.builder(
                  padding: const EdgeInsets.all(20.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {},
                      child: Stack(
                        children: [
                          Image.asset('assets/images/folder.png'),
                          Positioned(
                            left: 30,
                            top: 35,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image(
                                image: AssetImage('assets/images/projeto.jpg'),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 10,
                            child: Text(
                              'Jesus Visitando Escolas',
                              style: TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      onLongPress: () {},
                    );
                  },
                ),
              ),
              MissionaryTab(),
              ValidationTab(),
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
