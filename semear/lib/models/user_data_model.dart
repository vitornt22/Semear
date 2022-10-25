import 'package:semear/models/church_model.dart';
import 'package:semear/models/information_model.dart';
import 'package:semear/models/informations_model.dart';
import 'package:semear/models/user_model.dart';

class UserData {
  int? id;
  Church? church;
  Adress? adress;
  Information? information;
  BankData? bankData;
  Pix? pix;
  String? cnpj;
  int? idChurch;
  int? idAdress;
  String? fullName;
  User? user;
  String? ministery;
  String? name;

  UserData(
      {this.id,
      this.church,
      this.adress,
      this.information,
      this.bankData,
      this.pix,
      this.cnpj,
      this.idChurch,
      this.idAdress,
      this.fullName,
      this.user,
      this.ministery,
      this.name});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    church = json['church'] != null ? Church.fromJson(json['church']) : null;
    adress = json['adress'] != null ? Adress.fromJson(json['adress']) : null;
    information = json['information'] != null
        ? Information.fromJson(json['information'])
        : null;
    bankData =
        json['bankData'] != null ? BankData.fromJson(json['bankData']) : null;
    pix = json['pix'] != null ? Pix.fromJson(json['pix']) : null;
    cnpj = json['cnpj'];
    idChurch = json['id_church'];
    idAdress = json['id_adress'];
    fullName = json['fullName'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;

    ministery = json['ministery'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (church != null) {
      data['church'] = church!.toJson();
    }
    if (adress != null) {
      data['adress'] = adress!.toJson();
    }
    if (information != null) {
      data['information'] = information!.toJson();
    }
    if (bankData != null) {
      data['bankData'] = bankData!.toJson();
    }
    if (pix != null) {
      data['pix'] = pix!.toJson();
    }
    data['cnpj'] = cnpj;
    data['id_church'] = idChurch;
    data['id_adress'] = idAdress;
    data['fullName'] = fullName;
    data['user'] = user;
    data['ministery'] = ministery;
    data['name'] = name;
    return data;
  }
}
