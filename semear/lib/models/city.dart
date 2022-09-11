class City {
  int? id;
  String? nome;

  City({this.id, this.nome});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
  }
}
