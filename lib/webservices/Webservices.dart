import 'dart:io';

import 'package:matrimony/utils/Constant.dart';

// import 'package:get/get.dart';
// import 'package:toa/utils/PrefUtils.dart';

// import '../utils/Constant.dart';

class Webservices {
  bool? isLive = true;

  static const baseUrl = "https://matrimonial.icommunetech.com/public/";
  static const globalValue="api/global_values";


  static defaultHeaders() {
    return {
      "authorization": Constant.accessToken ?? "",
      "Accept": "application/json",
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
    };
  }
}
