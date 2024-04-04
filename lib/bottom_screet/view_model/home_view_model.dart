import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matrimony/bottom_screet/view_model/global_value_model.dart';
import 'package:matrimony/webservices/WebServicesClient.dart';
import 'package:matrimony/webservices/Webservices.dart';

class HomeViewModel {
  List<GlobalValueModel> alGlobalResponse = [];
  List<IncomeList> alIncomeResponse = [];

  Future<String> getGlobalListApi() {
    Completer<String> completer = Completer();


    WebServiceClient.getStatsAPICall(Webservices.globalValue).then((response) {
      var jsonResponse = jsonDecode(response);
      print("jsonResponseCode====>${jsonResponse['code']}");

        if (response != "") {
          alGlobalResponse.clear();
          print("RESPONSE###${response}");
          var jsonList = jsonDecode(response);
          final localPickData = GlobalValueModel.fromJson(jsonList);

          for (var prod in localPickData.data?.ageList ?? []) {
            alGlobalResponse.add(prod);
          }
        }

        completer.complete(response);

    }).catchError((error) {
      completer.completeError("Failed");
    });
    return completer.future;
  }
}