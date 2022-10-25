import 'package:semear/models/user_model.dart';

class Comment {
  int? id;
  User? user;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? publication;

  Comment(
      {this.id,
      this.user,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.publication});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    publication = json['publication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['comment'] = comment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['publication'] = publication;
    return data;
  }
}
