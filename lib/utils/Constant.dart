import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class Constant {
  static Color colorPrimary = const Color(0xff37474F);
  static Color secondaryColor = const Color(0xffF48112);

  static AuthUser? authUser;
  static String? accessToken;

  static int? chatUserIDS;

  static BuildContext? context;
  static bool isAlreadyLaunched = false;
  static final String chatPasswordFormat = "akzonobel_";
  static bool isCallAlreadyRunning = false;
  static int participantUserCount = 0;
  static bool isAlreadyOnlinePresenceAPICalled = false;
  static int notificationCount = 0;
  static const methodChannel =
      const MethodChannel('com.akzonobel/RequestPermission');

  static bool isChatScreenActive = false;
  static String dialogID = "";

  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  static int getIntFromMap(var json, String key) {
    if (json.containsKey(key)) {
      return json[key] as int;
    } else {
      return 0;
    }
  }

  static String getStringFromMap(var json, String key) {
    if (json.containsKey(key)) {
      return json[key] as String;
    } else {
      return "";
    }
  }

  // static String milliToDate(int milliseconds) {
  //   if (milliseconds == null) return "";
  //   var dt = DateTime.fromMillisecondsSinceEpoch(milliseconds);
  //   return Jiffy(dt).format("hh:mm, do MMM yyyy");
  // }
}

class AuthUser {
  String? access_token;
  String full_name = "";
  String phone = "";
  String profile_picture = "";
  String email = "";



  // logout() {
  //   PrefUtils.setBoolValue(PrefUtils.isLoggedIn, false);
  //   Constant.authUser = null;
  // }
}
