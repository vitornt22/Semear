class User {
  String? username;
  String? email;
  String? category;
  bool? canPost;
  String? password;

  User({this.username, this.email, this.category, this.canPost, this.password});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    category = json['category'];
    canPost = json['can_post'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['category'] = this.category;
    data['can_post'] = this.canPost;
    data['password'] = this.password;
    return data;
  }
}
