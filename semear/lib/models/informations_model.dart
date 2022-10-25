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
    data['zip_code'] = zipCode;
    data['adress'] = adress;
    data['number'] = number;
    data['city'] = city;
    data['uf'] = uf;
    data['district'] = district;
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
  String? bankName;

  BankData(
      {this.holder,
      this.cnpj,
      this.bank,
      this.bankName,
      this.agency,
      this.digitAgency,
      this.account,
      this.digitAccount});

  BankData.fromJson(Map<String, dynamic> json) {
    holder = json['holder'];
    bankName = json['bankName'];
    cnpj = json['cnpj'];
    bank = json['bank'];
    agency = json['agency'];
    digitAgency = json['digitAgency'];
    account = json['account'];
    digitAccount = json['digitAccount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['holder'] = holder;
    data['bankName'] = bankName;
    data['cnpj'] = cnpj;
    data['bank'] = bank;
    data['agency'] = agency;
    data['digitAgency'] = digitAgency;
    data['account'] = account;
    data['digitAccount'] = digitAccount;
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
