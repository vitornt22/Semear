import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/timeline/publication.dart';

class ChurchProjectsPage extends StatefulWidget {
  ChurchProjectsPage({super.key, required this.user});

  User user;
  @override
  State<ChurchProjectsPage> createState() => _ChurchProjectsPageState();
}

class _ChurchProjectsPageState extends State<ChurchProjectsPage> {
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  var categoryData;
  int? id;

  ApiProfile api = ApiProfile();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = userBloc.outMyIdValue;
    categoryData = userBloc.outCategoryValue![id];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecione Projeto para postagem'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          color: Colors.white,
          child: StreamBuilder<Map<int, dynamic>>(
              stream: profileBloc.outProjectsChurch,
              initialData: profileBloc.outProjectsChurchValue,
              builder: (context, snapshot) {
                getChurchProjects();

                if (snapshot.hasData) {
                  final data = snapshot.data![id];

                  return ListView.separated(
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: data.isEmpty ? 1 : data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final project = data[index];
                        userBloc.addUser(project.user);
                        userBloc.addCategory(project.user.id, project);
                        return data.isEmpty
                            ? const Text('Não há projetos para publicação')
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PublicationPage(user: project.user),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  trailing: const Expanded(
                                    child: Text(
                                      'Publicar',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    radius: 30,
                                    child:
                                        project.user.information.photoProfile !=
                                                null
                                            ? Image.network(project
                                                .user.information.photoProfile)
                                            : Image.asset(
                                                'assets/images/avatar.png'),
                                  ),
                                  title: Text(project.name ?? ' '),
                                ),
                              );
                      });
                }

                return const Center(
                  child: CircularProgressIndicator(color: Colors.green),
                );
              }),
        ),
      ),
    );
  }

  getChurchProjects() {
    api.getDataChurch(categoryData.id, 'projects').then((value) {
      print(value);
      return profileBloc.addProjectsChurch(id, value);
    });
  }
}
