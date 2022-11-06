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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['photo_profile'] = photoProfile;
    data['resume'] = resume;
    data['site'] = site;
    data['whoAreUs'] = whoAreUs;
    data['ourObjective'] = ourObjective;
    data['photo1'] = photo1;
    data['photo2'] = photo2;
    return data;
  }
}
