class UF {
  int? id;
  String? sigla;
  String? name;

  UF({this.id, this.sigla, this.name});

  factory UF.fromJson(Map<String, dynamic> json) {
    return UF(
      id: json['id'],
      sigla: json['sigla'],
      name: json['nome'],
    );
  }
}
