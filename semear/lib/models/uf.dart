class UF {
  int? id;
  String? sigla;
  String? nome;

  UF({this.id, this.sigla, this.nome});

  factory UF.fromJson(Map<String, dynamic> json) {
    return UF(
      id: json['id'],
      sigla: json['sigla'],
      nome: json['nome'],
    );
  }
}
