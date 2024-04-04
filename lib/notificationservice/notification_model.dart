class NotificationsModel {
  bool? status;
  String? message;
  List<NotificationData>? data;
  String? error;

  NotificationsModel({this.status, this.message, this.data, this.error});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
      });
    }
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['error'] = this.error;
    return data;
  }
}

class NotificationData {
  String? fullName;
  int? viewProfileId;
  String? imageName;
  int? isDefault;
  int? visitedProfileId;
  String? type;
  String? createdAt;
  String? updatedAt;
  int? id;
  int? profileId;

  NotificationData(
      {this.fullName,
        this.viewProfileId,
        this.imageName,
        this.isDefault,
        this.visitedProfileId,
        this.type,
        this.createdAt,
        this.updatedAt,
        this.id,
        this.profileId});

  NotificationData.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    viewProfileId = json['viewProfileId'];
    imageName = json['image_name'];
    isDefault = json['is_default'];
    visitedProfileId = json['visited_profile_id'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    id = json['id'];
    profileId = json['profile_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['full_name'] = this.fullName;
    data['viewProfileId'] = this.viewProfileId;
    data['image_name'] = this.imageName;
    data['is_default'] = this.isDefault;
    data['visited_profile_id'] = this.visitedProfileId;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['id'] = this.id;
    data['profile_id'] = this.profileId;
    return data;
  }
}
