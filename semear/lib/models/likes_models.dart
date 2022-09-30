class Like {
  int? id;
  bool? isAnonymous;
  String? createdAt;
  String? updatedAt;
  int? user;
  int? publication;

  Like(
      {this.id,
      this.isAnonymous,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.publication});

  Like.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isAnonymous = json['is_anonymous'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'];
    publication = json['publication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['is_anonymous'] = isAnonymous;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user'] = user;
    data['publication'] = publication;
    return data;
  }
}
