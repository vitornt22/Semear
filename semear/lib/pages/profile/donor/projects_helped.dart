// ignore_for_file: prefer_const_constructors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/publication_click_page.dart';
import 'package:transparent_image/transparent_image.dart';

class ProjectsHelped extends StatefulWidget {
  ProjectsHelped({super.key, required this.type, required this.user});

  User user;
  String type;

  @override
  State<ProjectsHelped> createState() => _ProjectsHelpedState();
}

class _ProjectsHelpedState extends State<ProjectsHelped> {
  bool checkedValue = true;
  ApiForm apiForm = ApiForm();
  ApiProfile apiProfile = ApiProfile();
  late Future<Map<String, dynamic>> cep;
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: const [
            Text('Projetos que Ajudei'),
            SizedBox(width: 5),
            Icon(Icons.edit)
          ],
        ),
      ),
      body: StreamBuilder<Map<int, List<dynamic>>>(
          stream: profileBloc.outSenderDonations,
          initialData: profileBloc.outSenderDonationsValue,
          builder: (context, snapshot) {
            getProjectsHelped();

            if (snapshot.hasData) {
              if (snapshot.data![widget.user.id] != null) {
                return snapshot.data![widget.user.id]!.isEmpty
                    ? noProjects()
                    : ListView.builder(
                        itemCount: snapshot.data![widget.user.id]!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return listTile(snapshot.data![widget.user.id]);
                        },
                      );
              }
            }
            profileBloc.addSenderDonations(widget.user.id, null);
            return Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }),
    );
  }

  Widget noProjects() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Você não realizou nenhuma doação',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Widget listTile(data) {
    return ListTile(
      title: Text('ola'),
    );
  }

  void getProjectsHelped() async {
    apiProfile.getDonations(widget.user.id, 'sender').then((value) {
      profileBloc.addSenderDonations(widget.user.id, value);
    });
  }
}
