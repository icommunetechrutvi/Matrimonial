import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/bottom_screet/bottom_sheet_screen.dart';
import 'package:matrimony/profile_screen/profile_details.dart';
import 'package:matrimony/profile_screen/profile_edit_screen.dart';
import 'package:matrimony/search_screen/profile_model.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/utils/appcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() {
    return _SearchScreenNewState();
  }
}

class _SearchScreenNewState extends State<SearchScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<CurrentProfileData> alGetProfileDetail = [];
  List<ProfileImages> profileImage = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      profileViewApi();
    });
  }

  /*void openBottomSheet() {
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: screenHeight * 0.7,
            */ /*MediaQuery.of(context).size.height * 0.70*/ /*
            child: BottomScreen(),
        );
        // return MyCheckbox(
        // );
      },
    );
  }*/

  Future<void> openBottomSheet() async {
    double screenHeight = MediaQuery.of(context).size.height;
    var responseData = await showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.7,
          child: BottomScreen(),
        );
      },
    );
    if (responseData != null) {
      alGetProfileDetail.clear();
      setState(() {
        _isLoading = true;
      });
      print('Response Data from bottom sheet: $responseData');
      ProfileListModel profileData = ProfileListModel.fromJson(responseData);
      print('Profile Data: $profileData');
      for (var prod in profileData.data!.data ?? []) {
        print("prod${prod}");
        alGetProfileDetail.add(prod);
        _isLoading = false;
        final profileImages = CurrentProfileData();
        for (var img in profileImages.profileImages ?? []) {
          profileImage.add(img);
        }
      }
      print('List after adding data: $alGetProfileDetail');
    } else {
      print('No data received from bottom sheet');
    }
  }

  Future<void> profileViewApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   final userName = prefs.getString('gender')?? "null";
   final gender;
   if(userName =="2"){
     gender=1;
   }
   else{
     gender=2;
   }
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/profile_list?gender=${gender}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        // final userMap = json.decode(response.body);
        // final occupationModel = CurrentProfileData.fromJson(userMap);

        var jsonList = jsonDecode(response.body) as Map<String, dynamic>;
        print("jsonList$jsonList");
        final localPickData = ProfileListModel.fromJson(jsonList);
        print("localPickData${localPickData}");
        for (var prod in localPickData.data!.data ?? []) {
          print("prod${prod}");
          alGetProfileDetail.add(prod);
          _isLoading = false;
          final profileImages = CurrentProfileData();
          for (var img in profileImages.profileImages ?? []) {
            profileImage.add(img);
          }
          // final defaultProfileImage= CurrentProfileData();
          // for(var img in defaultProfileImage.profileImages! ) {
          //   profileImage.add(img);
          //   print("alGetLocalPickupLoad${alGetProfileDetail}");
          // }
        }

        print("UserData@@${profileImage}");
      });
    } else {
      throw Exception('Failed to load education_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = screenHeight > screenWidth;

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color.fromARGB(255, 255, 241, 241),
          appBar: CommonAppBar(
            text: "Search",
            scaffoldKey: _scaffoldKey,
            key: Key("cv"),
          ),
          drawer: SideDrawer(),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bg_white.jpg",
                  ),
                  fit: BoxFit.fitHeight),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      // flex: 9,
                      child: Container(
                        padding: EdgeInsets.all(3),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.black,
                              offset: Offset(1, 3),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.search),
                            ),
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: Icon(Icons.filter_list_alt, size: 35),
                        onPressed: () => openBottomSheet(),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                    },
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.mainAppColor,
                              // backgroundColor: AppColor.pink,
                            ),
                          )
                        : ListView.builder(
                            itemCount: alGetProfileDetail.length,
                            itemBuilder: (context, index) {
                              return Container(
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
                                  // margin: EdgeInsets.all(5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          margin: EdgeInsets.all(15),
                                          height: isPortrait
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.1
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/" +
                                                      "${alGetProfileDetail[index].profileImages?[0].imageName}"),
                                              fit: BoxFit.cover,
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
                                              "${alGetProfileDetail[index].firstName}" +
                                                  " ${alGetProfileDetail[index].lastName}",
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 7),
                                            Text(
                                              "${alGetProfileDetail[index].age}" +
                                                  " Yrs",
                                            ),
                                            SizedBox(height: 7),
                                            Text("${alGetProfileDetail[index].city}" +
                                                ",${alGetProfileDetail[index].state}"),
                                            SizedBox(height: 7),
                                            Text(
                                                "${alGetProfileDetail[index].professionId!.occupation}"),
                                            SizedBox(height: 7),
                                            Text("${alGetProfileDetail[index].incomeFrom}" +
                                                " to ${alGetProfileDetail[index].incomeTo}"),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                builder: (context) {
                                                   return ProfileDetailScreen(
                                                    profileId:
                                                        alGetProfileDetail[
                                                                index]
                                                            .id,
                                                  );
                                                },
                                              ));
                                            },
                                            child: Column(
                                              children: [
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
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
