import 'package:semear/models/church_model.dart';
import 'package:semear/models/follower_model.dart';
import 'package:semear/models/information_model.dart';
import 'package:semear/models/informations_model.dart';
import 'package:semear/models/user_model.dart';

class Project {
  int? id;
  int? idUser;
  User? user;
  Adress? adress;
  Church? church;
  Information? information;
  List<Follower>? following;
  List<Follower>? followers;
  int? idChurch;
  int? idAdress;
  String? name;

  Project(
      {this.id,
      this.user,
      this.idUser,
      this.adress,
      this.church,
      this.information,
      this.following,
      this.followers,
      this.idChurch,
      this.idAdress,
      this.name});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['user'].runtimeType == int) {
      idUser = json['user'];
      user = null;
    } else {
      user = json['user'] != null ? User.fromJson(json['user']) : null;
    }
    adress = json['adress'] != null ? Adress.fromJson(json['adress']) : null;
    church = json['church'] != null ? Church.fromJson(json['church']) : null;
    information = json['information'] != null
        ? Information.fromJson(json['information'])
        : null;
    if (json['following'] != null) {
      following = <Follower>[];
      json['following'].forEach((v) {
        following!.add(Follower.fromJson(v));
      });
    }
    if (json['followers'] != null) {
      followers = <Follower>[];
      json['followers'].forEach((v) {
        followers!.add(Follower.fromJson(v));
      });
    }
    idChurch = json['id_church'];
    idAdress = json['id_adress'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (adress != null) {
      data['adress'] = adress!.toJson();
    }
    if (church != null) {
      data['church'] = church!.toJson();
    }
    if (information != null) {
      data['information'] = information!.toJson();
    }
    if (following != null) {
      data['following'] = following!.map((v) => v.toJson()).toList();
    }
    if (followers != null) {
      data['followers'] = followers!.map((v) => v.toJson()).toList();
    }
    data['id_church'] = idChurch;
    data['id_adress'] = idAdress;
    data['name'] = name;
    return data;
  }
}
