import 'package:semear/models/information_model.dart';

class User {
  int? id;
  String? username;
  String? email;
  String? category;
  bool? canPost;
  Information? information;

  User(
      {this.id,
      this.username,
      this.email,
      this.category,
      this.canPost,
      this.information});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    category = json['category'];
    canPost = json['can_post'];
    information = json['information'] != null
        ? Information.fromJson(json['information'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['category'] = category;
    data['can_post'] = canPost;
    if (information != null) {
      data['information'] = information!.toJson();
    }
    return data;
  }
}
