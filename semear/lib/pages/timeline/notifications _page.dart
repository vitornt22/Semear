// ignore_for_file: file_names, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import "package:flutter/material.dart";
import 'package:semear/blocs/notification_bloc.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church/church_profile_page.dart';
import 'package:semear/pages/profile/donor/donor_profile_page.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';

class NotificationsPage extends StatefulWidget {
  NotificationsPage({super.key, required this.user, this.controller});

  PageController? controller;
  User user;
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  final notificationBloc = BlocProvider.getBloc<NotificationBloc>();
  late int? id = widget.user.id;
  late User? myUser = userBloc.outUserValue![id];

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
                    if (widget.controller != null) {
                      widget.controller!.previousPage(
                          duration: const Duration(microseconds: 500),
                          curve: Curves.ease);
                    } else {
                      Navigator.pop(context);
                    }
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
            child: StreamBuilder<Map<int, dynamic>>(
                stream: notificationBloc.outMyNotifications,
                initialData: notificationBloc.outMyNotificationsValue,
                builder: (context, snapshot) {
                  getNotifications();
                  return snapshot.data![id] == null
                      ? Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        )
                      : ListView.separated(
                          key: const PageStorageKey<String>('page'),
                          itemCount: snapshot.data![id]!.isEmpty
                              ? 1
                              : snapshot.data![id]!.length,
                          separatorBuilder: (context, index) {
                            return const Divider();
                          },
                          itemBuilder: (context, index) {
                            if (snapshot.data![id]!.isNotEmpty) {
                              final data = snapshot.data![id]![index];
                              userBloc.addCategory(
                                  data.receiver.id, data.receiverData);
                              userBloc.addCategory(
                                  data.sender.id, data.senderData);
                              userBloc.addUser(data.sender);
                              userBloc.addUser(data.receiver);
                            }

                            return snapshot.data![id]!.isEmpty
                                ? noNotifications()
                                : getListTile(
                                    snapshot.data![id]![index], context);
                          },
                        );
                }),
          ),
        ),
      ],
    );
  }

  getType(data) {
    return userBloc.outMyIdValue == data.id ? 'me' : 'other';
  }

  bool getMyChurch(data) {
    if (myUser!.category == 'church') {
      return profileBloc.outProjectsChurchValue![id]!.contains(data.id);
    }
    return false;
  }

  getOnTap(data, context) {
    final category = data.category;
    return () {
      var object;
      switch (category) {
        case 'project':
          object = ProfileProjectPage(
              myChurch: getMyChurch(data), user: data, type: getType(data));
          break;
        case 'missionary':
          object = ProfileProjectPage(
              myChurch: false, user: data, type: getType(data));
          break;
        case 'donor':
          object = DonorProfilePage(user: data, type: getType(data));
          break;
        case 'church':
          object =
              ChurchProfilePage(first: false, user: data, type: getType(data));
          break;
        default:
          object = SizedBox();
      }
      if (object != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => object));
      }
    };
  }

  Widget gestureText(text, data, context) {
    return GestureDetector(
      onTap: getOnTap(data, context),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w600, color: Color.fromARGB(255, 7, 90, 10)),
      ),
    );
  }

  getImage(data, circle) {
    Widget a = data == null
        ? Image(
            image: AssetImage('assets/images/logo.jpg'),
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          )
        : Image.network(data);
    if (circle == true) {
      return CircleAvatar(
        child: a,
      );
    }
    return a;
  }

  likeOrCommentListTile(data, type) {
    return ListTile(
      title: Row(
        children: [
          gestureText('${data.sender.username}', data.sender, context),
          Text(type == 'like'
              ? 'Curtiu a sua publicação'
              : 'Commentou na sua publicação '),
        ],
      ),
      //  subtitle: Text('${data.created_at}'),
      trailing: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: getImage(data.publication.upload, false),
      ),
    );
  }

  followerOrDonationTile(data, type) {
    return ListTile(
        title: Row(
          children: [
            gestureText('${data.sender.username}', data.sender, context),
            Text(type == 'follower'
                ? '  Começou a seguir você'
                : 'Lhe fez uma doação'),
          ],
        ),
        trailing: getImage(data.sender.information!.photoProfile, true)
        //subtitle: Text('${data.created_at}'),
        );
  }

  getListTile(data, context) {
    final category = data.category;
    switch (category) {
      case 'like':
        return likeOrCommentListTile(data, 'like');

      case 'comment':
        return likeOrCommentListTile(data, 'comment');
      case 'donnation':
        return followerOrDonationTile(data, 'donnation');
      case 'follower':
        return followerOrDonationTile(data, 'follower');
      default:
    }
  }

  noNotifications() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Não há notificações',
            style: TextStyle(color: Color.fromARGB(255, 37, 126, 40)),
          )
        ],
      ),
    );
  }

  getNotifications() async {
    await notificationBloc.getNotification(id);
  }
}
