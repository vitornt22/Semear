import 'package:semear/models/comment_model.dart';
import 'package:semear/models/likes_models.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/user_model.dart';

class Publication {
  int? id;
  User? user;
  Project? project;
  Missionary? missionary;
  List<Like>? likes;
  List<Comment>? comments;
  int? idUser;
  String? upload;
  String? legend;
  String? createdAt;
  String? updatedAt;
  bool? isAccountability;

  Publication(
      {this.id,
      this.user,
      this.project,
      this.missionary,
      this.likes,
      this.comments,
      this.idUser,
      this.upload,
      this.legend,
      this.createdAt,
      this.updatedAt,
      this.isAccountability});

  Publication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    project =
        json['project'] != null ? Project.fromJson(json['project']) : null;
    missionary = json['missionary'] != null
        ? Missionary.fromJson(json['missionary'])
        : null;
    if (json['likes'] != null) {
      likes = <Like>[];
      json['likes'].forEach((v) {
        likes!.add(Like.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = <Comment>[];
      json['comments'].forEach((v) {
        comments!.add(Comment.fromJson(v));
      });
    }
    idUser = json['id_user'];
    upload = json['upload'];
    legend = json['legend'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isAccountability = json['is_accountability'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (project != null) {
      data['project'] = project!.toJson();
    }
    if (missionary != null) {
      data['missionary'] = missionary!.toJson();
    }
    if (likes != null) {
      data['likes'] = likes!.map((v) => v.toJson()).toList();
    }
    if (comments != null) {
      data['comments'] = comments!.map((v) => v.toJson()).toList();
    }
    data['id_user'] = idUser;
    data['upload'] = upload;
    data['legend'] = legend;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_accountability'] = isAccountability;
    return data;
  }
}
