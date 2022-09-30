class Comment {
  int? id;
  String? comment;
  String? createdAt;
  String? updatedAt;
  int? user;
  int? publication;

  Comment(
      {this.id,
      this.comment,
      this.createdAt,
      this.updatedAt,
      this.user,
      this.publication});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'];
    publication = json['publication'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user'] = user;
    data['publication'] = publication;
    return data;
  }
}
