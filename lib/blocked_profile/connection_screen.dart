import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/ConnectionListModel.dart';
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

class ConnectionListScreen extends StatefulWidget {
  ConnectionListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ConnectionListScreen> createState() =>
      _MyViewedContactScreenPageState();
}

class _MyViewedContactScreenPageState extends State<ConnectionListScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool viewedContactSentLoaded = false;
  bool viewedContactReceivedLoaded = false;

  late final TabController _tabController;
  final _selectedColor = AppColor.mainText;
  List<ConnectionData> alGetConnectionSentList = [];
  List<ConnectionData> alGetConnectionReceivedList = [];
  var profileImg ="";
  Map<String, dynamic>? heightList;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    iViewedContactSentListApi();
    iViewedContactReceivedListApi();
    fetchGlobalValues();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> iViewedContactSentListApi() async {
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
      viewedContactSentLoaded = true;
    });
    final url =
    Uri.parse('${Webservices.baseUrl + Webservices.connectionSentList}');
    print("url~~$url");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = ConnectionListModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetConnectionSentList = localPickData.connection ?? [];
      setState(() {
        viewedContactSentLoaded = false;
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
        viewedContactSentLoaded = false;
      });
      print("alGetFavoriteList~~~${alGetConnectionSentList.length}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("YOUR CONNECTION SENT LIST EMPTY  "),
        backgroundColor: AppColor.red,
      ));
      print("Nothing Data");
      throw Exception('Failed to load education_list');
    }
  }

  Future<void> iViewedContactReceivedListApi() async {
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
      viewedContactReceivedLoaded = true;
    });
    final url =
    Uri.parse('${Webservices.baseUrl + Webservices.connectionReceived}');
    print("url~~$url");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = ConnectionListModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetConnectionReceivedList = localPickData.connection ?? [];
      setState(() {
        viewedContactReceivedLoaded = false;
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
        viewedContactReceivedLoaded = false;
      });
      print("alGetFavoriteList~~~${alGetConnectionReceivedList.length}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text("YOUR CONNECTION RECEIVED LIST EMPTY  "),
        backgroundColor: AppColor.red,
      ));
      print("Nothing Data");
      throw Exception('Failed to load education_list');
    }
  }

  Future<dynamic> postConnectionEditApi(connectionId, status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    final loginId = prefs.getString(PrefKeys.KEYPROFILEID)!;
    print("userToken~~${userToken}");
    var url =
    Uri.parse(
        '${Webservices.baseUrl + Webservices.connectionStatusEdit}');

    print("url~~${url}");

    var jsonData = json.encode({
      'connection_id': '$connectionId',
      "status": "$status"
    });
    print("formData!!!${jsonData}");
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
        body: (jsonData),
      );
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final userMap = json.decode(response.body);

        print("response~~~~^^^^${userMap}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Request $status Successfully"),
          backgroundColor: AppColor.snackBarColor,
        ));
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Token is Expire!! Please Login Again"),
          backgroundColor: AppColor.red,
        ));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ));
        throw Exception('Failed to load data');
      }
      else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Internal Status"),
          backgroundColor: AppColor.red,
        ));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ));
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
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

  Future<bool> checkImageExists(String url) async {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    bool isPortrait = screenHeight > screenWidth;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CommonAppBar(
        text: "Connection Request",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: Stack(fit: StackFit.expand, children: [
        Container(color: AppColor.mainAppColor,),
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
                onTap: (value) {
                  iViewedContactSentListApi();
                  iViewedContactReceivedListApi();
                },
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                    color: AppColor.mainAppColor),
                labelColor:_selectedColor,
                unselectedLabelColor:AppColor.grey,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "Connection Received",
                      style: AppTheme.tabText(),
                      // style: AppTheme.wishListView(),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Connection Sent",
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
                  viewedContactReceivedLoaded
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor.mainText,
                    ),
                  )
                      : Container(
                    child: alGetConnectionReceivedList.isEmpty
                        ? Container(
                      child: Center(
                        child: Text(
                          "YOUR CONNECTION RECEIVED IS EMPTY",
                          style: AppTheme.nameText(),
                        ),
                      ),
                    )
                        : ListView.builder(
                      itemCount: alGetConnectionReceivedList.length,
                      itemBuilder: (context, index) {
                        if (index < alGetConnectionReceivedList.length) {
                          String? heightKey = alGetConnectionReceivedList[index].height.toString();
                          String? heightValue = heightList?[heightKey??0];
                          return  InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProfileDetailScreen(
                                        profileId:
                                        alGetConnectionReceivedList[index]
                                            .id,
                                        profileFullName:
                                        "${alGetConnectionReceivedList[index].firstName} ${alGetConnectionReceivedList[index].lastName}",
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
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("${Webservices.imageUrl}${alGetConnectionReceivedList[index].imageName}"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                      /*FutureBuilder<bool>(
                                        future: checkImageExists("${Webservices.imageUrl}${alGetConnectionReceivedList[index].imageName ?? ""}"),
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
                                                  image: NetworkImage("${Webservices.imageUrl}${alGetConnectionReceivedList[index].imageName}"),
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
                                      ),*/
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
                                                  "${alGetConnectionReceivedList[index].firstName ?? ""}"+" ${alGetConnectionReceivedList[index].lastName ?? ""}",
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
                                                "${alGetConnectionReceivedList[index].age} Yrs, "+"${heightValue?? ""}",
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
                                          Text(
                                            "${alGetConnectionReceivedList[index].occupation ?? ""}"+" -${alGetConnectionReceivedList[index].education?? ""}",
                                            // "Software Professional - Graduate",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColor.grey,
                                              fontFamily: FontName.poppinsRegular,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  maxLines: 2,
                                                  minFontSize: 6,
                                                  "${alGetConnectionReceivedList[index].city ?? ""}"+", ${alGetConnectionReceivedList[index].state?? ""}"+", ${alGetConnectionReceivedList[index].profileCountry ?? ""}",
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
                                                            alGetConnectionReceivedList[index]
                                                                .id,
                                                            profileFullName:
                                                            "${alGetConnectionReceivedList[index].firstName} ${alGetConnectionReceivedList[index].lastName}",
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
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: AutoSizeText(
                                                  alGetConnectionReceivedList[index].status!
                                                      .toUpperCase(),
                                                  style: TextStyle(
                                                      color: alGetConnectionReceivedList[index]
                                                          .status == "accepted"
                                                          ?
                                                      Colors.green
                                                          : alGetConnectionReceivedList[index]
                                                          .status == "rejected" ? Colors
                                                          .red :Colors.blue,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      fontFamily: FontName.poppinsRegular,
                                                      fontSize: 25),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  alGetConnectionReceivedList[index]
                                                      .status == "rejected" || alGetConnectionReceivedList[index]
                                                      .status == "pending" ?
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors
                                                                .lightGreen),
                                                      ),
                                                      onPressed: () {
                                                        postConnectionEditApi(
                                                            alGetConnectionReceivedList[index]
                                                                .connectionId,
                                                            "accepted");
                                                      },
                                                      child: Text(
                                                          "Accept",style: TextStyle(fontFamily: FontName.poppinsRegular))):Container(),SizedBox(width: 5,),
                                                  alGetConnectionReceivedList[index]
                                                      .status == "accepted" || alGetConnectionReceivedList[index]
                                                      .status == "pending" ?
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                        MaterialStatePropertyAll(
                                                            Colors.red),
                                                      ),
                                                      onPressed: () {
                                                        postConnectionEditApi(
                                                            alGetConnectionReceivedList[index]
                                                                .connectionId,
                                                            "rejected");
                                                      },
                                                      child:  Text(
                                                        "Reject",style: TextStyle(fontFamily: FontName.poppinsRegular),)):Container(),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return viewedContactReceivedLoaded
                              ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.mainAppColor,
                            ),
                          )
                              : SizedBox();
                        }
                      },
                    ),
                  ),


                  viewedContactSentLoaded
                      ? Center(
                    child: CircularProgressIndicator(
                      color: AppColor.mainText,
                    ),
                  )
                      : Container(
                    child: alGetConnectionSentList.isEmpty
                        ? Container(
                      child: Center(
                        child: Text(
                          "YOUR CONNECTION SENT LIST EMPTY",
                          style: AppTheme.nameText(),
                        ),
                      ),
                    )
                        :ListView.builder(
                      itemCount: alGetConnectionSentList.length,
                      itemBuilder: (context, index) {
                        if (index < alGetConnectionSentList.length) {
                          String? heightKey = alGetConnectionSentList[index].height.toString();
                          String? heightValue = heightList?[heightKey??0];
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProfileDetailScreen(
                                        profileId:
                                        alGetConnectionSentList[index]
                                            .id,
                                        profileFullName:
                                        "${alGetConnectionSentList[index].firstName} ${alGetConnectionSentList[index].lastName}",
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
                                    child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage("${Webservices.imageUrl}${alGetConnectionSentList[index].imageName}"),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                    )
                                    /*  child: FutureBuilder<bool>(
                                        future: checkImageExists("${Webservices.imageUrl}${alGetConnectionSentList[index].imageName ?? ""}"),
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
                                                  image: NetworkImage("${Webservices.imageUrl}${alGetConnectionSentList[index].imageName}"),
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
                                      ),*/
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  maxLines: 2,
                                                  minFontSize: 6,
                                                  "${alGetConnectionSentList[index].firstName ?? ""}"+" ${alGetConnectionSentList[index].lastName ?? ""}",
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
                                                "${alGetConnectionSentList[index].age} Yrs, "+"${heightValue?? 0}",
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
                                          AutoSizeText(
                                            maxLines: 2,
                                            minFontSize: 6,
                                            "${alGetConnectionSentList[index].occupation ?? ""}"+" - ${alGetConnectionSentList[index].education ?? ""}",
                                            // "Software Professional - Graduate",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColor.grey,
                                              fontFamily: FontName.poppinsRegular,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: AutoSizeText(
                                                  maxLines: 2,
                                                  minFontSize: 6,
                                                  "${alGetConnectionSentList[index].city ?? ""}"+", ${alGetConnectionSentList[index].state?? ""}"+", ${alGetConnectionSentList[index].profileCountry ?? ""}",
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
                                                            alGetConnectionSentList[index]
                                                                .id,
                                                            profileFullName:
                                                            "${alGetConnectionSentList[index].firstName} ${alGetConnectionSentList[index].lastName}",
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
                                          Container(
                                            child: AutoSizeText(
                                              alGetConnectionSentList[index].status!
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  color: alGetConnectionSentList[index]
                                                      .status == "accepted"
                                                      ?
                                                  Colors.green
                                                      : alGetConnectionSentList[index]
                                                      .status == "rejected" ? Colors
                                                      .red :Colors.blue,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontFamily: FontName.poppinsRegular,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return viewedContactSentLoaded
                              ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.mainAppColor,
                            ),
                          )
                              : SizedBox();
                        }
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
