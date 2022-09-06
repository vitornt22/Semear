// ignore_for_file: file_names, prefer_const_constructors

import "package:flutter/material.dart";

class NotificationsPage extends StatefulWidget {
  NotificationsPage({super.key, required this.controller});

  PageController controller;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 80,
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    widget.controller.previousPage(
                        duration: const Duration(microseconds: 500),
                        curve: Curves.ease);
                  },
                  icon: const Icon(Icons.arrow_back, color: Colors.green),
                ),
                const Icon(
                  Icons.notifications,
                  color: Colors.green,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Notificações",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.separated(
              key: const PageStorageKey<String>('page'),
              itemCount: 100,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemBuilder: (context, index) {
                return ListTile(
                  title: index % 2 == 0
                      ? Text("Joao Curtiu sua foto")
                      : Text('validação'),
                  subtitle: const Text('há 2h.'),
                  trailing: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const Image(
                      image: AssetImage('assets/images/projeto.jpg'),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
