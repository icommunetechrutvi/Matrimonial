class LoginModel {
  bool? status;
  String? message;
  String? accessToken;
  String? tokenType;
  int? expiresIn;
  Profiles? profiles;

  LoginModel(
      {this.status,
        this.message,
        this.accessToken,
        this.tokenType,
        this.expiresIn,
        this.profiles});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    profiles = json['profiles'] != null
        ? new Profiles.fromJson(json['profiles'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['access_token'] = this.accessToken;
    data['token_type'] = this.tokenType;
    data['expires_in'] = this.expiresIn;
    if (this.profiles != null) {
      data['profiles'] = this.profiles!.toJson();
    }
    return data;
  }
}

class Profiles {
  int? id;
  String? password;
  String? profileID;
  String? firstName;
  String? lastName;
  int? gender;
  String? createdBy;
  String? emailId;
  String? dateOfBirth;
  int? maritalStatus;
  String? address1;
  String? address2;
  int? countryId;
  String? state;
  String? city;
  String? countryCode;
  String? mobileNo;
  String? altPhone;
  String? havechildren;
  int? noOfChildren;
  int? educationId;
  int? incomeFrom;
  int? incomeTo;
  int? height;
  String? weight;
  int? diet;
  int? bodyType;
  int? bloodGroup;
  int? complexion;
  int? religionId;
  String? subcaste;
  int? professionId;
  String? zip;
  int? fathersStatus;
  int? mothersStatus;
  int? noOfBrothers;
  int? noOfSisters;
  String? nativePlace;
  String? aboutMyFamily;
  String? contactPerson;
  String? convenientTime;
  String? lastLoggedIn;
  int? isActive;
  int? paidStatus;
  int? photoAvailable;
  int? iBy;
  int? completed;
  String? rememberToken;
  int? isDelete;
  String? emailVerifiedAt;
  String? fcmToken;
  String? createdAt;
  String? updatedAt;
  String? imageName;

  Profiles(
      {this.id,
        this.password,
        this.profileID,
        this.firstName,
        this.lastName,
        this.gender,
        this.createdBy,
        this.emailId,
        this.dateOfBirth,
        this.maritalStatus,
        this.address1,
        this.address2,
        this.countryId,
        this.state,
        this.city,
        this.countryCode,
        this.mobileNo,
        this.altPhone,
        this.havechildren,
        this.noOfChildren,
        this.educationId,
        this.incomeFrom,
        this.incomeTo,
        this.height,
        this.weight,
        this.diet,
        this.bodyType,
        this.bloodGroup,
        this.complexion,
        this.religionId,
        this.subcaste,
        this.professionId,
        this.zip,
        this.fathersStatus,
        this.mothersStatus,
        this.noOfBrothers,
        this.noOfSisters,
        this.nativePlace,
        this.aboutMyFamily,
        this.contactPerson,
        this.convenientTime,
        this.lastLoggedIn,
        this.isActive,
        this.paidStatus,
        this.photoAvailable,
        this.iBy,
        this.completed,
        this.rememberToken,
        this.isDelete,
        this.emailVerifiedAt,
        this.fcmToken,
        this.createdAt,
        this.updatedAt,
        this.imageName});

  Profiles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    profileID = json['profileID'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    createdBy = json['created_by'];
    emailId = json['email_id'];
    dateOfBirth = json['date_of_birth'];
    maritalStatus = json['marital_status'];
    address1 = json['address1'];
    address2 = json['address2'];
    countryId = json['country_id'];
    state = json['state'];
    city = json['city'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
    altPhone = json['alt_phone'];
    havechildren = json['havechildren'];
    noOfChildren = json['no_of_children'];
    educationId = json['education_id'];
    incomeFrom = json['income_from'];
    incomeTo = json['income_to'];
    height = json['height'];
    weight = json['weight'];
    diet = json['diet'];
    bodyType = json['body_type'];
    bloodGroup = json['blood_group'];
    complexion = json['complexion'];
    religionId = json['religion_id'];
    subcaste = json['subcaste'];
    professionId = json['profession_id'];
    zip = json['zip'];
    fathersStatus = json['fathers_status'];
    mothersStatus = json['mothers_status'];
    noOfBrothers = json['no_of_brothers'];
    noOfSisters = json['no_of_sisters'];
    nativePlace = json['native_place'];
    aboutMyFamily = json['about_my_family'];
    contactPerson = json['contact_person'];
    convenientTime = json['convenient_time'];
    lastLoggedIn = json['last_logged_in'];
    isActive = json['is_active'];
    paidStatus = json['paid_status'];
    photoAvailable = json['photo_available'];
    iBy = json['i_by'];
    completed = json['completed'];
    rememberToken = json['remember_token'];
    isDelete = json['is_delete'];
    emailVerifiedAt = json['email_verified_at'];
    fcmToken = json['fcm_token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    imageName = json['image_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['profileID'] = this.profileID;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    data['created_by'] = this.createdBy;
    data['email_id'] = this.emailId;
    data['date_of_birth'] = this.dateOfBirth;
    data['marital_status'] = this.maritalStatus;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['country_id'] = this.countryId;
    data['state'] = this.state;
    data['city'] = this.city;
    data['country_code'] = this.countryCode;
    data['mobile_no'] = this.mobileNo;
    data['alt_phone'] = this.altPhone;
    data['havechildren'] = this.havechildren;
    data['no_of_children'] = this.noOfChildren;
    data['education_id'] = this.educationId;
    data['income_from'] = this.incomeFrom;
    data['income_to'] = this.incomeTo;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['diet'] = this.diet;
    data['body_type'] = this.bodyType;
    data['blood_group'] = this.bloodGroup;
    data['complexion'] = this.complexion;
    data['religion_id'] = this.religionId;
    data['subcaste'] = this.subcaste;
    data['profession_id'] = this.professionId;
    data['zip'] = this.zip;
    data['fathers_status'] = this.fathersStatus;
    data['mothers_status'] = this.mothersStatus;
    data['no_of_brothers'] = this.noOfBrothers;
    data['no_of_sisters'] = this.noOfSisters;
    data['native_place'] = this.nativePlace;
    data['about_my_family'] = this.aboutMyFamily;
    data['contact_person'] = this.contactPerson;
    data['convenient_time'] = this.convenientTime;
    data['last_logged_in'] = this.lastLoggedIn;
    data['is_active'] = this.isActive;
    data['paid_status'] = this.paidStatus;
    data['photo_available'] = this.photoAvailable;
    data['i_by'] = this.iBy;
    data['completed'] = this.completed;
    data['remember_token'] = this.rememberToken;
    data['is_delete'] = this.isDelete;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['fcm_token'] = this.fcmToken;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['image_name'] = this.imageName;
    return data;
  }
}
