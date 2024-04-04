import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:matrimony/utils/Constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pref_keys.dart';
import 'preference.dart';

class SharedPreferenceHelper {
  final SharedPreference _sharedPreference = Get.find<SharedPreference>();

  // General Methods: ----------------------------------------------------------
  Future<void> saveAuthToken(String authToken) async {
    await _sharedPreference.setString(PrefKeys.authToken, authToken);
  }

  String? get authToken {
    return _sharedPreference.getString(PrefKeys.authToken);
  }

  Future<bool> removeAuthToken() async {
    return _sharedPreference.remove(PrefKeys.authToken);
  }

  Future<void> saveFCMToken(String fcmToken) async {
    await _sharedPreference.setString(PrefKeys.fcmToken, fcmToken);
  }

  String? get fcmToken {
    return _sharedPreference.getString(PrefKeys.fcmToken);
  }

  // Login:---------------------------------------------------------------------
  Future<void> saveIsLoggedIn(bool value) async {
    await _sharedPreference.setBool(PrefKeys.isLoggedIn, value);
  }

  bool get isLoggedIn {
    return _sharedPreference.getBool(PrefKeys.isLoggedIn) ?? false;
  }

  //
  Future<void> saveEmail(String email) async {
    await _sharedPreference.setString(PrefKeys.email, email);
  }

  String? get emailAddress {
    return _sharedPreference.getString(PrefKeys.email);
  }

  Future<void> savePassword(String password) async {
    await _sharedPreference.setString(PrefKeys.password, password);
  }

  String? get password {
    return _sharedPreference.getString(PrefKeys.password);
  }

  Future<void> saveRememberMe(bool isRememberMe) async {
    await _sharedPreference.setBool(PrefKeys.isRemembersMe, isRememberMe);
  }

  bool? get isRememberMe {
    return _sharedPreference.getBool(PrefKeys.isRemembersMe);
  }

  Future<void> savePermission(String permission) async {
    await _sharedPreference.setString(PrefKeys.tabpermissions, permission);
  }

  String? get tabPermission {
    return _sharedPreference.getString(PrefKeys.tabpermissions);
  }

  Future<void> saveUserID(String userID) async {
    await _sharedPreference.setString(PrefKeys.userID, userID);
  }

  String? get userID {
    return _sharedPreference.getString(PrefKeys.userID);
  }

/*
  static Future<void> getUserDataFromPref() async {
    var token = await getValueFor(PrefUtils.token);
    var fullName = await getValueFor(PrefUtils.fullName);
    var email = await getValueFor(PrefUtils.email);
    var phone = await getValueFor(PrefUtils.phone);

    var tokens = "";

    if (Constant.authUser != null) {
      if (token != null) tokens = Constant.authUser!.access_token ?? '';
      if (token != null && token != "") {
        tokens = Constant.authUser?.access_token ?? '';
      }
    }

    Constant.authUser = AuthUser();
    // Constant.authUser!.userId = userId;
    Constant.authUser!.full_name = fullName;
    Constant.authUser!.phone = phone;
    if (fullName != null && fullName != "")
      Constant.authUser!.full_name = fullName;
    if (phone != null && phone != "") Constant.authUser!.phone = phone;
    if (email != null && email != "") Constant.authUser!.email = email;
    // Constant.authUser!.profile_picture = profilePicture;

  }*/



  static setBoolValue(String key, bool defaultValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, defaultValue);
  }
  static const String isFirstTime = "com.akzonobel.isFirstTime";
  static const String isLoggedIns = "com.akzonobel.isLoggedIn";
}
