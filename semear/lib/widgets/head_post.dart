// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';
import 'package:semear/pages/timeline/post_settings.dart';
import 'package:semear/widgets/sugestion_avatar.dart';

class HeadPost extends StatefulWidget {
  HeadPost({super.key, required this.user, required this.controller});

  String user;
  PageController controller;
  @override
  State<HeadPost> createState() => _HeadPostState();
}

class _HeadPostState extends State<HeadPost> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: Sugestion_Avatar(),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.user = 'vitor agora';
                      widget.controller.jumpToPage(2);
                    },
                    child: const Text(
                      'Jesus Visitando Familia',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 1,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.folder,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'Há 8h',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: PostSettings(),
        ),
      ],
    );
  }
}
