// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/initial_page.dart';
import 'package:semear/pages/profile/donor/projects_helped.dart';
import 'package:semear/pages/profile/following_screen.dart';
import 'package:semear/pages/profile/project/donations_projects_tab.dart';
import 'package:semear/pages/profile/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';

class AnonymousProfilePage extends StatefulWidget {
  const AnonymousProfilePage({
    super.key,
  });

  @override
  State<AnonymousProfilePage> createState() => _AnonymousProfilePageState();
}

class _AnonymousProfilePageState extends State<AnonymousProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  bool hasSite = true;
  String link = 'https://cdn-icons-png.flaticon.com/512/149/149071.png';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextButton.icon(
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => InitialPage()),
                        (route) => false);
                  },
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.green,
                  ),
                  label: Text('Sair ')),
            )
          ],
          title: StreamBuilder<Map<int, User?>>(
              stream: userBloc.outUser,
              initialData: userBloc.outUserValue,
              builder: (context, snapshot) {
                return Text(
                  'Anônimo',
                  style: TextStyle(color: Color(0xffa23673A)),
                );
              }),
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
                                backgroundImage: AssetImage(
                                  'assets/images/anonimo.png',
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
                                            'Usuário Anônimo',
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      "doador/voluntário",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  SizedBox(width: 30)
                                ],
                              ),
                              SizedBox(height: 20),
                              StreamBuilder<Map<int, dynamic>>(
                                  stream: userBloc.outCategory,
                                  initialData: userBloc.outCategoryValue,
                                  builder: (context, snapshot) {
                                    return Text(
                                      '',
                                      style: TextStyle(fontSize: 15),
                                    );
                                  }),
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
                    Expanded(
                      child: ButtonFilled(text: 'Seguindo', onClick: () {}),
                    ),
                    Expanded(
                      child: ButtonFilled(
                        text: 'Projetos que Ajudei',
                        onClick: () {},
                      ),
                    ),
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
                    text: 'Doações',
                    icon: Icon(
                      Icons.monetization_on,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  Tab(
                    text: 'Salvos',
                    icon: Icon(
                      Icons.save_outlined,
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
              Container(),
              Container(
                color: Colors.white,
              )
            ],
          ),
        ),
      ],
    );
  }
}
