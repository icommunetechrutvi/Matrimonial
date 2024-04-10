class EducationsModel {
  bool? status;
  String? message;
  List<EducationsData>? data;
  String? error;

  EducationsModel({this.status, this.message, this.data, this.error});

  EducationsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EducationsData>[];
      json['data'].forEach((v) {
        data!.add(new EducationsData.fromJson(v));
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

class EducationsData {
  int? id;
  String? education;
  String? createdAt;
  String? updatedAt;

  EducationsData({this.id, this.education, this.createdAt, this.updatedAt});

  EducationsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    education = json['education'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['education'] = this.education;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
