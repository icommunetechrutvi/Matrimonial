import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/MatchListModel.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MatchListScreen extends StatefulWidget {
  MatchListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MatchListScreen> createState() => _MyMatchListPageState();
}

class _MyMatchListPageState extends State<MatchListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<MatchesData> alGetMatchList = [];
  bool _isLoading = false;
  var profileImg = "";
  Map<String, dynamic>? heightList;




  @override
  void initState() {
    super.initState();
    setState(() {
      favoriteListApi();
      fetchGlobalValues();
    });
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

  Future<void> favoriteListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN)?? "null";
    final userType = prefs.getString(PrefKeys.KEYGENDER)!;
    if (userType == "2") {
      profileImg = "https://rishtaforyou.com/storage/profiles/default1.png";
    } else {
      profileImg = "https://rishtaforyou.com/storage/profiles/default2.png";
    }
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse( '${Webservices.baseUrl+Webservices.matchList}');
    print("url~~${url}");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = MatchListModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetMatchList = localPickData.matches ?? [];
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
      print("alGetFavoriteList~~~${alGetMatchList.length}");
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
        text: "Matches Profile",
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
                  : alGetMatchList.isNotEmpty
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: ListView.builder(
                  itemCount: alGetMatchList.length,
                  itemBuilder: (context, index) {
                    String? heightKey = alGetMatchList[index].height.toString();
                    String? heightValue = heightList?[heightKey??0];
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ProfileDetailScreen(
                                  profileId:
                                  alGetMatchList[index]
                                      .id,
                                  profileFullName:
                                  "${alGetMatchList[index].firstName} ${alGetMatchList[index].lastName}",
                                );
                              },
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(3),
                        margin: EdgeInsets.all(3),
                        child: Card(
                          color: Color.fromARGB(255, 245, 245, 245),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                                width: 3, color: Colors.transparent),
                          ),
                          elevation: 5,
                          child: Column(
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
                                  future: checkImageExists("${Webservices.imageUrl}${alGetMatchList[index].profileImages![0].imageName ?? ""}"),
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
                                            image: NetworkImage("${Webservices.imageUrl}${alGetMatchList[index].profileImages![0].imageName}"),
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
                                      MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: AutoSizeText(
                                            maxLines: 2,
                                            minFontSize: 6,
                                            "${alGetMatchList[index].firstName ?? ""}"+" ${alGetMatchList[index].lastName ?? ""}",
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
                                          "${alGetMatchList[index].age} Yrs, "+"${heightValue ??0}",
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
                                      "${alGetMatchList[index].professionId!.occupation ?? ""}"+" - ${alGetMatchList[index].educationId!.education ?? ""}",
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
                                            "${alGetMatchList[index].city ?? ""}"+", ${alGetMatchList[index].state?? ""}"+", ${alGetMatchList[index].countryId?.countryName ?? ""}",
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
                                                      alGetMatchList[index]
                                                          .id,
                                                      profileFullName:
                                                      "${alGetMatchList[index].firstName} ${alGetMatchList[index].lastName}",
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
                   /* return Container(
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
                        elevation: 5,
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
                                  image:alGetMatchList[index].profileImages!.isEmpty ?
                                  const DecorationImage(image: AssetImage("assets/profile_image/girl.png")):
                                  DecorationImage(
                                    image: NetworkImage(
                                        "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/" +
                                            "${alGetMatchList[index].profileImages![0].imageName}"),
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
                                  Text(
                                    "${alGetMatchList[index].firstName}" +
                                        " ${alGetMatchList[index].lastName}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    "${alGetMatchList[index].age}" +
                                        " Yrs",
                                  ),
                                  SizedBox(height: 7),
                                  Text("${alGetMatchList[index].city}" +
                                      ",${alGetMatchList[index].state}"),
                                  SizedBox(height: 7),
                                  Text(
                                      "${alGetMatchList[index].professionId!.occupation}"),
                                  SizedBox(height: 7),
                                  Text("${alGetMatchList[index].incomeFrom}" +
                                      " to ${alGetMatchList[index].incomeTo}"),
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
                                              alGetMatchList[index]
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
                    );*/
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
