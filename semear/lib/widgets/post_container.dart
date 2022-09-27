// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:semear/widgets/comments.dart';
import 'package:semear/widgets/head_post.dart';

// ignore: must_be_immutable
class PostContainer extends StatefulWidget {
  PostContainer({super.key, required this.type, required this.controller});

  String type;
  PageController controller;
  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  int likesCount = 100;
  String label = 'curtir';
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(),
          HeadPost(user: widget.type, controller: widget.controller),
          const Divider(),
          const SizedBox(
            height: 4.0,
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
                'Hoje Saímos para visitar familias, levar a   amor e a contribuição que vocês, cheios de amor no coração nos ofertaram. Oreis por nós !'),
          ),
          const SizedBox(
            height: 4.0,
          ),
          const Image(image: AssetImage("assets/images/projeto.jpg")),
          Column(
            children: [
              Container(
                height: 50,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.favorite),
                      Expanded(
                        child: GestureDetector(
                          child: Text('$likesCount curtidas'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Comments(
                                focus: false,
                              );
                            },
                            isScrollControlled: true,
                          );
                        },
                        child: Text('100 comentários'),
                      ),
                      SizedBox(width: 20),
                      Text('345 indicações'),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Container(
                height: 70,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          label == "Curtir"
                              ? setState(() {
                                  likesCount++;
                                  label = 'Descurtir';
                                })
                              : setState(() {
                                  likesCount--;
                                  label = 'Curtir';
                                });
                        },
                        label: Text(label,
                            // ignore: use_full_hex_values_for_flutter_colors
                            style: TextStyle(color: Color(0xffb23673a))),
                        icon: const Icon(
                          Icons.favorite,
                          // ignore: use_full_hex_values_for_flutter_colors
                          color: Color(0xffb23673a),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Comments(focus: true);
                              },
                              isScrollControlled: true,
                            );
                          },
                          label: const Text(
                            'Comentar',
                            // ignore: use_full_hex_values_for_flutter_colors
                            style: TextStyle(color: Color(0xffb23673a)),
                          ),
                          icon: const Icon(
                            Icons.comment,
                            // ignore: use_full_hex_values_for_flutter_colors
                            color: Color(0xffb23673a),
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        label: const Text('Indicar',
                            // ignore: use_full_hex_values_for_flutter_colors
                            style: TextStyle(color: Color(0xffb23673a))),
                        icon: const Icon(
                          Icons.share_sharp,
                          // ignore: use_full_hex_values_for_flutter_colors
                          color: Color(0xffb23673a),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider()
          //PostStats(),
        ],
      ),
    );
  }
}
