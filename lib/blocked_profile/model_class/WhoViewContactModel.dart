class WhoViewContactModel {
  List<WhoviewContact>? whoviewContact;

  WhoViewContactModel({this.whoviewContact});

  WhoViewContactModel.fromJson(Map<String, dynamic> json) {
    if (json['whoviewContact'] != null) {
      whoviewContact = <WhoviewContact>[];
      json['whoviewContact'].forEach((v) {
        whoviewContact!.add(new WhoviewContact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.whoviewContact != null) {
      data['whoviewContact'] =
          this.whoviewContact!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WhoviewContact {
  int? viewprofile;
  String? occupation;
  String? imageName;
  int? isDefault;
  String? firstName;
  int? id;
  String? city;
  String? state;
  String? lastName;
  String? dateOfBirth;
  int? incomeTo;
  int? incomeFrom;
  int? height;
  int? religionId;
  String? createdAt;
  String? updatedAt;
  int? age;

  WhoviewContact(
      {this.viewprofile,
        this.occupation,
        this.imageName,
        this.isDefault,
        this.firstName,
        this.id,
        this.city,
        this.state,
        this.lastName,
        this.dateOfBirth,
        this.incomeTo,
        this.incomeFrom,
        this.height,
        this.religionId,
        this.createdAt,
        this.updatedAt,
        this.age});

  WhoviewContact.fromJson(Map<String, dynamic> json) {
    viewprofile = json['viewprofile'];
    occupation = json['occupation'];
    imageName = json['image_name'];
    isDefault = json['is_default'];
    firstName = json['first_name'];
    id = json['id'];
    city = json['city'];
    state = json['state'];
    lastName = json['last_name'];
    dateOfBirth = json['date_of_birth'];
    incomeTo = json['income_to'];
    incomeFrom = json['income_from'];
    height = json['height'];
    religionId = json['religion_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['viewprofile'] = this.viewprofile;
    data['occupation'] = this.occupation;
    data['image_name'] = this.imageName;
    data['is_default'] = this.isDefault;
    data['first_name'] = this.firstName;
    data['id'] = this.id;
    data['city'] = this.city;
    data['state'] = this.state;
    data['last_name'] = this.lastName;
    data['date_of_birth'] = this.dateOfBirth;
    data['income_to'] = this.incomeTo;
    data['income_from'] = this.incomeFrom;
    data['height'] = this.height;
    data['religion_id'] = this.religionId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['age'] = this.age;
    return data;
  }
}
