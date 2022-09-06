// ignore_for_file: prefer_const_constructors, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:semear/widgets/grid_search.dart';
import 'package:semear/widgets/top_projects.dart';

class TabBarProjects extends StatefulWidget {
  TabBarProjects({super.key, required this.controller});

  PageController controller;
  @override
  State<TabBarProjects> createState() => _TabBarProjectsState();
}

class _TabBarProjectsState extends State<TabBarProjects>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 211, 211),
      appBar: AppBar(
        leading: SizedBox(),
        // ignore: use_full_hex_values_for_flutter_colors
        backgroundColor: const Color(0xffa23673A),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: 350,
            height: 30,
            child: TextField(
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                prefixIcon: const IconTheme(
                  data: IconThemeData(
                    color: Colors.grey,
                  ),
                  child: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffa23673A)),
                    borderRadius: BorderRadius.circular(20)),
                hintText: 'Pesquisar',
                contentPadding: EdgeInsets.only(top: 8),
                fillColor: Colors.white,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  gapPadding: 5,
                  borderSide: const BorderSide(color: Colors.green, width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          labelStyle: TextStyle(fontSize: 11),
          tabs: const [
            Tab(text: 'Top', icon: Icon(Icons.trending_up_outlined)),
            Tab(text: 'Projetos', icon: Icon(Icons.folder, size: 15)),
            Tab(text: 'Missionários', icon: Icon(Icons.person, size: 15)),
            Tab(text: 'Igrejas', icon: Icon(Icons.church, size: 15)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TopProjects(controller: widget.controller),
          GridSearch(controller: widget.controller),
          GridSearch(controller: widget.controller),
          GridSearch(controller: widget.controller),
        ],
      ),
    );
  }
}
