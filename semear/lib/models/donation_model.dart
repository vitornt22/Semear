import 'package:semear/models/church_model.dart';
import 'package:semear/models/donor_model.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/user_model.dart';

getCategory(category, json) {
  switch (category) {
    case 'project':
      return Project.fromJson(json);
    case 'donor':
      return Donor.fromJson(json);
    case 'church':
      return Church.fromJson(json);
    case 'missionary':
      return Missionary.fromJson(json);

    default:
  }
}

class Donation {
  int? id;
  User? user;
  User? donor;
  var userData;
  var donorData;
  bool? isAnonymous;
  double? value;
  String? paymentForm;
  bool? valid;
  bool? recused;
  String? voucher;
  String? createdAt;
  String? updatedAt;

  Donation(
      {this.id,
      this.user,
      this.donor,
      this.userData,
      this.donorData,
      this.isAnonymous,
      this.value,
      this.paymentForm,
      this.valid,
      this.recused,
      this.voucher,
      this.createdAt,
      this.updatedAt});

  Donation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    donor = json['donor'] != null ? User.fromJson(json['donor']) : null;
    userData = json['userData'] != null
        ? getCategory(user!.category, json['userData'])
        : null;
    donorData = json['donorData'] != null
        ? getCategory(donor!.category, json['donorData'])
        : null;
    isAnonymous = json['is_anonymous'];
    value = json['value'];
    paymentForm = json['payment_form'];
    valid = json['valid'];
    recused = json['recused'];
    voucher = json['voucher'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (donor != null) {
      data['donor'] = donor!.toJson();
    }

    data['is_anonymous'] = isAnonymous;
    data['value'] = value;
    data['payment_form'] = paymentForm;
    data['valid'] = valid;
    data['recused'] = recused;
    data['voucher'] = voucher;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
