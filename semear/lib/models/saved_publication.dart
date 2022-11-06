import 'package:semear/models/publication_model.dart';
import 'package:semear/models/user_model.dart';

class SavedPublication {
  int? id;
  String? createdAt;
  Publication? publication;
  User? user;

  SavedPublication({this.id, this.createdAt, this.publication, this.user});

  SavedPublication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    publication = json['publication'] != null
        ? Publication.fromJson(json['publication'])
        : null;
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    if (publication != null) {
      data['publication'] = publication!.toJson();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
