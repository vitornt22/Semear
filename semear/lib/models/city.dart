class City {
  String? name;
  String? codigoIbge;

  City({this.name, this.codigoIbge});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['nome'],
      codigoIbge: json['codigo_ibge'],
    );
  }
}
