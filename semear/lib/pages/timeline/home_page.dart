// ignore_for_file: use_full_hex_values_for_flutter_colors, unused_field

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/notification_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/timeline/notifications%20_page.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';

import 'timeline.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key, required this.type});
  String type;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final notificationBloc = BlocProvider.getBloc<NotificationBloc>();
  late int? id = userBloc.outMyIdValue;
  late User? user = userBloc.outUserValue![id];

  int _page = 0;
  @override
  void initState() {
    super.initState();
    print("CHEGANDO NA HOME PAGE E PRINTANDO:");
    getNotifications();

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
          children: [
            TimeLine(controller: _pageController, type: 'me'),
            NotificationsPage(
              controller: _pageController,
              user: user!,
            ),
          ],
        ),
      ),
    );
  }

  getNotifications() async {
    await notificationBloc.getNotification(id);
  }
}
