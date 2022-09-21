import 'package:semear/models/church_model.dart';
import 'package:semear/models/informations_model.dart';
import 'package:semear/models/user_model.dart';

class Project {
  int? id;
  User? user;
  Adress? adress;
  Church? church;
  int? idChurch;
  int? idAdress;
  String? name;

  Project(
      {this.id,
      this.user,
      this.adress,
      this.church,
      this.idChurch,
      this.idAdress,
      this.name});

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    adress = json['adress'] != null ? Adress.fromJson(json['adress']) : null;
    church = json['church'] != null ? Church.fromJson(json['church']) : null;
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
    data['id_church'] = idChurch;
    data['id_adress'] = idAdress;
    data['name'] = name;
    return data;
  }
}
