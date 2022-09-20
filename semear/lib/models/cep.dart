class Cep {
  String? cep;
  String? state;
  String? city;
  String? neighborhood;
  String? street;
  String? service;

  Cep(
      {this.cep,
      this.state,
      this.city,
      this.neighborhood,
      this.street,
      this.service});

  Cep.fromJson(Map<String, dynamic> json) {
    cep = json['cep'];
    state = json['state'];
    city = json['city'];
    neighborhood = json['neighborhood'];
    street = json['street'];
    service = json['service'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cep'] = cep;
    data['state'] = state;
    data['city'] = city;
    data['neighborhood'] = neighborhood;
    data['street'] = street;
    data['service'] = service;
    return data;
  }
}
