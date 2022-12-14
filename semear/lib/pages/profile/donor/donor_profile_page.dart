// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/donor_model.dart';
import 'package:semear/models/information_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/donor/projects_helped.dart';
import 'package:semear/pages/profile/following_screen.dart';
import 'package:semear/pages/profile/project/donations_projects_tab.dart';
import 'package:semear/pages/profile/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/pages/profile/project/info_project_tab.dart';

class DonorProfilePage extends StatefulWidget {
  DonorProfilePage({super.key, required this.user, required this.type});

  String type;
  User user;

  @override
  State<DonorProfilePage> createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  bool hasSite = true;
  late int? idUser = widget.user.id;
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
          title: StreamBuilder<Map<int, User?>>(
              stream: userBloc.outUser,
              initialData: userBloc.outUserValue,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data![widget.user.id]!.username ?? '',
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
                                backgroundImage:
                                    snapshot.data![idUser]!.information != null
                                        ? NetworkImage(
                                            snapshot.data![idUser]!.information!
                                                    .photoProfile ??
                                                'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                                          )
                                        : NetworkImage(
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
                                            snapshot.data![widget.user.id]!
                                                    .fullName ??
                                                "",
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700),
                                          );
                                        }),
                                  ),
                                  Visibility(
                                    visible: widget.type == 'me' ? true : false,
                                    child: MenuSettings(
                                      categoryData: userBloc
                                          .outCategoryValue![widget.user.id],
                                      user: userBloc
                                          .outUserValue![widget.user.id]!,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: const [
                                  Expanded(
                                    child: Text(
                                      "doador/volunt??rio",
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
                      child: ButtonFilled(
                          text: 'Seguindo',
                          onClick: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FollowingScreen(
                                          user: widget.user,
                                          first: true,
                                        )));
                          }),
                    ),
                    Expanded(
                        child: ButtonFilled(
                            text: 'Projetos que Ajudei',
                            onClick: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProjectsHelped(
                                          type: widget.type,
                                          user: widget.user)));
                            })),
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
                    text: 'Doa????es',
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
              DonationsProject(
                type: widget.type,
                user: widget.user,
              ),
              Container(
                color: Colors.green,
              )
            ],
          ),
        ),
      ],
    );
  }
}
