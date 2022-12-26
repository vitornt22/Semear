import 'package:semear/models/follower_model.dart';
import 'package:semear/models/user_model.dart';

class Donor {
  int? id;
  User? user;
  String? fullName;
  List<Follower>? following;

  Donor({this.user, this.fullName, this.following});

  Donor.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    fullName = json['fullName'];
    id = json['id'];
    if (json['following'] != null) {
      following = <Follower>[];
      json['following'].forEach((v) {
        following!.add(Follower.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['fullName'] = fullName;
    data['id'] = id;
    if (following != null) {
      data['following'] = following!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
