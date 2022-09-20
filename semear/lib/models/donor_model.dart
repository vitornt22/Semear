import 'package:semear/models/user_model.dart';

class Donor {
  User? user;
  String? fullName;

  Donor({this.user, this.fullName});

  Donor.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['fullName'] = this.fullName;
    return data;
  }
}
