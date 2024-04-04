import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:matrimony/notificationservice/notification_model.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/appcolor.dart';
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
      DateTime timestamp = DateTime.parse("2024-04-04 04:00:00");
      String timeAgo = timeago.format(timestamp);
      print("timeAgo~~~${timeAgo}");
      // DateTime timestamp = DateTime.parse('2024-01-04 11:05:25');
      // print(formatTimeAgo(timestamp));
    });
  }

  String formatTimeAgo(DateTime dateTime) {
    Duration timeDifference = DateTime.now().difference(dateTime);

    if (timeDifference.inDays > 0) {
      return '${timeDifference.inDays}d ago';
    } else if (timeDifference.inHours > 0) {
      return '${timeDifference.inHours}h ago';
    } else if (timeDifference.inMinutes > 0) {
      return '${timeDifference.inMinutes}min ago';
    } else {
      return 'Just now';
    }
  }



  Future<void> profileViewApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('accessToken')?? "null";
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/notifications');

    final response = await http.get(url,headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {

        var jsonList = jsonDecode(response.body);
        print("jsonList$jsonList");
        final localPickData = NotificationsModel.fromJson(jsonList);
        print("notificationData-----${localPickData}");
        setState(() {
        _notificationData=localPickData.data ?? [];
        _isLoading=false;
        });
        print("_notificationData${_notificationData[0].createdAt}");


    } else {
      throw Exception('Failed to load notification_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 241, 241),
      appBar: AppBar(
        title: Text(
          "Notification List",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 248, 205, 206),
        elevation: 5,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: SideDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/bg_pink.jpg",
            fit: BoxFit.fill,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await Future.delayed(Duration(seconds: 1));
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child:_notificationData.isNotEmpty? ListView.builder(
                            itemCount: _notificationData.length,
                            itemBuilder: (context, index) {
                              final notification = _notificationData[index];
                              var type="";
                              if(notification.type=="viewed_profiles"){
                                type="Viewed your Profile ";
                              }else if(notification.type=="viewed_contacts"){
                                type="Viewed Contact ";
                              }else if(notification.type=="favorites"){
                                type="Added to Favorites  ";
                              }

                              return Container(
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(3),
                                child: GestureDetector(
                                  onTap: () {
                                    // Add your onTap functionality here
                                    // For example, you can navigate to another screen or perform any other action
                                    print('Card clicked');
                                  },
                                  child: Card(
                                    // color: AppColor.pink,
                                    // color: Color.fromARGB(255, 245, 245, 245),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 1,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child:
                                          Container(
                                            height: 67,
                                            width: 67,
                                            margin: EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle, // Change this to BoxShape.rectangle for square images
                                              border: Border.all( color: AppColor.mainAppColor,width: 3,),
                                            ),
                                            child: ClipOval(
                                              child:notification.imageName!.isNotEmpty? Image.network(
                                              "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/${notification.imageName}",
                                                fit: BoxFit.fill,
                                                // width: double.infinity,
                                                // height: double.infinity,
                                              ):Icon(Icons.notification_add),
                                            ),
                                          )
                                        ),
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "$type",
                                              ),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 16.0),
                                                  child: Text(
                                                    "${notification.createdAt}",
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
                          ) : Center(
                            child: Text("No notifications to display"),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
