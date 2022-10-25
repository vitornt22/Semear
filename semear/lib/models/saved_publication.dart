class SavedPublication {
  int? id;
  String? createdAt;
  int? publication;
  int? user;

  SavedPublication({this.id, this.createdAt, this.publication, this.user});

  SavedPublication.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    publication = json['publication'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['created_at'] = createdAt;
    data['publication'] = publication;
    data['user'] = user;
    return data;
  }
}
