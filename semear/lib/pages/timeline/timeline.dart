// ignore_for_file: use_full_hex_values_for_flutter_colors, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/notification_bloc.dart';
import 'package:semear/blocs/publications_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church_projects.dart';
import 'package:semear/pages/register/register_type.dart';
import 'package:semear/pages/timeline/publication.dart';
import 'package:semear/pages/timeline/post_container.dart';

import 'chat_page.dart';

class TimeLine extends StatefulWidget {
  TimeLine({super.key, required this.controller, required this.type});
  PageController controller;
  String type;

  @override
  State<TimeLine> createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  final _pubBloc = BlocProvider.getBloc<PublicationsBloc>();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final notificationBloc = BlocProvider.getBloc<NotificationBloc>();
  int? id;
  User? user;
  var categoryData;

  //
  @override
  void initState() {
    super.initState();
    _pubBloc.listPublications();
    id = userBloc.outMyIdValue;
    user = userBloc.outUserValue![id];
    if (user!.category != 'anonymous') {
      categoryData = userBloc.outCategoryValue![id];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffa23673A),
          leadingWidth: 230,
          leading: const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Image(
              image: AssetImage('assets/images/logo.png'),
            ),
          ),
          actions: [
            Visibility(
              visible:
                  user!.category != 'anonymous' && user!.category != 'donor',
              child: IconButton(
                  onPressed: () {},
                  icon: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => user!.category != 'church'
                                  ? PublicationPage(user: user!)
                                  : ChurchProjectsPage(user: user!)),
                        );
                      },
                      icon: Icon(Icons.add_a_photo))),
            ),
            const SizedBox(width: 15),
            Visibility(
              visible:
                  user!.category == 'project' || user!.category == 'missionary',
              child: Stack(children: [
                IconButton(
                  onPressed: () {
                    widget.controller.jumpToPage(1);
                  },
                  icon: const Icon(Icons.notifications),
                ),
                StreamBuilder<Map<int, int>>(
                    stream: notificationBloc.outNewNotifications,
                    initialData: notificationBloc.outNewNotificationsValue,
                    builder: (context, snapshot) {
                      return Visibility(
                        visible: snapshot.hasData &&
                            snapshot.data![id] != null &&
                            snapshot.data![id]! > 0,
                        child: CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 109, 214, 113),
                          child: Text('${snapshot.data![id]}'),
                        ),
                      );
                    })
              ]),
            ),
            const SizedBox(width: 15),
            IconButton(
                onPressed: () {
                  user!.category == 'anonymous'
                      ? showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                                'Para ter acesso ao chat é necessárip se registrar'),
                            content: Text('Deseja se Registrar?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Não'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterType()));
                                },
                                child: Text('Quero me registrar'),
                              )
                            ],
                          ),
                        )
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ChatPage();
                            },
                          ),
                        );
                },
                icon: const Icon(Icons.chat)),
            const SizedBox(width: 15),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            _pubBloc.disableButton.add(false);
            _pubBloc.listPublications();
          },
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: SizedBox(
              child: StreamBuilder<List<dynamic>>(
                  stream: _pubBloc.outPublications,
                  initialData: _pubBloc.outPublicationsValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        key: const PageStorageKey<String>('page'),
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            snapshot.data!.isEmpty ? 1 : snapshot.data!.length,
                        itemBuilder: (context, index) {
                          print("ENTROUI VITOR");
                          return snapshot.data!.isEmpty
                              ? noPublications()
                              : PostContainer(
                                  index: index,
                                  publication: snapshot.data![index],
                                  type: widget.type,
                                );
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  getNotifications() async {
    await notificationBloc.getNotification(id);
  }

  Widget noPublications() {
    _pubBloc.listPublications();
    return SizedBox(
      child: Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Não há publicações ainda',
              style: TextStyle(
                color: Color.fromARGB(255, 16, 101, 18),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
