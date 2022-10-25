import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:semear/models/comment_model.dart';
import 'package:semear/models/publication_model.dart';

class ApiPublication {
  Future<String> getCommentsNumber(id) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/publication/api/$id/getCommentsNumber/"));
    final number = jsonDecode(response.body)['number'].toString();

    return number;
  }

  Future<String> getLabel(user, publication) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/like/api/$user/isLiked/$publication/"));

    return jsonDecode(response.body)['label'];
  }

  Future<String> getLikesNumber(id) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/publication/api/$id/getLikesNumber/"));

    final number = jsonDecode(response.body)['number'].toString();
    print("THIS IS NUMBER $number");
    return number;
  }

  Future<Publication?> updatePublication(id) async {
    http.Response response = await http.get(
        Uri.parse("https://backend-semear.herokuapp.com/publication/api/$id/"));

    if (response.statusCode == 200) {
      return Publication.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<Publication?> setLike(user, publication) async {
    http.Response response = await http.post(
        Uri.parse("https://backend-semear.herokuapp.com/like/api/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"is_anonymous": false, "user": user, "publication": publication}));

    if (response.statusCode == 200) {
      return Publication.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<Publication?> deleteLike(user, publication) async {
    http.Response response = await http.get(
        Uri.parse(
            "https://backend-semear.herokuapp.com/like/api/$user/deleteLike/$publication/"),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return Publication.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<Publication?> deleteComment(id, publication) async {
    http.Response response = await http.delete(
        Uri.parse(
            "https://backend-semear.herokuapp.com/comment/api/$id/deleteComment/$publication/"),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return Publication.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  getComments(publication) async {
    http.Response response = await http.get(
        Uri.parse(
            "https://backend-semear.herokuapp.com/comment/api/$publication/getComments/"),
        headers: {"Content-Type": "application/json"});

    final lista = jsonDecode(response.body)
        .map((json) => Comment.fromJson(json))
        .toList();
    print("THIS IS LIST COMMENTS $lista");
    return lista;
  }

  Future<Publication?> submitCommment(comment, user, publication) async {
    http.Response response = await http.post(
        Uri.parse("https://backend-semear.herokuapp.com/comment/api/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"comment": comment, "user": user, "publication": publication}));

    if (response.statusCode == 200) {
      return Publication.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
