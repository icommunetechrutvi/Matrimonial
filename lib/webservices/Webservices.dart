import 'dart:io';

import 'package:matrimony/utils/Constant.dart';


class Webservices {
  bool? isLive = true;

  static const baseUrl = "https://matrimonial.icommunetech.com/public/";

  static const profileLogin="api/profile_login";

  static const globalValue="api/global_values";

  static const profileList="api/profile_list?";
  static const profileDetail="api/profile_detail/";

  static const addFavoriteApi="api/addFavoriteapi";
  static const removeFavoriteApi="api/removeFavoriteapi";


  static const profileEdit="api/profile_edit/";
  static const countryList="api/country_list";
  static const stateList="api/state_list/";
  static const educationList="api/education_list";
  static const occupationList="api/occupation_list";

  static const favoriteList="api/favorite_list";
  static const viewContacts="api/view_contacts";


  static const iViewProfile="api/iViewProfile";
  static const whoViewProfile="api/whoViewProfile";


  static const iViewContact="api/iViewContact";
  static const whoViewContact="api/whoViewContact";



  static defaultHeaders() {
    return {
      "authorization": Constant.accessToken ?? "",
      "Accept": "application/json",
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
    };
  }
}
