// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church/church_list_validation_tab.dart';
import 'package:semear/pages/profile/following_screen.dart';
import 'package:semear/widgets/button_outlined_profile.dart';
import 'package:semear/widgets/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';

import 'missionary_tab.dart';

class ChurchProfilePage extends StatefulWidget {
  ChurchProfilePage(
      {super.key, required this.user, required this.type, required this.first});

  String type;
  User user;
  bool first;
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

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          leading: Visibility(
            visible: widget.type == 'me' ? false : true,
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
                            height: 150,
                            color: Colors.white,
                            padding: const EdgeInsets.only(right: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Assembleia de Deus",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Visibility(
                                        visible:
                                            widget.type == 'me' ? true : false,
                                        child: IconButton(
                                            tooltip: 'Adicionar publicação',
                                            onPressed: () {},
                                            icon: Icon(Icons.add_a_photo)),
                                      )
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
                      child: ButtonFilled(
                          text: 'Projetos que segue',
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
                                text: 'Criar projeto', onClick: () {}))
                        : Expanded(
                            child: ButtonOutlinedProfile(
                              onClick: () {},
                              text: 'Seguir Projetos',
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
                                      print("WIDGET.FIRST, ${widget.first}");
                                      widget.first == false
                                          ? Navigator.of(context).popUntil(
                                              (route) =>
                                                  route.settings.arguments ==
                                                  true)
                                          : Navigator.of(context).popUntil(
                                              (route) => route.isFirst == true);
                                    },
                                  ),
                                ),
                                body: ChurchProfilePage(
                                  user: widget.user,
                                  first: widget.first,
                                  type: 'follower',
                                ),
                              );
                            },
                          ),
                        );
                      },
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
}
