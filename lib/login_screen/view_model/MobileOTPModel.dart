class MobileOTPModelClass {
  bool? status;
  String? message;
  Profile? profile;

  MobileOTPModelClass({this.status, this.message, this.profile});

  MobileOTPModelClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    profile =
    json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    return data;
  }
}

class Profile {
  int? profileID;
  String? password;
  String? firstName;
  String? lastName;
  int? gender;
  String? emailId;
  String? dateOfBirth;
  String? address1;
  int? countryId;
  String? state;
  String? city;
  String? mobileNo;
  int? educationId;
  int? height;
  int? religionId;
  int? professionId;
  int? noOfBrothers;
  int? noOfSisters;
  String? aboutMyFamily;
  String? contactPerson;
  int? isActive;
  int? paidStatus;
  int? photoAvailable;
  int? completed;
  int? isDelete;
  String? updatedAt;
  String? createdAt;
  int? id;

  Profile(
      {this.profileID,
        this.password,
        this.firstName,
        this.lastName,
        this.gender,
        this.emailId,
        this.dateOfBirth,
        this.address1,
        this.countryId,
        this.state,
        this.city,
        this.mobileNo,
        this.educationId,
        this.height,
        this.religionId,
        this.professionId,
        this.noOfBrothers,
        this.noOfSisters,
        this.aboutMyFamily,
        this.contactPerson,
        this.isActive,
        this.paidStatus,
        this.photoAvailable,
        this.completed,
        this.isDelete,
        this.updatedAt,
        this.createdAt,
        this.id});

  Profile.fromJson(Map<String, dynamic> json) {
    profileID = json['profileID'];
    password = json['password'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    emailId = json['email_id'];
    dateOfBirth = json['date_of_birth'];
    address1 = json['address1'];
    countryId = json['country_id'];
    state = json['state'];
    city = json['city'];
    mobileNo = json['mobile_no'];
    educationId = json['education_id'];
    height = json['height'];
    religionId = json['religion_id'];
    professionId = json['profession_id'];
    noOfBrothers = json['no_of_brothers'];
    noOfSisters = json['no_of_sisters'];
    aboutMyFamily = json['about_my_family'];
    contactPerson = json['contact_person'];
    isActive = json['is_active'];
    paidStatus = json['paid_status'];
    photoAvailable = json['photo_available'];
    completed = json['completed'];
    isDelete = json['is_delete'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profileID'] = this.profileID;
    data['password'] = this.password;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['email_id'] = this.emailId;
    data['date_of_birth'] = this.dateOfBirth;
    data['address1'] = this.address1;
    data['country_id'] = this.countryId;
    data['state'] = this.state;
    data['city'] = this.city;
    data['mobile_no'] = this.mobileNo;
    data['education_id'] = this.educationId;
    data['height'] = this.height;
    data['religion_id'] = this.religionId;
    data['profession_id'] = this.professionId;
    data['no_of_brothers'] = this.noOfBrothers;
    data['no_of_sisters'] = this.noOfSisters;
    data['about_my_family'] = this.aboutMyFamily;
    data['contact_person'] = this.contactPerson;
    data['is_active'] = this.isActive;
    data['paid_status'] = this.paidStatus;
    data['photo_available'] = this.photoAvailable;
    data['completed'] = this.completed;
    data['is_delete'] = this.isDelete;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}
