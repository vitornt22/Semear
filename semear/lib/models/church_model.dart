import 'package:semear/models/follower_model.dart';
import 'package:semear/models/information_model.dart';
import 'package:semear/models/informations_model.dart';

import 'user_model.dart';

class Church {
  int? id;
  User? user;
  Adress? adress;
  BankData? bankData;
  Pix? pix;
  Information? information;
  List<Follower>? following;
  String? cnpj;
  String? ministery;
  String? name;

  Church(
      {this.id,
      this.user,
      this.adress,
      this.bankData,
      this.pix,
      this.information,
      this.following,
      this.cnpj,
      this.ministery,
      this.name});

  Church.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    adress = json['adress'] != null ? Adress.fromJson(json['adress']) : null;
    bankData =
        json['bankData'] != null ? BankData.fromJson(json['bankData']) : null;
    pix = json['pix'] != null ? Pix.fromJson(json['pix']) : null;
    information = json['information'] != null
        ? Information.fromJson(json['information'])
        : null;
    if (json['following'] != null) {
      following = <Follower>[];
      json['following'].forEach((v) {
        following!.add(Follower.fromJson(v));
      });
    }
    cnpj = json['cnpj'];
    ministery = json['ministery'];
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
    if (bankData != null) {
      data['bankData'] = bankData!.toJson();
    }
    if (pix != null) {
      data['pix'] = pix!.toJson();
    }
    if (information != null) {
      data['information'] = information!.toJson();
    }
    if (following != null) {
      data['following'] = following!.map((v) => v.toJson()).toList();
    }
    data['cnpj'] = cnpj;
    data['ministery'] = ministery;
    data['name'] = name;
    return data;
  }
}
