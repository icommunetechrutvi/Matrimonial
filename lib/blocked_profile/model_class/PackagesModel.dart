class PackagesModel {
  List<MainData>? plans;

  PackagesModel({this.plans});

  PackagesModel.fromJson(Map<String, dynamic> json) {
    if (json['plans'] != null) {
      plans = <MainData>[];
      json['plans'].forEach((v) {
        plans!.add(new MainData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MainData {
  int? id;
  String? plansName;
  String? plansPrice;
  String? plansDescription;
  Null? createdAt;
  String? updatedAt;
  String? connectionRequest;
  String? contactView;

  MainData(
      {this.id,
        this.plansName,
        this.plansPrice,
        this.plansDescription,
        this.createdAt,
        this.updatedAt,
        this.connectionRequest,
        this.contactView});

  MainData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plansName = json['plans_name'];
    plansPrice = json['plans_price'];
    plansDescription = json['plans_description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    connectionRequest = json['connection_request'];
    contactView = json['contact_view'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['plans_name'] = this.plansName;
    data['plans_price'] = this.plansPrice;
    data['plans_description'] = this.plansDescription;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['connection_request'] = this.connectionRequest;
    data['contact_view'] = this.contactView;
    return data;
  }
}
