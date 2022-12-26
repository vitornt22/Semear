// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_search.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/search_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';

// ignore: must_be_immutable
class TopProjects extends StatefulWidget {
  TopProjects({super.key, required this.controller});

  PageController controller;

  @override
  State<TopProjects> createState() => _TopProjectsState();
}

class _TopProjectsState extends State<TopProjects> {
  final api = ApiSearch();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();
  User? myUser;
  int? myId;

  final searchhBloc = BlocProvider.getBloc<SearchBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myId = userBloc.outMyIdValue;
    myUser = userBloc.outUserValue![myId];
    api.getPageRankProjects('getTopProjects', '');
  }

  @override
  Widget build(BuildContext context) {
    return searchhBloc.outTopMissionariesValue == null ||
            searchhBloc.outTopProjectsValue == null
        ? Center(
            child: CircularProgressIndicator(
            color: Colors.green,
          ))
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder<List<dynamic>>(
                  stream: searchhBloc.outTopProjects,
                  initialData: [searchhBloc.outTopProjectsValue],
                  builder: (context, snapshot) {
                    return container('Top Projetos', snapshot, 'project');
                  },
                ),
                SizedBox(height: 30),
                StreamBuilder<List<dynamic>>(
                  stream: searchhBloc.outTopMissionaries,
                  initialData: searchhBloc.outTopMissionariesValue,
                  builder: (context, snapshot) {
                    return container(
                        'Top Missionários', snapshot, 'missionary');
                  },
                )
              ],
            ),
          );
  }

  Widget container(text, snapshot, category) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 400,
      color: Colors.transparent,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    // ignore: use_full_hex_values_for_flutter_colors
                    color: Color(0xffa23673A)),
              ),
            ),
            const Divider(),
            snapshot.data != null && snapshot.data.isNotEmpty
                ? listProjects(snapshot, category)
                : noProjects(snapshot)
          ],
        ),
      ),
    );
  }

  Future<bool> getMyChurch(data) async {
    final id = userBloc.outMyIdValue;

    if (userBloc.outUserValue![id]!.category == 'church') {
      final categoryData = profileBloc.outProjectsChurchValue![id]!;
      return categoryData != null && categoryData.contains(data.id);
    }
    return false;
  }

  Widget noProjects(snapshot) {
    return Expanded(
      child: Center(
        child: Text(
          'Não há projetos ainda ',
          style: TextStyle(color: Colors.green),
        ),
      ),
    );
  }

  Widget listProjects(snapshot, category) {
    return Flexible(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        }),
        child: snapshot.data == null || snapshot.data.isEmpty
            ? SizedBox()
            : ListView.builder(
                key: const PageStorageKey<String>('page'),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return snapshot.data[index] == null
                      ? SizedBox()
                      : GestureDetector(
                          onTap: () async {
                            late final myChurch;
                            myChurch =
                                await getMyChurch(snapshot.data[index].user);

                            final navigator = Navigator.of(context);
                            if (myUser!.category == 'church' &&
                                profileBloc.outProjectsChurchValue == null) {
                            } else {
                              navigator.push(
                                MaterialPageRoute(
                                  builder: (context) => Scaffold(
                                    body: ProfileProjectPage(
                                      myChurch: myChurch,
                                      user: snapshot.data[index].user,
                                      type:
                                          getType(snapshot.data[index].user.id),
                                    ),
                                  ),
                                ),
                              );
                            }
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
                                    child: snapshot.data[index].user.information
                                                .photo1 !=
                                            null
                                        ? Image.network(snapshot.data[index]
                                            .user.information.photo1)
                                        : Image(
                                            image: AssetImage(
                                                'assets/images/projeto.jpg'),
                                            width: 200.0,
                                            height: 300,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 70,
                                  left: 40,
                                  child: snapshot.data[index].user.information
                                              .photoProfile !=
                                          null
                                      ? CircleAvatar(
                                          radius: 70,
                                          child: Image.network(snapshot
                                              .data[index]
                                              .user
                                              .information
                                              .photoProfile),
                                        )
                                      : CircleAvatar(
                                          radius: 70,
                                          backgroundImage: AssetImage(
                                              'assets/images/avatar.png'),
                                        )),
                              Positioned(
                                bottom: 50,
                                left: 30,
                                child: Text(
                                  category == 'project'
                                      ? snapshot.data[index].name
                                      : snapshot.data[index].fullName,
                                  textAlign: TextAlign.center,
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
    );
  }

  getType(id) {
    return id == myId ? 'me' : 'other';
  }
}
