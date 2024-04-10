class StateModel {
  bool? status;
  String? message;
  List<StateData>? data;
  String? error;

  StateModel({this.status, this.message, this.data, this.error});

  StateModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <StateData>[];
      json['data'].forEach((v) {
        data!.add(new StateData.fromJson(v));
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

class StateData {
  int? stateid;
  String? state;
  int? countryId;
  int? isActive;
  String? createdAt;
  String? updatedAt;

  StateData(
      {this.stateid,
        this.state,
        this.countryId,
        this.isActive,
        this.createdAt,
        this.updatedAt});

  StateData.fromJson(Map<String, dynamic> json) {
    stateid = json['stateid'];
    state = json['state'];
    countryId = json['country_id'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stateid'] = this.stateid;
    data['state'] = this.state;
    data['country_id'] = this.countryId;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
