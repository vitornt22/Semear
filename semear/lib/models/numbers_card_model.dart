class NumbersCard {
  int? donations;
  int? projects;
  int? missionaries;

  NumbersCard({this.donations, this.projects, this.missionaries});

  NumbersCard.fromJson(Map<String, dynamic> json) {
    donations = json['donations'];
    projects = json['projects'];
    missionaries = json['missionaries'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donations'] = donations;
    data['projects'] = projects;
    data['missionaries'] = missionaries;
    return data;
  }
}
