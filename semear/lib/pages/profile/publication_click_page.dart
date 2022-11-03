import 'package:flutter/material.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/pages/timeline/post_container.dart';

class PublicationClickPage extends StatefulWidget {
  PublicationClickPage(
      {super.key, required this.type, required this.publication});

  Publication publication;
  String type;
  @override
  State<PublicationClickPage> createState() => _PublicationClickPageState();
}

class _PublicationClickPageState extends State<PublicationClickPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.green),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          child: PostContainer(
        type: widget.type,
        index: null,
        publication: widget.publication,
      )),
    );
  }
}
