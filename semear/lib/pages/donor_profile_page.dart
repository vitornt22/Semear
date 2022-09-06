// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/pages/donor_donations.dart';
import 'package:semear/pages/settings_menu.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/widgets/donations_projects.dart';
import 'package:semear/widgets/info_project.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class DonorProfilePage extends StatefulWidget {
  DonorProfilePage({super.key, required this.user, this.controller});

  String user;
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
                                  MenuSettings()
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
              InfoProject(),
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
