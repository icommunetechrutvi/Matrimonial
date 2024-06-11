import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/ViewedProfileModel.dart';
import 'package:matrimony/blocked_profile/model_class/WhoViewedProfile.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
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
  final _selectedColor = AppColor.white;
  List<ViewProfileData> alGetIViewedProfileList = [];
  List<WhoViewProfileData> alGetWhoViewedProfileList = [];

  bool _iViewedProfileLoaded = false;
  bool _whoViewedProfileLoaded = false;


  int _iViewedProfilePage = 1;
  int _whoViewedProfilePage = 1;
  bool _iViewedProfileHasMore = true;
  bool _whoViewedProfileHasMore = true;

  ScrollController _iViewedProfileScrollController = ScrollController();
  var profileImg ="";
  Map<String, dynamic>? heightList;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _tabController.addListener(_handleTabSelection);

    _iViewedProfileScrollController.addListener(_iViewedProfileScrollListener);



    iViewedProfileListApi();
    whoViewedProfileListApi();
    fetchGlobalValues();
    setState(() {});
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchGlobalValues() async {
    final response = await http.get(Uri.parse(
        '${Webservices.baseUrl+Webservices.globalValue}'));
    print("response~~${response}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Map<String, dynamic> heightMap = responseData['data']['height_list'];
      heightList = heightMap.map((key, value) => MapEntry(key, value.toString()));
    } else {
      throw Exception('Failed to load income options');
    }
  }
  void _iViewedProfileScrollListener() {
    if (_iViewedProfileScrollController.position.pixels ==
        _iViewedProfileScrollController.position.maxScrollExtent &&
        _iViewedProfileHasMore) {
      iViewedProfileListApi();
    }
  }

  Future<void> iViewedProfileListApi() async {
    const _limit=10;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    final userName  = prefs.getString(PrefKeys.KEYGENDER)!;
    if(userName =="2"){
      profileImg="https://rishtaforyou.com/storage/profiles/default1.png";
    }
    else{
      profileImg="https://rishtaforyou.com/storage/profiles/default2.png";
    }
    setState(() {
      _iViewedProfileLoaded = true;
    });
    final url = Uri.parse(
        '${Webservices.baseUrl + Webservices.iViewProfile}?_limit=$_limit&_page=$_iViewedProfilePage');
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
      _iViewedProfilePage++;

      if (jsonList.length < _limit) {
        _iViewedProfileHasMore = false;
      }

      alGetIViewedProfileList = localPickData.iviewprofile ?? [];
      setState(() {
        _iViewedProfileLoaded = false;
      });
    } else if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Token is Expire!! Please Login Again"),
        backgroundColor: AppColor.red,
      ));
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
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
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN)!;
    setState(() {
      _whoViewedProfileLoaded = true;
    });
    final url =
        Uri.parse('${Webservices.baseUrl + Webservices.whoViewProfile}');
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
  Future<bool> checkImageExists(String url) async {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
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
      body: DefaultTabController(
        length: 2,
        child: Stack(fit: StackFit.expand, children: [
          Container(color: AppColor.mainAppColor),
         /* Image.asset(
            "assets/images/bg_white.jpg",
            fit: BoxFit.fill,
          ),*/
          Column(
            children: <Widget>[
              Container(
                height: kToolbarHeight + 8.0,
                padding: const EdgeInsets.only(
                    top: 3.0, right: 2.0, left: 6.0, bottom: 3),
                decoration: BoxDecoration(
                  color: _selectedColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0)),
                ),
                child: TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      color: AppColor.mainAppColor),
                  labelColor:_selectedColor,
                  unselectedLabelColor: AppColor.mainAppColor,
                  controller: _tabController,
                  tabs: <Widget>[
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
                  children: <Widget>[
                      _iViewedProfileLoaded
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.lightGreen,
                            ),
                          )
                        : Container(
                            child: alGetIViewedProfileList.isEmpty
                                ? Container(
                                    child: Center(
                                      child: Text(
                                        "YOUR VIEWED PROFILE IS EMPTY",
                                        style: AppTheme.nameText(),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                              itemCount: alGetIViewedProfileList.length,
                              itemBuilder: (context, index) {
                                String? heightKey = alGetIViewedProfileList[index].height.toString();
                                String? heightValue = heightList?[heightKey??0];
                                DateTime timestamp = DateTime.parse(
                                    "${alGetIViewedProfileList[index].createdAt}");
                                String timeAgo = timeago.format(timestamp);
                                print("timeAgo~~~${timeAgo}");
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ProfileDetailScreen(
                                              profileId:
                                              alGetIViewedProfileList[index]
                                                  .id,
                                              profileFullName:
                                              "${alGetIViewedProfileList[index].firstName} ${alGetIViewedProfileList[index].lastName}",
                                            );
                                          },
                                        ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(3),
                                    // height: MediaQuery.of(context).size.height * 0.4,
                                    child: Card(
                                      color: Color.fromARGB(255, 245, 245, 245),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                            width: 3, color: Colors.transparent),
                                      ),
                                      elevation: 4,
                                      child:  Column(
                                        children: [
                                          Container(
                                            height: screenHeight * 0.3,
                                            // width: screenWidth / 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                            ),
                                            child: FutureBuilder<bool>(
                                              future: checkImageExists("${Webservices.imageUrl}${alGetIViewedProfileList[index].imageName ?? ""}"),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasError || !snapshot.data!) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(profileImg),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(16),
                                                        topRight: Radius.circular(16),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage("${Webservices.imageUrl}${alGetIViewedProfileList[index].imageName}"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(16),
                                                        topRight: Radius.circular(16),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child:  /*Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            TextSpan(
                                                              text: "${alGetIViewedProfileList[index].firstName}" +
                                                                  " ${alGetIViewedProfileList[index].lastName}",
                                                              style: AppTheme
                                                                  .tabNameText(),
                                                            ),
                                                            TextSpan(
                                                              text:
                                                              " Viewed on ${timeAgo}",
                                                              style: TextStyle(
                                                                  color: Colors.grey,
                                                                  fontFamily: FontName.poppinsRegular
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),*/

                                                        AutoSizeText(
                                                            maxLines: 2,
                                                            minFontSize: 6,
                                                            "${alGetIViewedProfileList[index].firstName ?? ""}"+" ${alGetIViewedProfileList[index].lastName ?? ""}",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: AppColor.mainText,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily:
                                                              FontName.poppinsRegular,
                                                            ),
                                                          ),
                                                    ),
                                                    AutoSizeText(
                                                      maxLines: 2,
                                                      minFontSize: 6,
                                                      "${alGetIViewedProfileList[index].age} Yrs, "+"${heightValue?? ""}",
                                                      // "21 Yrs, 5ft 11 in",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor.grey,
                                                        fontFamily:
                                                        FontName.poppinsRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.02),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${alGetIViewedProfileList[index].occupation ?? ""}"+" -${alGetIViewedProfileList[index].education?? ""}",
                                                      // "Software Professional - Graduate",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColor.grey,
                                                        fontFamily: FontName.poppinsRegular,
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      maxLines: 2,
                                                      minFontSize: 6,
                                                      " Viewed ${timeAgo}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily:
                                                        FontName.poppinsRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        maxLines: 2,
                                                        minFontSize: 6,
                                                        "${alGetIViewedProfileList[index].city ?? ""}"+", ${alGetIViewedProfileList[index].state?? ""}"+", ${alGetIViewedProfileList[index].profileCountry ?? ""}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColor.black,
                                                          fontFamily: FontName.poppinsRegular,
                                                        ),),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return ProfileDetailScreen(
                                                                  profileId:
                                                                  alGetIViewedProfileList[index]
                                                                      .id,
                                                                  profileFullName:
                                                                  "${alGetIViewedProfileList[index].firstName} ${alGetIViewedProfileList[index].lastName}",
                                                                );
                                                              },
                                                            ));
                                                      },
                                                      child: AutoSizeText(
                                                        "View Profile",
                                                        style: TextStyle(
                                                          color: AppColor.mainText,
                                                          fontFamily: FontName.poppinsRegular,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
                                String? heightKey = alGetWhoViewedProfileList[index].height.toString();
                                String? heightValue = heightList?[heightKey??0];
                                DateTime timestamp = DateTime.parse(
                                    "${alGetWhoViewedProfileList[index].createdAt}");
                                String timeAgo = timeago.format(timestamp);
                                print("timeAgo~~~${timeAgo}");
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ProfileDetailScreen(
                                              profileId:
                                              alGetWhoViewedProfileList[index]
                                                  .id,
                                              profileFullName:
                                              "${alGetWhoViewedProfileList[index].firstName} ${alGetWhoViewedProfileList[index].lastName}",
                                            );
                                          },
                                        ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(3),
                                    // height: MediaQuery.of(context).size.height * 0.4,
                                    child: Card(
                                      color: Color.fromARGB(255, 245, 245, 245),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        side: BorderSide(
                                            width: 3, color: Colors.transparent),
                                      ),
                                      elevation: 4,
                                      child:  Column(
                                        children: [
                                          Container(
                                            height: screenHeight * 0.3,
                                            // width: screenWidth / 0,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                            ),
                                            child: FutureBuilder<bool>(
                                              future: checkImageExists("${Webservices.imageUrl}${alGetWhoViewedProfileList[index].imageName ?? ""}"),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState == ConnectionState.waiting) {
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                } else if (snapshot.hasError || !snapshot.data!) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(profileImg),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(16),
                                                        topRight: Radius.circular(16),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage("${Webservices.imageUrl}${alGetWhoViewedProfileList[index].imageName}"),
                                                        fit: BoxFit.fill,
                                                      ),
                                                      borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(16),
                                                        topRight: Radius.circular(16),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        maxLines: 2,
                                                        minFontSize: 6,
                                                        "${alGetWhoViewedProfileList[index].firstName ?? ""}"+" ${alGetWhoViewedProfileList[index].lastName ?? ""}",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: AppColor.mainText,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily:
                                                          FontName.poppinsRegular,
                                                        ),
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      maxLines: 2,
                                                      minFontSize: 6,
                                                      "${alGetWhoViewedProfileList[index].age} Yrs, "+"${heightValue?? ""}",
                                                      // "21 Yrs, 5ft 11 in",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor.grey,
                                                        fontFamily:
                                                        FontName.poppinsRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                        0.02),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${alGetWhoViewedProfileList[index].occupation ?? ""}"+" -${alGetWhoViewedProfileList[index].education?? ""}",
                                                      // "Software Professional - Graduate",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: AppColor.grey,
                                                        fontFamily: FontName.poppinsRegular,
                                                      ),
                                                    ),
                                                    AutoSizeText(
                                                      maxLines: 2,
                                                      minFontSize: 6,
                                                      " Viewed ${timeAgo}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor.black,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily:
                                                        FontName.poppinsRegular,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: AutoSizeText(
                                                        maxLines: 2,
                                                        minFontSize: 6,
                                                        "${alGetWhoViewedProfileList[index].city ?? ""}"+", ${alGetWhoViewedProfileList[index].state?? ""}"+", ${alGetWhoViewedProfileList[index].profileCountry ?? ""}",
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: AppColor.black,
                                                          fontFamily: FontName.poppinsRegular,
                                                        ),),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                              builder: (context) {
                                                                return ProfileDetailScreen(
                                                                  profileId:
                                                                  alGetWhoViewedProfileList[index]
                                                                      .id,
                                                                  profileFullName:
                                                                  "${alGetWhoViewedProfileList[index].firstName} ${alGetWhoViewedProfileList[index].lastName}",
                                                                );
                                                              },
                                                            ));
                                                      },
                                                      child: AutoSizeText(
                                                        "View Profile",
                                                        style: TextStyle(
                                                          color: AppColor.mainText,
                                                          fontFamily: FontName.poppinsRegular,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
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
      ),
    );
  }
}
