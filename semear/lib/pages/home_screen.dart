// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/homescreen_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/pages/profile/donor/donor_profile_page.dart';
import 'package:semear/pages/profile/missionary/missionary_profile_page.dart';
import 'package:semear/pages/timeline/home_page.dart';
import 'package:semear/pages/profile/church/church_profile_page.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';
import 'package:semear/pages/search/projects_page.dart';
import 'package:semear/pages/transaction/transaction_page.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.user});

  String user;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    _homeScreenBloc = HomeScreenBloc();
    pages = {
      'church': ChurchProfilePage(user: 'me'),
      'project': ProfileProjectPage(type: 'me', user: _homeScreenBloc.outUser),
      'missionary': ProfileMissionaryPage(user: 'me'),
      'donor': DonorProfilePage(user: 'me'),
    };
    print("TESTEEE: ${_homeScreenBloc.outUser}");
    if (userBloc.outUser.category == 'AnonymousDonor') {
      items.removeAt(4);
    }
    _pageController = PageController();
  }

  late Map<String, dynamic> pages;
  late PageController _pageController;
  late HomeScreenBloc _homeScreenBloc;
  late AsyncSnapshot blocAsAsync;
  final userBloc = BlocProvider.getBloc<UserBloc>();

  int _page = 0;

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home, size: 30),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search_rounded, size: 30),
      label: 'Projetos',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.map, size: 30),
      label: 'Panorama',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.monetization_on, size: 30),
      label: 'Transações',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person, size: 30),
      label: 'Perfil',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 224, 211, 211),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _page,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          selectedItemColor: const Color.fromARGB(250, 2, 194, 66),
          onTap: (p) {
            _pageController.animateToPage(p,
                duration: const Duration(milliseconds: 600),
                curve: Curves.ease);
          },
          items: items,
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (p) {
            setState(() {
              _page = p;
            });
          },
          children: <Widget>[
            HomePage(
              user: _homeScreenBloc.outUser,
              type: 'me',
            ),
            ProjectsPage(controller: _pageController),
            Container(color: const Color(0xffa23673A)),
            const TransactionPage(),
            userBloc.outUser.category != 'AnonymousDonor'
                ? pages[userBloc.outUser.category]
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
