import 'package:flutter/material.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/pages/timeline/post_container.dart';

class PublicationClickPage extends StatefulWidget {
  PublicationClickPage({super.key, required this.publication});

  Publication publication;
  @override
  State<PublicationClickPage> createState() => _PublicationClickPageState();
}

class _PublicationClickPageState extends State<PublicationClickPage> {
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.yellow);
  }
}
