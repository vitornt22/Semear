class Information {
  int? id;
  String? photoProfile;
  String? resume;
  String? site;
  String? whoAreUs;
  String? ourObjective;
  String? photo1;
  String? photo2;

  Information(
      {this.id,
      this.photoProfile,
      this.resume,
      this.site,
      this.whoAreUs,
      this.ourObjective,
      this.photo1,
      this.photo2});

  Information.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoProfile = json['photo_profile'];
    resume = json['resume'];
    site = json['site'];
    whoAreUs = json['whoAreUs'];
    ourObjective = json['ourObjective'];
    photo1 = json['photo1'];
    photo2 = json['photo2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photo_profile'] = this.photoProfile;
    data['resume'] = this.resume;
    data['site'] = this.site;
    data['whoAreUs'] = this.whoAreUs;
    data['ourObjective'] = this.ourObjective;
    data['photo1'] = this.photo1;
    data['photo2'] = this.photo2;
    return data;
  }
}
