import 'package:semear/models/church_model.dart';
import 'package:semear/models/comment_model.dart';
import 'package:semear/models/donation_model.dart';
import 'package:semear/models/donor_model.dart';
import 'package:semear/models/likes_models.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/models/user_model.dart';

getCategory(category, json) {
  switch (category) {
    case 'project':
      return Project.fromJson(json);
    case 'donor':
      return Donor.fromJson(json);
    case 'church':
      return Church.fromJson(json);
    case 'missionary':
      return Missionary.fromJson(json);

    default:
  }
}

class NotificationModel {
  User? sender;
  User? receiver;
  Publication? publication;
  Donation? donation;
  Comment? comment;
  String? createdAt;
  Like? like;
  String? category;
  var senderData;
  var receiverData;

  NotificationModel(
      {this.sender,
      this.receiver,
      this.publication,
      this.donation,
      this.comment,
      this.createdAt,
      this.like,
      this.category,
      this.senderData,
      this.receiverData});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sender = json['sender'] != null ? User.fromJson(json['sender']) : null;
    receiver =
        json['receiver'] != null ? User.fromJson(json['receiver']) : null;
    publication = json['publication'] != null
        ? Publication.fromJson(json['publication'])
        : null;
    donation =
        json['donation'] != null ? Donation.fromJson(json['donation']) : null;
    comment =
        json['comment'] != null ? Comment.fromJson(json['comment']) : null;
    createdAt = json['created_at'];
    like = json['like'] != null ? Like.fromJson(json['like']) : null;
    category = json['category'];
    senderData = json['senderData'] != null
        ? getCategory(json['sender']['category'], json['senderData'])
        : null;
    receiverData = json['receiverData'] != null
        ? getCategory(json['receiver']['category'], json['receiverData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sender != null) {
      data['sender'] = sender!.toJson();
    }
    if (receiver != null) {
      data['receiver'] = receiver!.toJson();
    }
    if (publication != null) {
      data['publication'] = publication!.toJson();
    }
    if (donation != null) {
      data['donation'] = donation!.toJson();
    }
    if (comment != null) {
      data['comment'] = comment!.toJson();
    }
    data['created_at'] = createdAt;
    if (like != null) {
      data['like'] = like!.toJson();
    }
    data['category'] = category;
    if (senderData != null) {
      data['senderData'] = senderData!.toJson();
    }
    if (receiverData != null) {
      data['receiverData'] = receiverData!.toJson();
    }
    return data;
  }
}
