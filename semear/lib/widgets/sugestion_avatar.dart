import 'package:flutter/material.dart';

// ignore: camel_case_types
class Sugestion_Avatar extends StatefulWidget {
  const Sugestion_Avatar({super.key});

  @override
  State<Sugestion_Avatar> createState() => _Sugestion_AvatarState();
}

// ignore: camel_case_types
class _Sugestion_AvatarState extends State<Sugestion_Avatar> {
  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      minRadius: 20,
      maxRadius: 40,
      backgroundColor: Colors.black,
      backgroundImage: AssetImage("assets/images/amigos.jpeg"),
    );
  }
}
