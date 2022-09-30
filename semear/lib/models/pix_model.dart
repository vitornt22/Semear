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
