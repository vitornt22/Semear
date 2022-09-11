// ignore_for_file: use_full_hex_values_for_flutter_colors, unnecessary_const, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:semear/widgets/list_chat.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  FocusNode myFocusNode = FocusNode();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(0);
  }

  bool hasMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'JesusVisitandoFamilias',
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(width: 10),
            Icon(Icons.chat_bubble_outline),
          ],
        ),
        // ignore: prefer_const_constructors
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          labelStyle: TextStyle(color: Colors.green),
          labelColor: Colors.black,
          tabs: const [
            Tab(text: 'Mensagens', icon: Icon(Icons.message)),
            Tab(text: 'Novo Chat', icon: Icon(Icons.edit)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ListChat(),
          ListChat(),
        ],
      ),
    );
  }
}
