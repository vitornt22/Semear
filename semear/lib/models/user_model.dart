class User {
  int? id;
  String? username;
  String? email;
  String? category;
  bool? canPost;
  String? password;

  User(
      {this.id,
      this.username,
      this.email,
      this.category,
      this.canPost,
      this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    category = json['category'];
    canPost = json['can_post'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['category'] = category;
    data['can_post'] = canPost;
    data['password'] = password;
    return data;
  }
}
