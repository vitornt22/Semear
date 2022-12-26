import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/publication_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/models/user_model.dart';

class EditPublicationPage extends StatefulWidget {
  EditPublicationPage({super.key, required this.publication});
  Publication publication;
  @override
  State<EditPublicationPage> createState() => _EditPublicationPageState();
}

class _EditPublicationPageState extends State<EditPublicationPage> {
  final pubBloc = BlocProvider.getBloc<PublicationBloc>();
  final userBloc = BlocProvider.getBloc<UserBloc>();

  int? id;
  var categoryData;
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.publication.user!.id;
    user = userBloc.outUserValue![id];
    categoryData = userBloc.outCategoryValue![id];
    //pubBloc.inImage.add(widget.publication.updatedAt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          categoryText(),
        ]),
      ),
    );
  }

  Widget categoryText() {
    final category = user!.category == 'project' ? 'Projeto' : 'Missionário';
    final name = user!.category == 'project'
        ? categoryData!.name
        : categoryData!.fullName;
    return Text('$category :$name');
  }
}
