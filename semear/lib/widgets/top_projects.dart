import 'dart:ui';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TopProjects extends StatefulWidget {
  TopProjects({super.key, required this.controller});

  PageController controller;

  @override
  State<TopProjects> createState() => _TopProjectsState();
}

class _TopProjectsState extends State<TopProjects> {
  List<String> lista = [
    'Top Projetos',
    'Projetos Missionários',
    'Projetos Sociais',
    'Próximo a você'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const PageStorageKey<String>('page'),
      itemCount: 4,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 400,
          color: Colors.transparent,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    lista[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        // ignore: use_full_hex_values_for_flutter_colors
                        color: Color(0xffa23673A)),
                  ),
                ),
                const Divider(),
                Flexible(
                  child: ScrollConfiguration(
                    behavior:
                        ScrollConfiguration.of(context).copyWith(dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch,
                    }),
                    child: ListView.builder(
                      key: const PageStorageKey<String>('page'),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: 10,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.controller.nextPage(
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.ease);
                            });
                          },
                          child: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: ImageFiltered(
                                    imageFilter:
                                        ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                    child: const Image(
                                      image: AssetImage(
                                          'assets/images/projeto.jpg'),
                                      width: 200.0,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: 70,
                                left: 40,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      AssetImage('assets/images/amigos.jpeg'),
                                ),
                              ),
                              const Positioned(
                                bottom: 50,
                                left: 30,
                                child: Text(
                                  'Amigos do bem',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
