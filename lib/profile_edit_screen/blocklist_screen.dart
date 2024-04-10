import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/wishList_screen/FavoriteListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BlockListScreen extends StatefulWidget {
  BlockListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BlockListScreen> createState() => _MyBlocklistPageState();
}

class _MyBlocklistPageState extends State<BlockListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<Favorites> alGetFavoriteList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      favoriteListApi();
    });
  }

  Future<void> favoriteListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('accessToken') ?? "null";
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/favorite_list');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      // final userMap = json.decode(response.body);
      // final occupationModel = CurrentProfileData.fromJson(userMap);

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
        text: "Blocked Profile",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: Stack(fit: StackFit.expand, children: [
        Image.asset(
          "assets/images/bg_white.jpg",
          fit: BoxFit.fill,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              _isLoading
                  ? Center(
                child: CircularProgressIndicator(
                  color: AppColor.buttonColor,
                ),
              )
                  : alGetFavoriteList.isNotEmpty
                  ? Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: ListView.builder(
                  itemCount: alGetFavoriteList.length,
                  itemBuilder: (context, index) {
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
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/" +
                                            "${alGetFavoriteList[index].imageName}"),
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
                                    "${alGetFavoriteList[index].firstName}" +
                                        " ${alGetFavoriteList[index].lastName}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    "${alGetFavoriteList[index].age}" +
                                        " Yrs",
                                  ),
                                  SizedBox(height: 7),
                                  Text("${alGetFavoriteList[index].city}" +
                                      ",${alGetFavoriteList[index].state}"),
                                  SizedBox(height: 7),
                                  Text(
                                      "${alGetFavoriteList[index].occupation}"),
                                  SizedBox(height: 7),
                                  Text("${alGetFavoriteList[index].incomeFrom}" +
                                      " to ${alGetFavoriteList[index].incomeTo}"),
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
                                              alGetFavoriteList[index]
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
