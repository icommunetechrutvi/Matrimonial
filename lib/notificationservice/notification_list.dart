import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/notificationservice/notification_model.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class NotificationScreen extends StatefulWidget {
  NotificationScreen() : super();

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = false;
  List<NotificationData> _notificationData = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      profileViewApi();
    });
  }

  Future<void> profileViewApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        '${Webservices.baseUrl+ Webservices.notifications}');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });
    print("response for Notification${response.body}");
    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = NotificationsModel.fromJson(jsonList);
      print("notificationData-----${localPickData}");
      setState(() {
        _notificationData = localPickData.data ?? [];
        setState(() {
          _isLoading = false;
        });
      });
      print("_notificationData${_notificationData[0].createdAt}");
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load notification_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
     onWillPop: ()=> appCancel(context),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 241, 241),
        appBar: AppBar(
          title: Text(
            "Notification List",
            style: TextStyle(color: Colors.black,fontFamily: FontName.poppinsRegular),
          ),
          centerTitle: true,
          backgroundColor: AppColor.white,
          elevation: 5,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        drawer: SideDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: AppColor.mainAppColor,),
            // Image.asset(
            //   "assets/images/bg_pink.jpg",
            //   fit: BoxFit.fill,
            // ),
            SingleChildScrollView(
              child: Column(
                children: [
                  _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.mainText,
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: _notificationData.isNotEmpty
                              ? ListView.builder(
                                  itemCount: _notificationData.length,
                                  itemBuilder: (context, index) {
                                    final notification = _notificationData[index];
                                    var type = "";
                                    if (notification.type == "viewed_profiles") {
                                      type = "Viewed your Profile ";
                                    } else if (notification.type ==
                                        "viewed_contacts") {
                                      type = "Viewed Contact ";
                                    } else if (notification.type == "short_list") {
                                      type = "Added to Favorites  ";
                                    }else if (notification.type == "add_block_profiles") {
                                      type = "Add to Blocked List ";
                                    }

                                    DateTime timestamp = DateTime.parse(
                                        "${notification.createdAt}");
                                    String timeAgo = timeago.format(timestamp);
                                    print("timeAgo~~~${timeAgo}");

                                    return Container(
                                      padding: EdgeInsets.all(3),
                                      margin: EdgeInsets.all(3),
                                      child: GestureDetector(
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return ProfileDetailScreen(
                                                profileId:
                                                    _notificationData[index]
                                                        .profileId,
                                                profileFullName:
                                                "",
                                              );
                                            },
                                          ));
                                          print('Card clicked');
                                        },
                                        child: Card(
                                          // color: AppColor.pink,
                                          // color: Color.fromARGB(255, 245, 245, 245),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 1,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    height: 67,
                                                    width: 67,
                                                    margin: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      // Change this to BoxShape.rectangle for square images
                                                      border: Border.all(
                                                        color: AppColor.pinkLight,
                                                        width: 3,
                                                      ),
                                                    ),
                                                    child: ClipOval(
                                                        child: notification
                                                                .imageName.isNull
                                                            ? Image.asset(
                                                                "assets/profile_image/girl.png")
                                                            : Image.network(
                                                                "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/${notification.imageName}",
                                                                fit: BoxFit.fill,
                                                                // width: double.infinity,
                                                                // height: double.infinity,
                                                              )),
                                                  )),
                                              SizedBox(
                                                width: 3,
                                              ),
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${notification.fullName}",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Text(
                                                      "$type",
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                right: 16.0),
                                                        child: Text(
                                                          "${timeAgo}",
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.grey,
                                                          ),
                                                          // textAlign: TextAlign.right,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 1),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : const Center(
                                  child: Text(
                                      "No notifications to display & Token Expire Please Login Again"),
                                ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> appCancel(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Exit'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
