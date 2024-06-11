import 'dart:io';

import 'package:matrimony/utils/Constant.dart';

class Webservices {
  bool? isLive = true;

  static const baseUrl = "https://matrimonial.icommunetech.com/public/";

  static const profileLogin = "api/profile_login";
  static const logout = "api/logout";

  static const globalValue = "api/global_values";

  static const profileList = "api/profile_list?";
  static const profileDetail = "api/profile_detail/";


  static const notifications = "api/notifications";



  static const profileEdit = "api/profile_edit/";
  static const updateProfileImg = "api/update_profile_img";
  static const changePassword = "api/changePassword";

  static const countryList = "api/country_list";
  static const stateList = "api/state_list/";
  static const educationList = "api/education_list";
  static const occupationList = "api/occupation_list";

  static const addFavoriteApi = "api/addFavoriteapi";
  static const removeFavoriteApi = "api/removeFavoriteapi";

  static const addProfileBlockApi = "api/addProfileBlockapi";
  static const removeProfileBlockApi = "api/removeProfileBlockapi";


  static const favoriteList = "api/favorite_list";
  static const viewContacts = "api/view_contacts";
  static const blockList = "api/block_list";
  static const matchList = "api/match_list";

  static const iViewProfile = "api/iViewProfile";
  static const whoViewProfile = "api/whoViewProfile";

  static const iViewContact = "api/iViewContact";
  static const whoViewContact = "api/whoViewContact";


  static const connectionSentList = "api/connection_list";
  static const connectionReceived = "api/connection_received";

  static const addConnectionRequest = "api/addConnectionRequest";
  static const connectionStatusEdit = "api/connection_status_edit";


  static const latestProfilesList = "api/latestprofiles";

  static const imageUrl = "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/";



  static defaultHeaders() {
    return {
      "authorization": Constant.accessToken ?? "",
      "Accept": "application/json",
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
    };
  }
}
