import 'package:semear/models/informations_model.dart';
import 'package:semear/models/user_model.dart';

class Church {
  User? user;
  Adress? adress;
  BankData? bankData;
  Pix? pix;
  String? cnpj;
  String? ministery;
  String? name;

  Church(
      {this.user,
      this.adress,
      this.bankData,
      this.pix,
      this.cnpj,
      this.ministery,
      this.name});

  Church.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    adress =
        json['adress'] != null ? new Adress.fromJson(json['adress']) : null;
    bankData = json['bankData'] != null
        ? new BankData.fromJson(json['bankData'])
        : null;
    pix = json['pix'] != null ? new Pix.fromJson(json['pix']) : null;
    cnpj = json['cnpj'];
    ministery = json['ministery'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.adress != null) {
      data['adress'] = this.adress!.toJson();
    }
    if (this.bankData != null) {
      data['bankData'] = this.bankData!.toJson();
    }
    if (this.pix != null) {
      data['pix'] = this.pix!.toJson();
    }
    data['cnpj'] = this.cnpj;
    data['ministery'] = this.ministery;
    data['name'] = this.name;
    return data;
  }
}
