class GlobalValueModel {
  bool? status;
  String? message;
  GlobalData? data;
  String? error;

  GlobalValueModel({this.status, this.message, this.data, this.error});

  GlobalValueModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new GlobalData.fromJson(json['data']) : null;
    error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['error'] = this.error;
    return data;
  }
}

class GlobalData {
  IncomeList? incomeList;
  HeightList? heightList;
  DietList? dietList;
  List<String>? bodytypeList;
  List<String>? complexionList;
  ReligionList? religionList;
  LanguageList? languageList;
  FatherstatusList? fatherstatusList;
  FatherstatusList? motherstatusList;
  MaritalstatusList? maritalstatusList;
  GenderList? genderList;
  List<String>? ageList;
  BloodGroupList? bloodGroupList;

  GlobalData(
      {this.incomeList,
        this.heightList,
        this.dietList,
        this.bodytypeList,
        this.complexionList,
        this.religionList,
        this.languageList,
        this.fatherstatusList,
        this.motherstatusList,
        this.maritalstatusList,
        this.genderList,
        this.ageList,
        this.bloodGroupList});

  GlobalData.fromJson(Map<String, dynamic> json) {
    incomeList = json['income_list'] != null
        ? new IncomeList.fromJson(json['income_list'])
        : null;
    heightList = json['height_list'] != null
        ? new HeightList.fromJson(json['height_list'])
        : null;
    dietList = json['diet_list'] != null
        ? new DietList.fromJson(json['diet_list'])
        : null;
    bodytypeList = json['bodytype_list'].cast<String>();
    complexionList = json['complexion_list'].cast<String>();
    religionList = json['religion_list'] != null
        ? new ReligionList.fromJson(json['religion_list'])
        : null;
    languageList = json['language_list'] != null
        ? new LanguageList.fromJson(json['language_list'])
        : null;
    fatherstatusList = json['fatherstatus_list'] != null
        ? new FatherstatusList.fromJson(json['fatherstatus_list'])
        : null;
    motherstatusList = json['motherstatus_list'] != null
        ? new FatherstatusList.fromJson(json['motherstatus_list'])
        : null;
    maritalstatusList = json['maritalstatus_list'] != null
        ? new MaritalstatusList.fromJson(json['maritalstatus_list'])
        : null;
    genderList = json['gender_list'] != null
        ? new GenderList.fromJson(json['gender_list'])
        : null;
    ageList = json['age_list'].cast<String>();
    bloodGroupList = json['blood_group_list'] != null
        ? new BloodGroupList.fromJson(json['blood_group_list'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.incomeList != null) {
      data['income_list'] = this.incomeList!.toJson();
    }
    if (this.heightList != null) {
      data['height_list'] = this.heightList!.toJson();
    }
    if (this.dietList != null) {
      data['diet_list'] = this.dietList!.toJson();
    }
    data['bodytype_list'] = this.bodytypeList;
    data['complexion_list'] = this.complexionList;
    if (this.religionList != null) {
      data['religion_list'] = this.religionList!.toJson();
    }
    if (this.languageList != null) {
      data['language_list'] = this.languageList!.toJson();
    }
    if (this.fatherstatusList != null) {
      data['fatherstatus_list'] = this.fatherstatusList!.toJson();
    }
    if (this.motherstatusList != null) {
      data['motherstatus_list'] = this.motherstatusList!.toJson();
    }
    if (this.maritalstatusList != null) {
      data['maritalstatus_list'] = this.maritalstatusList!.toJson();
    }
    if (this.genderList != null) {
      data['gender_list'] = this.genderList!.toJson();
    }
    data['age_list'] = this.ageList;
    if (this.bloodGroupList != null) {
      data['blood_group_list'] = this.bloodGroupList!.toJson();
    }
    return data;
  }
}

class IncomeList {
  String? s00;
  String? s2000050000;
  String? s50000100000;
  String? s100000150000;
  String? s150000200000;
  String? s200000250000;
  String? s250000300000;
  String? s300000400000000;

  IncomeList(
      {this.s00,
        this.s2000050000,
        this.s50000100000,
        this.s100000150000,
        this.s150000200000,
        this.s200000250000,
        this.s250000300000,
        this.s300000400000000});

  IncomeList.fromJson(Map<String, dynamic> json) {
    s00 = json['0-0'];
    s2000050000 = json['20000-50000'];
    s50000100000 = json['50000-100000'];
    s100000150000 = json['100000-150000'];
    s150000200000 = json['150000-200000'];
    s200000250000 = json['200000-250000'];
    s250000300000 = json['250000-300000'];
    s300000400000000 = json['300000-400000000'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['0-0'] = this.s00;
    data['20000-50000'] = this.s2000050000;
    data['50000-100000'] = this.s50000100000;
    data['100000-150000'] = this.s100000150000;
    data['150000-200000'] = this.s150000200000;
    data['200000-250000'] = this.s200000250000;
    data['250000-300000'] = this.s250000300000;
    data['300000-400000000'] = this.s300000400000000;
    return data;
  }
}

class HeightList {
  String? s1;
  String? s2;
  String? s3;
  String? s4;
  String? s5;
  String? s6;
  String? s7;
  String? s8;
  String? s9;
  String? s10;
  String? s11;
  String? s12;
  String? s13;
  String? s14;
  String? s15;
  String? s16;
  String? s17;
  String? s18;
  String? s19;
  String? s20;
  String? s21;
  String? s22;
  String? s23;
  String? s24;
  String? s25;
  String? s26;
  String? s27;
  String? s28;
  String? s29;
  String? s30;
  String? s31;
  String? s32;

  HeightList(
      {this.s1,
        this.s2,
        this.s3,
        this.s4,
        this.s5,
        this.s6,
        this.s7,
        this.s8,
        this.s9,
        this.s10,
        this.s11,
        this.s12,
        this.s13,
        this.s14,
        this.s15,
        this.s16,
        this.s17,
        this.s18,
        this.s19,
        this.s20,
        this.s21,
        this.s22,
        this.s23,
        this.s24,
        this.s25,
        this.s26,
        this.s27,
        this.s28,
        this.s29,
        this.s30,
        this.s31,
        this.s32});

  HeightList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
    s6 = json['6'];
    s7 = json['7'];
    s8 = json['8'];
    s9 = json['9'];
    s10 = json['10'];
    s11 = json['11'];
    s12 = json['12'];
    s13 = json['13'];
    s14 = json['14'];
    s15 = json['15'];
    s16 = json['16'];
    s17 = json['17'];
    s18 = json['18'];
    s19 = json['19'];
    s20 = json['20'];
    s21 = json['21'];
    s22 = json['22'];
    s23 = json['23'];
    s24 = json['24'];
    s25 = json['25'];
    s26 = json['26'];
    s27 = json['27'];
    s28 = json['28'];
    s29 = json['29'];
    s30 = json['30'];
    s31 = json['31'];
    s32 = json['32'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    data['6'] = this.s6;
    data['7'] = this.s7;
    data['8'] = this.s8;
    data['9'] = this.s9;
    data['10'] = this.s10;
    data['11'] = this.s11;
    data['12'] = this.s12;
    data['13'] = this.s13;
    data['14'] = this.s14;
    data['15'] = this.s15;
    data['16'] = this.s16;
    data['17'] = this.s17;
    data['18'] = this.s18;
    data['19'] = this.s19;
    data['20'] = this.s20;
    data['21'] = this.s21;
    data['22'] = this.s22;
    data['23'] = this.s23;
    data['24'] = this.s24;
    data['25'] = this.s25;
    data['26'] = this.s26;
    data['27'] = this.s27;
    data['28'] = this.s28;
    data['29'] = this.s29;
    data['30'] = this.s30;
    data['31'] = this.s31;
    data['32'] = this.s32;
    return data;
  }
}

class DietList {
  String? s1;
  String? s2;
  String? s3;

  DietList({this.s1, this.s2, this.s3});

  DietList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    return data;
  }
}

class ReligionList {
  String? s1;
  String? s2;
  String? s3;
  String? s4;

  ReligionList({this.s1, this.s2, this.s3, this.s4});

  ReligionList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    return data;
  }
}

class LanguageList {
  String? s1;
  String? s2;
  String? s3;
  String? s4;
  String? s5;
  String? s6;
  String? s7;
  String? s8;
  String? s9;
  String? s10;
  String? s11;
  String? s12;
  String? s13;
  String? s14;
  String? s15;
  String? s16;

  LanguageList(
      {this.s1,
        this.s2,
        this.s3,
        this.s4,
        this.s5,
        this.s6,
        this.s7,
        this.s8,
        this.s9,
        this.s10,
        this.s11,
        this.s12,
        this.s13,
        this.s14,
        this.s15,
        this.s16});

  LanguageList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
    s6 = json['6'];
    s7 = json['7'];
    s8 = json['8'];
    s9 = json['9'];
    s10 = json['10'];
    s11 = json['11'];
    s12 = json['12'];
    s13 = json['13'];
    s14 = json['14'];
    s15 = json['15'];
    s16 = json['16'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    data['6'] = this.s6;
    data['7'] = this.s7;
    data['8'] = this.s8;
    data['9'] = this.s9;
    data['10'] = this.s10;
    data['11'] = this.s11;
    data['12'] = this.s12;
    data['13'] = this.s13;
    data['14'] = this.s14;
    data['15'] = this.s15;
    data['16'] = this.s16;
    return data;
  }
}

class FatherstatusList {
  String? s1;
  String? s2;
  String? s3;
  String? s4;
  String? s5;
  String? s6;
  String? s7;
  String? s8;
  String? s9;

  FatherstatusList(
      {this.s1,
        this.s2,
        this.s3,
        this.s4,
        this.s5,
        this.s6,
        this.s7,
        this.s8,
        this.s9});

  FatherstatusList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
    s6 = json['6'];
    s7 = json['7'];
    s8 = json['8'];
    s9 = json['9'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    data['6'] = this.s6;
    data['7'] = this.s7;
    data['8'] = this.s8;
    data['9'] = this.s9;
    return data;
  }
}

class MaritalstatusList {
  String? s1;
  String? s2;
  String? s3;
  String? s4;
  String? s5;

  MaritalstatusList({this.s1, this.s2, this.s3, this.s4, this.s5});

  MaritalstatusList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    return data;
  }
}

class GenderList {
  String? s1;
  String? s2;

  GenderList({this.s1, this.s2});

  GenderList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    return data;
  }
}

class BloodGroupList {
  String? s1;
  String? s2;
  String? s3;
  String? s4;
  String? s5;
  String? s6;
  String? s7;
  String? s8;

  BloodGroupList(
      {this.s1, this.s2, this.s3, this.s4, this.s5, this.s6, this.s7, this.s8});

  BloodGroupList.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
    s6 = json['6'];
    s7 = json['7'];
    s8 = json['8'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    data['6'] = this.s6;
    data['7'] = this.s7;
    data['8'] = this.s8;
    return data;
  }
}
