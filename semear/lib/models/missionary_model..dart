import 'package:semear/models/user_model.dart';

class Missionary {
  User? user;
  bool? churchAddress;
  String? fullName;
  Null? idAdress;
  Null? church;
  Null? adress;

  Missionary(
      {this.user,
      this.churchAddress,
      this.fullName,
      this.idAdress,
      this.church,
      this.adress});

  Missionary.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    churchAddress = json['churchAddress'];
    fullName = json['fullName'];
    idAdress = json['id_adress'];
    church = json['church'];
    adress = json['adress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['churchAddress'] = this.churchAddress;
    data['fullName'] = this.fullName;
    data['id_adress'] = this.idAdress;
    data['church'] = this.church;
    data['adress'] = this.adress;
    return data;
  }
}
