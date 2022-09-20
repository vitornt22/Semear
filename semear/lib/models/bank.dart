class Bank {
  String? ispb;
  String? nameBank;
  int? code;
  String? name;

  Bank({this.ispb, this.nameBank, this.code, this.name});

  Bank.fromJson(Map<String, dynamic> json) {
    ispb = json['ispb'];
    nameBank = json['name'];
    code = json['code'];
    name = json['fullName'];
  }
}
