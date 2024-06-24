import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/ViewContactModel.dart';
import 'package:matrimony/blocked_profile/model_class/WhoViewContactModel.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class ViewedContactScreen extends StatefulWidget {
  ViewedContactScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewedContactScreen> createState() => _MyViewedContactScreenPageState();
}

class _MyViewedContactScreenPageState extends State<ViewedContactScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _iViewedContactLoaded = false;
  bool _whoViewedContactLoaded = false;

  late final TabController _tabController;
  final _selectedColor = AppColor.mainText;
  List<Iviewcontact> alGetIViewedContactList = [];
  List<WhoviewContact> alGetWhoViewedContactList = [];
  var profileImg = "";
  Map<String, dynamic>? heightList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    iViewedContactListApi();
    whoViewedContactListApi();
    fetchGlobalValues();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> fetchGlobalValues() async {
    final response = await http
        .get(Uri.parse('${Webservices.baseUrl + Webservices.globalValue}'));
    print("response~~${response}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Map<String, dynamic> heightMap =
          responseData['data']['height_list'];
      heightList =
          heightMap.map((key, value) => MapEntry(key, value.toString()));
    } else {
      throw Exception('Failed to load income options');
    }
  }

  Future<void> iViewedContactListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    final userName = prefs.getString(PrefKeys.KEYGENDER)!;
    if (userName == "2") {
      profileImg = "https://rishtaforyou.com/storage/profiles/default1.png";
    } else {
      profileImg = "https://rishtaforyou.com/storage/profiles/default2.png";
    }
    setState(() {
      _iViewedContactLoaded = true;
    });
    final url = Uri.parse('${Webservices.baseUrl + Webservices.iViewContact}');
    print("url~~$url");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = ViewContactModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetIViewedContactList = localPickData.iviewcontact ?? [];
      setState(() {
        _iViewedContactLoaded = false;
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
        _iViewedContactLoaded = false;
      });
      print("alGetFavoriteList~~~${alGetIViewedContactList.length}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("Nothing Add to Favorite "),
        backgroundColor: AppColor.red,
      ));
      print("Nothing Data");
      throw Exception('Failed to load education_list');
    }
  }

  Future<void> whoViewedContactListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    final userName = prefs.getString(PrefKeys.KEYGENDER)!;
    if (userName == "2") {
      profileImg = "https://rishtaforyou.com/storage/profiles/default1.png";
    } else {
      profileImg = "https://rishtaforyou.com/storage/profiles/default2.png";
    }
    setState(() {
      _whoViewedContactLoaded = true;
    });
    final url =
        Uri.parse('${Webservices.baseUrl + Webservices.whoViewContact}');
    print("uel~~${url}");

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = WhoViewContactModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetWhoViewedContactList = localPickData.whoviewContact ?? [];
      setState(() {
        _whoViewedContactLoaded = false;
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
        _whoViewedContactLoaded = false;
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
        text: "Viewed Contact",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: Stack(fit: StackFit.expand, children: [
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
                color: AppColor.white,
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
                labelColor: _selectedColor,
                unselectedLabelColor: AppColor.grey,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      " I Viewed Contact",
                      style: AppTheme.tabText(),
                      // style: AppTheme.wishListView(),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Who Viewed My Contact",
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
                  _iViewedContactLoaded
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.lightGreen,
                          ),
                        )
                      : Container(
                          child: alGetIViewedContactList.isEmpty
                              ? Container(
                                  child: Center(
                                    child: Text(
                                      "YOUR VIEWED CONTACT IS EMPTY",
                                      style: AppTheme.nameText(),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: alGetIViewedContactList.length,
                                  itemBuilder: (context, index) {
                                    String? heightKey =
                                        alGetIViewedContactList[index]
                                            .height
                                            .toString();
                                    String? heightValue =
                                        heightList?[heightKey ?? 0];
                                    DateTime timestamp = DateTime.parse(
                                        "${alGetIViewedContactList[index].createdAt}");
                                    String timeAgo = timeago.format(timestamp);
                                    print("timeAgo~~~${timeAgo}");
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return ProfileDetailScreen(
                                              profileId:
                                                  alGetIViewedContactList[index]
                                                      .id,
                                              profileFullName:
                                                  "${alGetIViewedContactList[index].firstName} ${alGetIViewedContactList[index].lastName}",
                                            );
                                          },
                                        ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.all(3),
                                        // height: MediaQuery.of(context).size.height * 0.4,
                                        child: Card(
                                          color: Color.fromARGB(
                                              255, 245, 245, 245),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
                                                width: 3,
                                                color: Colors.transparent),
                                          ),
                                          elevation: 4,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: screenHeight * 0.3,
                                                // width: screenWidth / 0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: FutureBuilder<bool>(
                                                  future: checkImageExists(
                                                      "${Webservices.imageUrl}${alGetIViewedContactList[index].imageName ?? ""}"),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else if (snapshot
                                                            .hasError ||
                                                        !snapshot.data!) {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                profileImg),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    16),
                                                            topRight:
                                                                Radius.circular(
                                                                    16),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                "${Webservices.imageUrl}${alGetIViewedContactList[index].imageName}"),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    16),
                                                            topRight:
                                                                Radius.circular(
                                                                    16),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            maxLines: 2,
                                                            minFontSize: 6,
                                                            "${alGetIViewedContactList[index].firstName ?? ""}" +
                                                                " ${alGetIViewedContactList[index].lastName ?? ""}",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: AppColor
                                                                  .mainText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily: FontName
                                                                  .poppinsRegular,
                                                            ),
                                                          ),
                                                          /* Text.rich(
                                                      TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: "${alGetIViewedContactList[index].firstName}" +
                                                                " ${alGetIViewedContactList[index].lastName}",
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

                                                          /* child: AutoSizeText(
                                                            maxLines: 2,
                                                            minFontSize: 6,
                                                            "${alGetWhoViewedContactList[index].firstName ?? ""}"+" ${alGetWhoViewedContactList[index].lastName ?? ""}",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: AppColor.mainText,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily:
                                                              FontName.poppinsRegular,
                                                            ),
                                                          ),*/
                                                        ),
                                                        AutoSizeText(
                                                          maxLines: 2,
                                                          minFontSize: 6,
                                                          "${alGetIViewedContactList[index].age} Yrs, " +
                                                              "${heightValue ?? ""}",
                                                          // "21 Yrs, 5ft 11 in",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: AppColor
                                                                .grey,
                                                            fontFamily: FontName
                                                                .poppinsRegular,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${alGetIViewedContactList[index].occupation ?? ""}" +
                                                              " -${alGetIViewedContactList[index].education ?? ""}",
                                                          // "Software Professional - Graduate",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: AppColor.grey,
                                                            fontFamily: FontName
                                                                .poppinsRegular,
                                                          ),
                                                        ),
                                                        AutoSizeText(
                                                          maxLines: 2,
                                                          minFontSize: 6,
                                                          " Viewed on ${timeAgo}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: AppColor
                                                                .black,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontFamily: FontName
                                                                .poppinsRegular,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            maxLines: 2,
                                                            minFontSize: 6,
                                                            "${alGetIViewedContactList[index].city ?? ""}" +
                                                                ", ${alGetIViewedContactList[index].state ?? ""}" +
                                                                ", ${alGetIViewedContactList[index].profileCountry ?? ""}",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: AppColor
                                                                  .black,
                                                              fontFamily: FontName
                                                                  .poppinsRegular,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return ProfileDetailScreen(
                                                                  profileId:
                                                                      alGetIViewedContactList[
                                                                              index]
                                                                          .id,
                                                                  profileFullName:
                                                                      "${alGetIViewedContactList[index].firstName} ${alGetIViewedContactList[index].lastName}",
                                                                );
                                                              },
                                                            ));
                                                          },
                                                          child: AutoSizeText(
                                                            "View Profile",
                                                            style: TextStyle(
                                                              color: AppColor
                                                                  .mainText,
                                                              fontFamily: FontName
                                                                  .poppinsRegular,
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
                  _whoViewedContactLoaded
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColor.lightGreen,
                          ),
                        )
                      : Container(
                          child: alGetWhoViewedContactList.isEmpty
                              ? Container(
                                  child: Center(
                                    child: Text(
                                      "YOUR VIEWED CONTACT IS EMPTY",
                                      style: AppTheme.nameText(),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: alGetWhoViewedContactList.length,
                                  itemBuilder: (context, index) {
                                    String? heightKey =
                                        alGetWhoViewedContactList[index]
                                            .height
                                            .toString();
                                    String? heightValue =
                                        heightList?[heightKey ?? 0];
                                    DateTime timestamp = DateTime.parse(
                                        "${alGetWhoViewedContactList[index].createdAt}");
                                    String timeAgo = timeago.format(timestamp);
                                    print("timeAgo~~~${timeAgo}");
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return ProfileDetailScreen(
                                              profileId:
                                                  alGetWhoViewedContactList[
                                                          index]
                                                      .id,
                                              profileFullName:
                                                  "${alGetWhoViewedContactList[index].firstName} ${alGetWhoViewedContactList[index].lastName}",
                                            );
                                          },
                                        ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        margin: EdgeInsets.all(3),
                                        // height: MediaQuery.of(context).size.height * 0.4,
                                        child: Card(
                                          color: Color.fromARGB(
                                              255, 245, 245, 245),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            side: BorderSide(
                                                width: 3,
                                                color: Colors.transparent),
                                          ),
                                          elevation: 4,
                                          child: Column(
                                            children: [
                                              Container(
                                                height: screenHeight * 0.3,
                                                // width: screenWidth / 0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: FutureBuilder<bool>(
                                                  future: checkImageExists(
                                                      "${Webservices.imageUrl}${alGetWhoViewedContactList[index].imageName ?? ""}"),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else if (snapshot
                                                            .hasError ||
                                                        !snapshot.data!) {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                profileImg),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    16),
                                                            topRight:
                                                                Radius.circular(
                                                                    16),
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                "${Webservices.imageUrl}${alGetWhoViewedContactList[index].imageName}"),
                                                            fit: BoxFit.fill,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    16),
                                                            topRight:
                                                                Radius.circular(
                                                                    16),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            maxLines: 2,
                                                            minFontSize: 6,
                                                            "${alGetWhoViewedContactList[index].firstName ?? ""}" +
                                                                " ${alGetWhoViewedContactList[index].lastName ?? ""}",
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: AppColor
                                                                  .mainText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily: FontName
                                                                  .poppinsRegular,
                                                            ),
                                                          ),
                                                        ),
                                                        AutoSizeText(
                                                          maxLines: 2,
                                                          minFontSize: 6,
                                                          "${alGetWhoViewedContactList[index].age} Yrs, " +
                                                              "${heightValue ?? ""}",
                                                          // "21 Yrs, 5ft 11 in",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: AppColor
                                                                .grey,
                                                            fontFamily: FontName
                                                                .poppinsRegular,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02),
                                                    Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          "${alGetWhoViewedContactList[index].occupation ?? ""}" +
                                                              " -${alGetWhoViewedContactList[index].education ?? ""}",
                                                          // "Software Professional - Graduate",
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: AppColor.grey,
                                                            fontFamily: FontName
                                                                .poppinsRegular,
                                                          ),
                                                        ),
                                                        AutoSizeText(
                                                          maxLines: 2,
                                                          minFontSize: 6,
                                                          " Viewed ${timeAgo}",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: AppColor
                                                                .black,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold,
                                                            fontFamily: FontName
                                                                .poppinsRegular,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: AutoSizeText(
                                                            maxLines: 2,
                                                            minFontSize: 6,
                                                            "${alGetWhoViewedContactList[index].city ?? ""}" +
                                                                ", ${alGetWhoViewedContactList[index].state ?? ""}" +
                                                                ", ${alGetWhoViewedContactList[index].state ?? ""}",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: AppColor
                                                                  .black,
                                                              fontFamily: FontName
                                                                  .poppinsRegular,
                                                            ),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return ProfileDetailScreen(
                                                                  profileId:
                                                                      alGetWhoViewedContactList[
                                                                              index]
                                                                          .id,
                                                                  profileFullName:
                                                                      "${alGetWhoViewedContactList[index].firstName} ${alGetWhoViewedContactList[index].lastName}",
                                                                );
                                                              },
                                                            ));
                                                          },
                                                          child: AutoSizeText(
                                                            "View Profile",
                                                            style: TextStyle(
                                                              color: AppColor
                                                                  .mainText,
                                                              fontFamily: FontName
                                                                  .poppinsRegular,
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
                                    /* return Container(
                                      padding: EdgeInsets.all(3),
                                      margin: EdgeInsets.all(3),
                                      // height: MediaQuery.of(context).size.height * 0.4,
                                      child: Card(
                                        color:
                                            Color.fromARGB(255, 245, 245, 245),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          side: BorderSide(
                                              width: 3,
                                              color: Colors.transparent),
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
                                                    ? MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.09
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.3,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image:alGetWhoViewedContactList[index].imageName.isNull ?
                                                  DecorationImage(image: AssetImage("assets/profile_image/girl.png")) :DecorationImage(
                                                    image: NetworkImage(
                                                        "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/" +
                                                            "${alGetWhoViewedContactList[index].imageName}"),
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
                                                          text: "${alGetWhoViewedContactList[index].firstName}" +
                                                              " ${alGetWhoViewedContactList[index].lastName}",
                                                          style: AppTheme
                                                              .tabNameText(),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              " Viewed on ${timeAgo}",
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 7),
                                                  Text(
                                                    "${alGetWhoViewedContactList[index].age}" +
                                                        " Yrs",
                                                  ),
                                                  SizedBox(height: 7),
                                                  Text("${alGetWhoViewedContactList[index].city}" +
                                                      ",${alGetWhoViewedContactList[index].state}"),
                                                  SizedBox(height: 7),
                                                  Text(
                                                      "${alGetWhoViewedContactList[index].occupation}"),
                                                  SizedBox(height: 7),
                                                  Text("${alGetWhoViewedContactList[index].incomeFrom}" +
                                                      " to ${alGetWhoViewedContactList[index].incomeTo}"),
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
                                                              alGetWhoViewedContactList[
                                                                      index]
                                                                  .id,
                                                        );
                                                      },
                                                    ));
                                                  },
                                                  child: Column(
                                                    children: const [
                                                      Icon(
                                                        Icons
                                                            .remove_red_eye_rounded,
                                                        color: Color.fromARGB(
                                                            255, 126, 143, 130),
                                                      ),
                                                      Text(
                                                        "view",
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    126,
                                                                    143,
                                                                    130)),
                                                      )
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    );*/
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
