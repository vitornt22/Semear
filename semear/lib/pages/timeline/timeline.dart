// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:semear/pages/timeline/publication.dart';
import 'package:semear/widgets/post_container.dart';

import 'chat_page.dart';

class TimeLine extends StatefulWidget {
  TimeLine(
      {super.key,
      required this.controller,
      required this.user,
      required this.type});

  PageController controller;
  Stream<Map<String, dynamic>> user;
  String type;
  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: const Color(0xffa23673A),
          leadingWidth: 230,
          leading: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Image(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {},
                icon: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              PublicationPage(user: widget.user),
                        ),
                      );
                    },
                    icon: Icon(Icons.add_a_photo))),
            const SizedBox(width: 15),
            IconButton(
              onPressed: () {
                widget.controller.jumpToPage(1);
              },
              icon: const Icon(Icons.notifications),
            ),
            const SizedBox(width: 15),
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ChatPage();
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.chat)),
            const SizedBox(width: 15),
          ],
        ),
        Flexible(
          child: ListView.builder(
              key: const PageStorageKey<String>('page'),
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (context, index) {
                return PostContainer(
                    type: widget.type, controller: widget.controller);
              }),
        )
      ],
    );
  }
}