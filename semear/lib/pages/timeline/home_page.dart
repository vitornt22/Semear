// ignore_for_file: use_full_hex_values_for_flutter_colors, unused_field

import 'package:flutter/material.dart';
import 'package:semear/blocs/homescreen_bloc.dart';
import 'package:semear/pages/timeline/notifications%20_page.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';

import 'timeline.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key, required this.user, required this.type});
  Stream<Map<String, dynamic>> user;
  String type;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;

  int _page = 0;
  @override
  void initState() {
    super.initState();
    print("CHEGANDO NA HOME PAGE E PRINTANDO: ${widget.user}");
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          key: const PageStorageKey<String>('page'),
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: (p) {
            setState(() {
              _page = p;
            });
          },
          children: <Widget>[
            TimeLine(
                controller: _pageController, type: 'me', user: widget.user),
            NotificationsPage(controller: _pageController),
            ProfileProjectPage(
              user: widget.user,
              type: widget.type,
              controller: _pageController,
            )
          ],
        ),
      ),
    );
  }
}
