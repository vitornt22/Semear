import 'package:semear/models/church_model.dart';
import 'package:semear/models/donor_model.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/models/user_model.dart';

getObject(data) {
  final category = data['user']['category'];
  switch (category) {
    case 'project':
      return Project.fromJson(data);
    case 'missionary':
      return Missionary.fromJson(data);
    case 'donor':
      return Donor.fromJson(data);
    case 'church':
      return Church.fromJson(data);
    default:
  }
}

class Comment {
  int? id;
  User? user;
  String? comment;
  String? createdAt;
  var userData;
  String? updatedAt;
  int? publication;

  Comment(
      {this.id,
      this.user,
      this.userData,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.publication});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    userData = json['userData'] != null ? getObject(json['userData']) : null;
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
    if (userData != null) {
      data['userData'] = userData!.toJson();
    }

    return data;
  }
}
