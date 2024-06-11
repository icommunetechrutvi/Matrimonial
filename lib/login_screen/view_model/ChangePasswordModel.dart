class ChangePasswordModel {
  bool? status;
  String? message;
  // List<Null>? data;
  List<Error>? error;

  ChangePasswordModel({this.status, this.message,/* this.data, */this.error});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    // if (json['data'] != null) {
    //   data = <Null>[];
    //   json['data'].forEach((v) {
    //     data!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['error'] != null) {
      error = <Error>[];
      json['error'].forEach((v) {
        error!.add(new Error.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    // if (this.data != null) {
    //   data['data'] = this.data!.map((v) => v.toJson()).toList();
    // }
    if (this.error != null) {
      data['error'] = this.error!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Error {
  List<String>? oldPassword;
  List<String>? newPassword;
  List<String>? confirmPassword;

  Error({this.oldPassword, this.newPassword, this.confirmPassword});

  Error.fromJson(Map<String, dynamic> json) {
    oldPassword = json['old_password'].cast<String>();
    newPassword = json['new_password'].cast<String>();
    confirmPassword = json['confirm_password'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_password'] = this.oldPassword;
    data['new_password'] = this.newPassword;
    data['confirm_password'] = this.confirmPassword;
    return data;
  }
}
