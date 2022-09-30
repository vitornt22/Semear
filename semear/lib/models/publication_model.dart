import 'package:semear/models/comment_model.dart';
import 'package:semear/models/likes_models.dart';
import 'package:semear/models/project_model.dart';

class Publication {
  int? id;
  Project? project;
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
      this.project,
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
    project =
        json['project'] != null ? Project.fromJson(json['project']) : null;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    if (this.project != null) {
      data['project'] = this.project!.toJson();
    }
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    data['id_user'] = this.idUser;
    data['upload'] = this.upload;
    data['legend'] = this.legend;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_accountability'] = this.isAccountability;
    return data;
  }
}
