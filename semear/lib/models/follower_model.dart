class Follower {
  int? id;
  String? createdAt;
  String? updatedAt;
  int? user;
  int? project;

  Follower({this.id, this.createdAt, this.updatedAt, this.user, this.project});

  Follower.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'];
    project = json['project'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user'] = user;
    data['project'] = project;
    return data;
  }
}
