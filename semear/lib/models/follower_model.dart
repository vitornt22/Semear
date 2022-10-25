import 'package:semear/models/user_data_model.dart';
import 'package:semear/models/user_model.dart';

class Follower {
  int? id;
  User? user;
  User? user2;
  Map<dynamic, dynamic>? userData;
  Map<dynamic, dynamic>? user2Data;
  String? createdAt;
  String? updatedAt;

  Follower(
      {this.id,
      this.user,
      this.user2,
      this.userData,
      this.user2Data,
      this.createdAt,
      this.updatedAt});

  Follower.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    user2 = json['user2'] != null ? User.fromJson(json['user2']) : null;
    userData = json['userData'] != null
        ? Map<String, dynamic>.from(json['userData'])
        : null;
    user2Data = json['user2Data'] != null
        ? Map<String, dynamic>.from(json['user2Data'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (user2 != null) {
      data['user2'] = user2!.toJson();
    }

    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
