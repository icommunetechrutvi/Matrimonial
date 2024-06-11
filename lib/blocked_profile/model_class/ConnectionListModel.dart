class ConnectionListModel {
  List<ConnectionData>? connection;

  ConnectionListModel({this.connection});

  ConnectionListModel.fromJson(Map<String, dynamic> json) {
    if (json['connection'] != null) {
      connection = <ConnectionData>[];
      json['connection'].forEach((v) {
        connection!.add(new ConnectionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.connection != null) {
      data['connection'] = this.connection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ConnectionData {
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
  String? status;
  String? profileCountry;
  String? education;
  int? connectionId;
  int? age;

  ConnectionData(
      {this.occupation,
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
        this.status,
        this.profileCountry,
        this.education,
        this.connectionId,
        this.age});

  ConnectionData.fromJson(Map<String, dynamic> json) {
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
    status = json['status'];
    profileCountry = json['profilecountry'];
    education = json['education'];
    connectionId = json['connection_id'];
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
    data['last_name'] = this.lastName;
    data['date_of_birth'] = this.dateOfBirth;
    data['income_to'] = this.incomeTo;
    data['income_from'] = this.incomeFrom;
    data['height'] = this.height;
    data['religion_id'] = this.religionId;
    data['status'] = this.status;
    data['profilecountry'] = this.profileCountry;
    data['education'] = this.education;
    data['connection_id'] = this.connectionId;
    data['age'] = this.age;
    return data;
  }
}
