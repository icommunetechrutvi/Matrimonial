class ContactAddModel {
  bool? status;
  String? message;
  ContactAddData? data;
  String? error;

  ContactAddModel({this.status, this.message, this.data, this.error});

  ContactAddModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ContactAddData.fromJson(json['data']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class ContactAddData {
  int? profileId;
  String? viewedProfileId;
  String? updatedAt;
  String? createdAt;
  int? id;

  ContactAddData(
      {this.profileId,
        this.viewedProfileId,
        this.updatedAt,
        this.createdAt,
        this.id});

  ContactAddData.fromJson(Map<String, dynamic> json) {
    profileId = json['profile_id'];
    viewedProfileId = json['viewed_profile_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_id'] = this.profileId;
    data['viewed_profile_id'] = this.viewedProfileId;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
