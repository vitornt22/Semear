import 'package:flutter/material.dart';

class MissionaryTab extends StatelessWidget {
  const MissionaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: 40,
          itemBuilder: (context, index) {
            return const ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/images/amigos.jpeg'),
                radius: 30,
              ),
              title: Text('Missionario:'),
              subtitle: Text('Joao Cardoso Silva'),
            );
          }),
    );
  }
}
