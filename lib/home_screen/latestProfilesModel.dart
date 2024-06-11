class LatestProfilesModel {
  bool? success;
  List<LatestData>? data;

  LatestProfilesModel({this.success, this.data});

  LatestProfilesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <LatestData>[];
      json['data'].forEach((v) {
        data!.add(new LatestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LatestData {
  int? id;
  String? password;
  String? profileID;
  String? firstName;
  String? lastName;
  int? gender;
  CreatedBy? createdBy;
  String? emailId;
  String? dateOfBirth;
  int? maritalStatus;
  String? address1;
  String? address2;
  CountryId? countryId;
  String? state;
  String? city;
  String? countryCode;
  String? mobileNo;
  String? altPhone;
  String? havechildren;
  int? noOfChildren;
  EducationId? educationId;
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
  ProfessionId? professionId;
  Null? zip;
  int? fathersStatus;
  int? mothersStatus;
  int? noOfBrothers;
  int? noOfSisters;
  String? nativePlace;
  String? aboutMyFamily;
  String? contactPerson;
  String? convenientTime;
  Null? lastLoggedIn;
  int? isActive;
  int? paidStatus;
  int? photoAvailable;
  int? iBy;
  int? completed;
  Null? rememberToken;
  int? isDelete;
  Null? emailVerifiedAt;
  String? fcmToken;
  Null? forgotVerificationCode;
  Null? customerId;
  String? createdAt;
  String? updatedAt;
  int? age;
  List<ProfileImages>? profileImages;

  LatestData(
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
        this.forgotVerificationCode,
        this.customerId,
        this.createdAt,
        this.updatedAt,
        this.age,
        this.profileImages});

  LatestData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    password = json['password'];
    profileID = json['profileID'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    gender = json['gender'];
    createdBy = json['created_by'] != null
        ? new CreatedBy.fromJson(json['created_by'])
        : null;
    emailId = json['email_id'];
    dateOfBirth = json['date_of_birth'];
    maritalStatus = json['marital_status'];
    address1 = json['address1'];
    address2 = json['address2'];
    countryId = json['country_id'] != null
        ? new CountryId.fromJson(json['country_id'])
        : null;
    state = json['state'];
    city = json['city'];
    countryCode = json['country_code'];
    mobileNo = json['mobile_no'];
    altPhone = json['alt_phone'];
    havechildren = json['havechildren'];
    noOfChildren = json['no_of_children'];
    educationId = json['education_id'] != null
        ? new EducationId.fromJson(json['education_id'])
        : null;
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
    professionId = json['profession_id'] != null
        ? new ProfessionId.fromJson(json['profession_id'])
        : null;
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
    forgotVerificationCode = json['forgot_verification_code'];
    customerId = json['customer_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    age = json['age'];
    if (json['profile_images'] != null) {
      profileImages = <ProfileImages>[];
      json['profile_images'].forEach((v) {
        profileImages!.add(new ProfileImages.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['password'] = this.password;
    data['profileID'] = this.profileID;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['gender'] = this.gender;
    if (this.createdBy != null) {
      data['created_by'] = this.createdBy!.toJson();
    }
    data['email_id'] = this.emailId;
    data['date_of_birth'] = this.dateOfBirth;
    data['marital_status'] = this.maritalStatus;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    if (this.countryId != null) {
      data['country_id'] = this.countryId!.toJson();
    }
    data['state'] = this.state;
    data['city'] = this.city;
    data['country_code'] = this.countryCode;
    data['mobile_no'] = this.mobileNo;
    data['alt_phone'] = this.altPhone;
    data['havechildren'] = this.havechildren;
    data['no_of_children'] = this.noOfChildren;
    if (this.educationId != null) {
      data['education_id'] = this.educationId!.toJson();
    }
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
    if (this.professionId != null) {
      data['profession_id'] = this.professionId!.toJson();
    }
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
    data['forgot_verification_code'] = this.forgotVerificationCode;
    data['customer_id'] = this.customerId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['age'] = this.age;
    if (this.profileImages != null) {
      data['profile_images'] =
          this.profileImages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CreatedBy {
  int? id;
  String? name;

  CreatedBy({this.id, this.name});

  CreatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class CountryId {
  int? id;
  String? countryName;

  CountryId({this.id, this.countryName});

  CountryId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    return data;
  }
}

class EducationId {
  int? id;
  String? education;

  EducationId({this.id, this.education});

  EducationId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    education = json['education'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['education'] = this.education;
    return data;
  }
}

class ProfessionId {
  int? id;
  String? occupation;

  ProfessionId({this.id, this.occupation});

  ProfessionId.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    occupation = json['occupation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['occupation'] = this.occupation;
    return data;
  }
}

class ProfileImages {
  int? id;
  int? profileId;
  String? imageName;
  int? isDefault;

  ProfileImages({this.id, this.profileId, this.imageName, this.isDefault});

  ProfileImages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profileId = json['profile_id'];
    imageName = json['image_name'];
    isDefault = json['is_default'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['profile_id'] = this.profileId;
    data['image_name'] = this.imageName;
    data['is_default'] = this.isDefault;
    return data;
  }
}
