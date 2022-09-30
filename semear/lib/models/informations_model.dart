class Adress {
  String? zipCode;
  String? adress;
  String? number;
  String? city;
  String? uf;
  String? district;

  Adress(
      {this.zipCode,
      this.adress,
      this.number,
      this.city,
      this.uf,
      this.district});

  Adress.fromJson(Map<String, dynamic> json) {
    zipCode = json['zip_code'];
    adress = json['adress'];
    number = json['number'];
    city = json['city'];
    uf = json['uf'];
    district = json['district'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zip_code'] = this.zipCode;
    data['adress'] = this.adress;
    data['number'] = this.number;
    data['city'] = this.city;
    data['uf'] = this.uf;
    data['district'] = this.district;
    return data;
  }
}

class BankData {
  String? holder;
  String? cnpj;
  String? bank;
  String? agency;
  String? digitAgency;
  String? account;
  String? digitAccount;

  BankData(
      {this.holder,
      this.cnpj,
      this.bank,
      this.agency,
      this.digitAgency,
      this.account,
      this.digitAccount});

  BankData.fromJson(Map<String, dynamic> json) {
    holder = json['holder'];
    cnpj = json['cnpj'];
    bank = json['bank'];
    agency = json['agency'];
    digitAgency = json['digitAgency'];
    account = json['account'];
    digitAccount = json['digitAccount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['holder'] = this.holder;
    data['cnpj'] = this.cnpj;
    data['bank'] = this.bank;
    data['agency'] = this.agency;
    data['digitAgency'] = this.digitAgency;
    data['account'] = this.account;
    data['digitAccount'] = this.digitAccount;
    return data;
  }
}

class Pix {
  int? id;
  String? typeKey;
  String? valueKey;

  Pix({this.id, this.typeKey, this.valueKey});

  Pix.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    typeKey = json['typeKey'];
    valueKey = json['valueKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['typeKey'] = typeKey;
    data['valueKey'] = valueKey;
    return data;
  }
}
