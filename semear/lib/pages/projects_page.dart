// ignore_for_file: use_full_hex_values_for_flutter_colors, unnecessary_const, duplicate_ignore, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:semear/pages/profile_project_page.dart';
import 'package:semear/pages/tab_bar_projects.dart';
import 'package:semear/widgets/top_projects.dart';

import '../widgets/grid_search.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late PageController _pageController;

  int _page = 1;

  @override
  void initState() {
    super.initState();
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
            TabBarProjects(controller: _pageController),
            ProfileProjectPage(
              user: 'follower',
              controller: _pageController,
            ),
            ProfileProjectPage(
              user: 'follower',
              controller: _pageController,
            ),
            ProfileProjectPage(
              user: 'follower',
              controller: _pageController,
            ),
          ],
        ),
      ),
    );
  }
}
