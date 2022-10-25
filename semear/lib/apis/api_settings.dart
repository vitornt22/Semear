import 'dart:convert';

import 'package:semear/models/user_model.dart';
import 'package:http/http.dart' as http;

class ApiSettings {
  Future<User?> setFollower(user1, user2) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/project/api/$user1/setFollower/$user2/"));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<User?> unFollow(user1, user2) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/project/api/$user1/unFollower/$user2/"));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool?> savePublication(user, publication) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/publication/api/$user/savePublication/$publication/"));

    return jsonDecode(response.body)['check'];
  }

  Future<bool?> unSavePublication(user, publication) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/publication/api/$user/unSavePublication/$publication/"));

    return jsonDecode(response.body)['check'];
  }

  Future<User?> getUser(id) async {
    http.Response response = await http
        .get(Uri.parse("https://backend-semear.herokuapp.com/user/api/$id/"));

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> getLabelFollower(user, user2) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/follower/api/$user/getLabelFollower/$user2/"));

    return jsonDecode(response.body)['label'];
  }

  Future<bool> getLabelPublicationSaved(user, publication) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/publication/api/$user/getLabelPublicationSaved/$publication/"));

    return jsonDecode(response.body)['label'];
  }
}
