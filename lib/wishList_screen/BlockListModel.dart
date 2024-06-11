class BlockListModel {
  List<Block>? block;

  BlockListModel({this.block});

  BlockListModel.fromJson(Map<String, dynamic> json) {
    if (json['block'] != null) {
      block = <Block>[];
      json['block'].forEach((v) {
        block!.add(new Block.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.block != null) {
      data['block'] = this.block!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Block {
  String? occupation;
  String? imageName;
  int? isDefault;
  String? firstName;
  int? id;
  String? city;
  String? state;
  String? profileCountry;
  String? lastName;
  String? education;
  String? dateOfBirth;
  int? incomeTo;
  int? incomeFrom;
  int? height;
  int? religionId;
  int? age;

  Block(
      {this.occupation,
        this.imageName,
        this.isDefault,
        this.firstName,
        this.id,
        this.city,
        this.state,
        this.profileCountry,
        this.lastName,
        this.education,
        this.dateOfBirth,
        this.incomeTo,
        this.incomeFrom,
        this.height,
        this.religionId,
        this.age});

  Block.fromJson(Map<String, dynamic> json) {
    occupation = json['occupation'];
    imageName = json['image_name'];
    isDefault = json['is_default'];
    firstName = json['first_name'];
    id = json['id'];
    city = json['city'];
    state = json['state'];
    profileCountry = json['profilecountry'];
    lastName = json['last_name'];
    education = json['education'];
    dateOfBirth = json['date_of_birth'];
    incomeTo = json['income_to'];
    incomeFrom = json['income_from'];
    height = json['height'];
    religionId = json['religion_id'];
    age = json['age'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['occupation'] = this.occupation;
    data['image_name'] = this.imageName;
    data['is_default'] = this.isDefault;
    data['first_name'] = this.firstName;
    data['id'] = this.id;
    data['city'] = this.city;
    data['state'] = this.state;
    data['profilecountry'] = this.profileCountry;
    data['last_name'] = this.lastName;
    data['education'] = this.education;
    data['date_of_birth'] = this.dateOfBirth;
    data['income_to'] = this.incomeTo;
    data['income_from'] = this.incomeFrom;
    data['height'] = this.height;
    data['religion_id'] = this.religionId;
    data['age'] = this.age;
    return data;
  }
}
