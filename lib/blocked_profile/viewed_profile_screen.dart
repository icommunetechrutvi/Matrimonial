import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/ViewedProfileModel.dart';
import 'package:matrimony/blocked_profile/model_class/WhoViewedProfile.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;



class ViewedProfileScreen extends StatefulWidget {
  ViewedProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewedProfileScreen> createState() => _MyViewedProfileScreenPageState();
}

class _MyViewedProfileScreenPageState extends State<ViewedProfileScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late final TabController _tabController;
  final _selectedColor = AppColor.bgColor;
  List<ViewProfileData> alGetIViewedProfileList = [];
  List<WhoViewProfileData> alGetWhoViewedProfileList = [];

  bool _iViewedProfileLoaded = false;
  bool _whoViewedProfileLoaded = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _tabController.addListener(_handleTabSelection);
    iViewedProfileListApi();
    whoViewedProfileListApi();
    setState(() {});
  }
/*
  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 0 && !_iViewedProfileLoaded) {
        iViewedProfileListApi();
        _iViewedProfileLoaded = true;
      } else if (_tabController.index == 1&& !_whoViewedProfileLoaded) {
        whoViewedProfileListApi();
        _whoViewedProfileLoaded = true;
      }
    }
  }*/

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> iViewedProfileListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('accessToken') ?? "null";
    setState(() {
      _iViewedProfileLoaded = true;
    });
    final url = Uri.parse('${Webservices.baseUrl+Webservices.iViewProfile}');
    print("url~~$url");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = ViewedProfileModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetIViewedProfileList = localPickData.iviewprofile ?? [];
      setState(() {
        _iViewedProfileLoaded = false;
      });
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Token is Expire!! Please Login Again"),
        backgroundColor: AppColor.red,
      ));
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ));
    } else {
      setState(() {
        _iViewedProfileLoaded = false;
      });
      print("alGetFavoriteList~~~${alGetIViewedProfileList.length}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Nothing Add to Favorite "),
        backgroundColor: AppColor.red,
      ));
      print("Nothing Data");
      throw Exception('Failed to load education_list');
    }
  }

  Future<void> whoViewedProfileListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('accessToken') ?? "null";
    setState(() {
      _whoViewedProfileLoaded = true;
    });
    final url = Uri.parse( '${Webservices.baseUrl+Webservices.whoViewProfile}');
    print("uel~~${url}");

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = WhoViewProfileModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetWhoViewedProfileList = localPickData.whoviewprofile ?? [];
      setState(() {
        _whoViewedProfileLoaded = false;
      });
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Token is Expire!! Please Login Again"),
        backgroundColor: AppColor.red,
      ));
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        },
      ));
    } else {
      setState(() {
        _whoViewedProfileLoaded = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Nothing Add to Favorite "),
        backgroundColor: AppColor.red,
      ));
      print("Nothing Data");
      throw Exception('Failed to load education_list');
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = screenHeight > screenWidth;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 255, 241, 241),
      // backgroundColor: Color.fromARGB(255, 255, 241, 241),
      appBar: CommonAppBar(
        text: "Viewed Profile",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: Stack(fit: StackFit.expand, children: [
        Image.asset(
          "assets/images/bg_white.jpg",
          fit: BoxFit.fill,
        ),
        Column(
          children: <Widget>[
            Container(
              height: kToolbarHeight + 8.0,
              padding:
              const EdgeInsets.only(top: 3.0, right: 2.0, left: 6.0,bottom: 3),
              decoration: BoxDecoration(
                color: _selectedColor,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
              ),
              child: TabBar(
                indicator: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        bottomLeft:  Radius.circular(5),
                    ),
                    color: Colors.white),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                controller: _tabController,
                tabs:  <Widget>[
                  Tab(
                    child: Text(
                      " I Viewed Profile",
                      style: AppTheme.tabText(),
                      // style: AppTheme.wishListView(),
                    ),
                  ),
                   Tab(
                    child: Text(
                      "Who Viewed My Profile",
                      style: AppTheme.tabText(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children:  <Widget>[
                  _iViewedProfileLoaded
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor.lightGreen,
                    ),
                  )
                      : Container(
                        child:alGetIViewedProfileList.isEmpty? Container(
                          child: Center(
                            child: Text(
                              "YOUR VIEWED CONTACT IS EMPTY",
                              style: AppTheme.nameText(),
                            ),
                          ),
                        ): ListView.builder(
                            itemCount: alGetIViewedProfileList.length,
                            itemBuilder: (context, index) {

                              DateTime timestamp = DateTime.parse(
                                  "${alGetIViewedProfileList[index].createdAt}");
                              String timeAgo = timeago.format(timestamp);
                              print("timeAgo~~~${timeAgo}");
                              return Container(
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(3),
                                // height: MediaQuery.of(context).size.height * 0.4,
                                child: Card(
                                  color: Color.fromARGB(255, 245, 245, 245),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                        width: 3, color: Colors.transparent),
                                  ),
                                  elevation: 7,
                                  // margin: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(12),
                                          height: isPortrait
                                              ? MediaQuery.of(context).size.height *  0.09
                                              : MediaQuery.of(context).size.height * 0.3,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/" +
                                                      "${alGetIViewedProfileList[index].imageName}"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "${alGetIViewedProfileList[index].firstName}" +
                                                        " ${alGetIViewedProfileList[index].lastName}",
                                                    style: AppTheme.tabNameText(),
                                                  ),
                                                   TextSpan(
                                                    text: " Viewed at ${timeAgo}",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            /*  Text(
                                              "${alGetIViewedProfileList[index].firstName}" +
                                                  " ${alGetIViewedProfileList[index].lastName}Viewed at" ,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),*/
                                            SizedBox(height: 7),
                                            Text(
                                              "${alGetIViewedProfileList[index].age}" +
                                                  " Yrs",
                                            ),
                                            SizedBox(height: 7),
                                            Text("${alGetIViewedProfileList[index].city}" +
                                                ",${alGetIViewedProfileList[index].state}"),
                                            SizedBox(height: 7),
                                            Text(
                                                "${alGetIViewedProfileList[index].occupation}"),
                                            SizedBox(height: 7),
                                            Text("${alGetIViewedProfileList[index].incomeFrom}" +
                                                " to ${alGetIViewedProfileList[index].incomeTo}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                            onTap: () async {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return ProfileDetailScreen(
                                                        profileId:
                                                        alGetIViewedProfileList[index]
                                                            .id,
                                                      );
                                                    },
                                                  ));
                                            },
                                            child: Column(
                                              children: const [
                                                Icon(
                                                  Icons.remove_red_eye_rounded,
                                                  color: Color.fromARGB(
                                                      255, 126, 143, 130),
                                                ),
                                                Text(
                                                  "view",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 126, 143, 130)),
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                        ),
                      ),
                  _whoViewedProfileLoaded
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor.lightGreen,
                    ),
                  )
                      : Container(
                        child: ListView.builder(
                            itemCount: alGetWhoViewedProfileList.length,
                            itemBuilder: (context, index) {
                              DateTime timestamp = DateTime.parse(
                                  "${alGetWhoViewedProfileList[index].createdAt}");
                              String timeAgo = timeago.format(timestamp);
                              print("timeAgo~~~${timeAgo}");
                              return Container(
                                padding: EdgeInsets.all(3),
                                margin: EdgeInsets.all(3),
                                // height: MediaQuery.of(context).size.height * 0.4,
                                child: Card(
                                  color: Color.fromARGB(255, 245, 245, 245),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                        width: 3, color: Colors.transparent),
                                  ),
                                  elevation: 7,
                                  // margin: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(12),
                                          height: isPortrait
                                              ? MediaQuery.of(context).size.height *  0.09
                                              : MediaQuery.of(context).size.height * 0.3,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/" +
                                                      "${alGetWhoViewedProfileList[index].imageName}"),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            // Text(
                                            //   "${alGetWhoViewedProfileList[index].firstName}" +
                                            //       " ${alGetWhoViewedProfileList[index].lastName}Viewed on",
                                            //   style: const TextStyle(
                                            //     fontSize: 20,
                                            //     color: Colors.black,
                                            //     fontWeight: FontWeight.bold,
                                            //   ),
                                            // ),
                                            Text.rich(
                                              TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "${alGetWhoViewedProfileList[index].firstName}" +
                                                        " ${alGetWhoViewedProfileList[index].lastName}",
                                                    style: AppTheme.tabNameText(),
                                                  ),
                                                   TextSpan(
                                                    text: " Viewed on ${timeAgo}",
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Text(
                                              "${alGetWhoViewedProfileList[index].age}" +
                                                  " Yrs",
                                            ),
                                            SizedBox(height: 7),
                                            Text("${alGetWhoViewedProfileList[index].city}" +
                                                ",${alGetWhoViewedProfileList[index].state}"),
                                            SizedBox(height: 7),
                                            Text(
                                                "${alGetWhoViewedProfileList[index].occupation}"),
                                            SizedBox(height: 7),
                                            Text("${alGetWhoViewedProfileList[index].incomeFrom}" +
                                                " to ${alGetWhoViewedProfileList[index].incomeTo}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                            onTap: () async {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return ProfileDetailScreen(
                                                        profileId:
                                                        alGetWhoViewedProfileList[index]
                                                            .id,
                                                      );
                                                    },
                                                  ));
                                            },
                                            child: Column(
                                              children: const [
                                                Icon(
                                                  Icons.remove_red_eye_rounded,
                                                  color: Color.fromARGB(
                                                      255, 126, 143, 130),
                                                ),
                                                Text(
                                                  "view",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 126, 143, 130)),
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                        ),
                      ),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
