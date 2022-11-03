import 'package:semear/models/user_model.dart';

class Donation {
  int? id;
  User? user;
  User? donor;
  bool? isAnonymous;
  double? value;
  String? paymentForm;
  bool? valid;
  bool? recused;
  String? voucher;

  Donation(
      {this.id,
      this.user,
      this.donor,
      this.isAnonymous,
      this.value,
      this.paymentForm,
      this.valid,
      this.recused,
      this.voucher});

  Donation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    donor = json['donor'] != null ? User.fromJson(json['donor']) : null;
    isAnonymous = json['is_anonymous'];
    value = json['value'];
    paymentForm = json['payment_form'];
    valid = json['valid'];
    recused = json['recused'];
    voucher = json['voucher'];
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
    return data;
  }
}
