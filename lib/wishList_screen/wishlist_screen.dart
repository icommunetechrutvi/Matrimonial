import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/bottom_sheet_screen/view_model/global_value_model.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:matrimony/wishList_screen/FavoriteListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistScreen extends StatefulWidget {
  WishlistScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WishlistScreen> createState() => _MyWishlistPageState();
}

class _MyWishlistPageState extends State<WishlistScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Favorites> alGetFavoriteList = [];
  bool _isLoading = false;
  var profileImg ="";
  Map<String, dynamic>? heightList;


  @override
  void initState() {
    super.initState();
    setState(() {
      fetchGlobalValues();
      favoriteListApi();
    });
  }
  Future<void> fetchGlobalValues() async {
    final url = Uri.parse('${Webservices.baseUrl+Webservices.globalValue}');
    final response = await http.get(url);
    print("url~~${url}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final localPickData = GlobalValueModel.fromJson(responseData);
      print("localPickData${localPickData.data}");


      final Map<String, dynamic> heightMap = responseData['data']['height_list'];
      heightList = heightMap.map((key, value) => MapEntry(key, value.toString()));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('globalApiData', response.body);

    } else {
      throw Exception('Failed to load income options');
    }
  }
  Future<void> favoriteListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN)?? "null";
    final userName  = prefs.getString(PrefKeys.KEYGENDER)!;

    if(userName =="2"){
      profileImg="https://rishtaforyou.com/storage/profiles/default1.png";
    }
    else{
      profileImg="https://rishtaforyou.com/storage/profiles/default2.png";
    }
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse( '${Webservices.baseUrl+Webservices.favoriteList}');
    print("url~~${url}");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = FavoriteListModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetFavoriteList = localPickData.favorites ?? [];
      setState(() {
        _isLoading = false;
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
        _isLoading = false;
      });
      print("alGetFavoriteList~~~${alGetFavoriteList.length}");
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
        text: "Shortlisted Profile",
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
        SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppColor.lightGreen,
                      ),
                    )
                  : alGetFavoriteList.isNotEmpty
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: ListView.builder(
                            itemCount: alGetFavoriteList.length,
                            itemBuilder: (context, index) {
                              String? heightKey = alGetFavoriteList[index].height.toString();
                              String? heightValue = heightList?[heightKey??0];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ProfileDetailScreen(
                                            profileId:
                                            alGetFavoriteList[index].id,
                                            profileFullName:
                                            "${alGetFavoriteList[index].firstName} ${alGetFavoriteList[index].lastName}",
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
                                            future: checkImageExists("${Webservices.imageUrl}${alGetFavoriteList[index].imageName ?? ""}"),
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
                                                      image: NetworkImage("${Webservices.imageUrl}${alGetFavoriteList[index].imageName}"),
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
                                        /*  Container(
                                          height: screenHeight * 0.3,
                                          // width: screenWidth / 0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            ),
                                          ),
                                          child: FutureBuilder<bool>(
                                            future: checkImageExists("${Webservices.imageUrl}${alGetProfileDetail[index].profileImages![0].imageName ?? ""}"),
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
                                                      image: NetworkImage("${Webservices.imageUrl}${alGetProfileDetail[index].profileImages![0].imageName}"),
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
                                        ),*/
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
                                                      "${alGetFavoriteList[index].firstName ?? ""}"+" ${alGetFavoriteList[index].lastName ?? ""}",
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
                                                    "${alGetFavoriteList[index].age} Yrs, "+"${heightValue ?? 0}",
                                                    // "21 Yrs, 5ft 11 in",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: AppColor.black,
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
                                                "${alGetFavoriteList[index].occupation ?? ""}"+" - ${alGetFavoriteList[index].education ?? ""}",
                                                // "Software Professional - Graduate",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: AppColor.listText,
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
                                                      "${alGetFavoriteList[index].city ?? ""}"+", ${alGetFavoriteList[index].state?? ""}"+", ${alGetFavoriteList[index].profileCountry?? ""}",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: AppColor.black,
                                                        fontFamily: FontName.poppinsRegular,
                                                      ),),
                                                  ),
                                                  TextButton(
                                                    // style: ButtonStyle(
                                                    // alignment: Alignment.centerLeft,
                                                    // padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                                    //   EdgeInsets.zero,
                                                    // ),
                                                    // ),
                                                    onPressed: () {
                                                      Navigator.push(context,
                                                          MaterialPageRoute(
                                                            builder: (context) {
                                                              return ProfileDetailScreen(
                                                                profileId:
                                                                alGetFavoriteList[index]
                                                                    .id,
                                                                profileFullName:
                                                                "${alGetFavoriteList[index].firstName} ${alGetFavoriteList[index].lastName}",
                                                                // profileFullName: "${alGetProfileDetail[index].firstName} ${alGetProfileDetail[index].lastName}",
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
                        )
                      : Container(
                          padding: EdgeInsets.only(top: 30),
                          child: Center(
                            child: Text(
                              "YOUR SHORTLIST IS EMPTY",
                              style: AppTheme.nameText(),
                            ),
                          ),
                        ),
            ],
          ),
        ),
      ]),
    );
  }
}
