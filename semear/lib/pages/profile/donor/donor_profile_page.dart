// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:semear/models/donor_model.dart';
import 'package:semear/models/information_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/donor/donor_donations_tab.dart';
import 'package:semear/pages/profile/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/pages/profile/project/info_project_tab.dart';

class DonorProfilePage extends StatefulWidget {
  DonorProfilePage({super.key, required this.type, this.controller});

  String type;
  PageController? controller;

  @override
  State<DonorProfilePage> createState() => _DonorProfilePageState();
}

class _DonorProfilePageState extends State<DonorProfilePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool hasSite = true;

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
            'LuizAndre22',
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
                              AssetImage('assets/images/donor.jpeg'),
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
                                      "Luiz André da Silva",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  Visibility(
                                    visible: widget.type == 'me' ? true : false,
                                    child: MenuSettings(
                                      categoryData: Donor(),
                                      user: User(),
                                    ),
                                  )
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
                              Text(
                                "Picos-Pi",
                                style: TextStyle(fontSize: 15),
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
                    Expanded(
                      child: ButtonFilled(text: 'Seguindo', onClick: () {}),
                    ),
                    Expanded(
                        child: ButtonFilled(
                            text: 'Projetos que Ajudei', onClick: () {})),
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
              DonationsDonor(),
              InfoProject(
                type: widget.type,
                categoryData: Donor(),
                user: User(),
                category: 'missionary',
                information: Information(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
