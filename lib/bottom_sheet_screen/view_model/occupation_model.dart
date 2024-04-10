class OccupationModel {
  bool? status;
  String? message;
  List<OccupationData>? data;
  String? error;

  OccupationModel({this.status, this.message, this.data, this.error});

  OccupationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OccupationData>[];
      json['data'].forEach((v) {
        data!.add(new OccupationData.fromJson(v));
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

class OccupationData {
  int? id;
  String? occupation;
  String? createdAt;
  String? updatedAt;

  OccupationData({this.id, this.occupation, this.createdAt, this.updatedAt});

  OccupationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    occupation = json['occupation'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['occupation'] = this.occupation;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
