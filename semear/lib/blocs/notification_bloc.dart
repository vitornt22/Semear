import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:semear/models/notification_model.dart';

class NotificationBloc extends BlocBase {
  Map<int, int> listNewNotifications = {};

  Map<int, dynamic> listNotifications = {};
  final myNotificationController = BehaviorSubject<Map<int, dynamic>>();
  final newNotifications = BehaviorSubject<Map<int, int>>();

  Sink get inMyNotifications => myNotificationController.sink;
  Sink get inNewNotifications => newNotifications.sink;

  Stream<Map<int, dynamic>> get outMyNotifications =>
      myNotificationController.stream;
  Stream<Map<int, int>> get outNewNotifications => newNotifications.stream;

  Map<int, dynamic>? get outMyNotificationsValue =>
      myNotificationController.valueOrNull;

  Map<int, int>? get outNewNotificationsValue => newNotifications.valueOrNull;

  Future<List<dynamic>?> getNotification(id) async {
    var lista = [];
    final response = await http.get(
      Uri.parse(
          "https://backend-semear.herokuapp.com/notification/api/$id/getMyNotifications/"),
    );

    if (response.statusCode == 200) {
      print('ENRRANDO HERE');
      if (response.body == '{}') {
        lista = [];
      }
      lista = json
          .decode(response.body)
          .map((value) => NotificationModel.fromJson(value))
          .toList();
    }
    print('RETORNANDO NULL HERE');
    await addNotifications(id, lista);
    return lista;
  }

  addNotifications(id, list) async {
    list = list ?? [];
    listNotifications[id] = listNotifications[id] ?? [];
    if (list != listNotifications[id]) {
      listNotifications[id] = list;
      int diference =
          list.where((e) => !listNotifications[id].contains(e)).toList().length;
      ;
      listNewNotifications[id] = diference;
      newNotifications.add(listNewNotifications);
    }
    myNotificationController.add(listNotifications);
  }
}
