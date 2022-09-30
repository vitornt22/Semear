// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/publication_bloc.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/pages/timeline/publication.dart';
import 'package:semear/pages/timeline/post_container.dart';

import 'chat_page.dart';

class TimeLine extends StatefulWidget {
  TimeLine({super.key, required this.controller, required this.type});
  PageController controller;
  String type;
  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  final _pubBloc = BlocProvider.getBloc<PublicationBloc>();

  @override
  void initState() {
    super.initState();
    print("OLA TIMELINE");
    PublicationBloc();
  }

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
                          builder: (context) => PublicationPage(),
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
        StreamBuilder<List<Publication>>(
            stream: _pubBloc.outPublications,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Flexible(
                  child: ListView.builder(
                      key: const PageStorageKey<String>('page'),
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        print("ENTROUI VITOR");
                        return PostContainer(
                            publication: snapshot.data![index],
                            type: widget.type,
                            controller: widget.controller);
                      }),
                );
              } else {
                return Container(color: Colors.yellow);
              }
            }),
      ],
    );
  }
}
