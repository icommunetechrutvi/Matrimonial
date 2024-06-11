import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/bottom_sheet_screen/bottom_sheet_screen.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/global_value_model.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/search_screen/profile_model.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  final selectedGender;
  final selectedMaritalStatus;
  final selectedAge;
  final selectedAgeS;
  const SearchScreen({super.key,
    required this.selectedGender,
    required this.selectedMaritalStatus,
    required this.selectedAge,
    required this.selectedAgeS,
  });

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
  TextEditingController searchTextController= TextEditingController();
  ScrollController _scrollController = ScrollController();

  Map<String, dynamic>? heightList;
  var profileImg ="";
  int currentPage = 1;
  bool _hasMoreData = true;



  @override
  void initState() {
    super.initState();
    setState(() {
      fetchGlobalValues();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent && !_isLoading && _hasMoreData) {
          // User has reached the end of the list, load next page
          _loadNextPage();
        }
      });

      if(widget.selectedGender==""||widget.selectedAge==""||widget.selectedAgeS==""||widget.selectedMaritalStatus==""){
        profileViewApi();
        print("postData(");
      }
      else
      {
        postData();
        print("profileViewApi()");
      }
      // profileViewApi();
    });
  }
  void _loadNextPage() {
    setState(() {
      currentPage++;
    });
    profileViewApi();
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
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('globalApiData', response.body);

    } else {
      setState(() {
        _hasMoreData = false;
      });
    }
  }

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
    final userName  = prefs.getString(PrefKeys.KEYGENDER)!;

    final gender;
   if(userName =="2"){
     gender=1;
     profileImg="https://rishtaforyou.com/storage/profiles/default1.png";
   }
   else{
     gender=2;
     profileImg="https://rishtaforyou.com/storage/profiles/default2.png";
   }
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        '${Webservices.baseUrl+Webservices.profileList}gender=${gender}&page=${currentPage}&limit=100');
    print("url~~${url}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {

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
        }
        print("UserData@@${profileImage}");
      });
    } else {
      throw Exception('Failed to load education_list');
    }
  }

  Future<dynamic> postData() async {
    var url = Uri.parse(
        '${Webservices.baseUrl+Webservices.profileList}');

    var jsonData = json.encode({
      'keyword': '${searchTextController.text.isNull ? "" :searchTextController.text}',
      // 'country_id': '${countryId.isNull ?"":countryId}',
      // 'state': '${_selectedState?.state=="" ? _selectedState?.state: " "   }',
      // 'gender': '${genderKey.isNull ?'1':genderKey}',
      // 'religion_id': '${religionKey.isNull ?"":religionKey}',
      // 'photo_available': '${photoKey.isNull ?"":photoKey}',
      // 'marital_status[]': '${maritalKey.isNull ?"":maritalKey}',
      // 'diet[]': '${dietKey.isNull ?"":dietKey}',
      // 'body_type[]': '${bodyKey.isNull ?"":bodyKey}',
      // 'complexion[]': '${complexionKey.isNull?"":complexionKey}',
      // 'education_id[]': '${educationKey.isNull ?"":educationKey}',
      // 'profession_id[]': '${professionKey.isNull ?"":professionKey}',
      // 'income': '${incomeKey.isNull ? "" : incomeKey}',
      // 'start_age': '${_selectedAge.isNull ?"":_selectedAge}',
      // 'end_age': '${_selectedAgeS.isNull?"":_selectedAgeS}',
      // // 'marital_status[]':'',
    });
    print("formData!!!${jsonData}");
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: (jsonData),
      );
      print('Response status: ${response.statusCode}');
      if (response != null) {
        alGetProfileDetail.clear();
        setState(() {
          _isLoading = true;
        });
        var jsonList = jsonDecode(response.body) as Map<String, dynamic>;
        print("jsonList$jsonList");
        print('Response Data from bottom sheet: $response');
        ProfileListModel profileData = ProfileListModel.fromJson(jsonList);
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
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
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

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          backgroundColor: Color.fromARGB(255, 255, 241, 241),
          appBar:  AppBar(
            elevation: 1,
            backgroundColor: AppColor.white,
            title: Text("Search"
              ,style:  TextStyle(
                fontSize: 16,
                color: AppColor.black,
                fontWeight: FontWeight.bold,
                fontFamily:
                FontName.poppinsRegular,),),
            leading: IconButton(
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              icon: const Icon(Icons.menu, color: Colors.black),
            ),
          ),
          drawer: SideDrawer(),
          body: Container(
            color: AppColor.mainAppColor,
            /*decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bg_white.jpg",
                  ),
                  fit: BoxFit.fitHeight),*/

            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 0,right: 9),
                  color: AppColor.white,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: AppColor.searchBorder,
                              width: 1,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child:  ListTile(
                            leading:Image.asset("assets/icon/search.png",height: screenHeight*0.04),
                            title: TextField(
                              style: TextStyle(
                                color:AppColor.black,
                                fontSize: 16,
                                fontFamily:  FontName.poppinsRegular,
                              ),
                              controller: searchTextController,
                              decoration: const InputDecoration(
                                hintText: 'Search Name',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                postData();
                                print("scjndcjdcj");
                              },
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.cancel,color: AppColor.black),
                              onPressed: () {
                                searchTextController.clear();
                                // onSearchTextChanged('');
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            openBottomSheet();
                          },
                          child: Container(
                            padding: EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColor.mainText,
                                width: 1,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                            child:  Center(
                              child:  AutoSizeText(
                                maxLines: 2,
                                minFontSize: 6,
                                "Filter", style: TextStyle(
                                color:AppColor.mainText,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily:  FontName.poppinsRegular,
                              ),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      controller: _scrollController,
                      itemCount: alGetProfileDetail.length,
                      itemBuilder: (context, index) {
                        if (index < alGetProfileDetail.length) {
                          String? heightKey = alGetProfileDetail[index].height.toString();
                          String? heightValue = heightList?[heightKey??0];
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return ProfileDetailScreen(
                                        profileId:
                                        alGetProfileDetail[index]
                                            .id,
                                        profileFullName:
                                        "${alGetProfileDetail[index].firstName} ${alGetProfileDetail[index].lastName}",
                                        // profileFullName: "${alGetProfileDetail[index].firstName} ${alGetProfileDetail[index].lastName}",
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
                                                  image: NetworkImage("${Webservices.imageUrl}${alGetProfileDetail[index].profileImages?[0].imageName}"),
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
                                                  "${alGetProfileDetail[index].firstName ?? ""}"+" ${alGetProfileDetail[index].lastName ?? ""}",
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
                                                "${alGetProfileDetail[index].age} Yrs, "+"${heightValue ?? 0}",
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
                                            "${alGetProfileDetail[index].professionId!.occupation ?? ""}"+" - ${alGetProfileDetail[index].educationId!.education ?? ""}",
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
                                                  "${alGetProfileDetail[index].city ?? ""}"+", ${alGetProfileDetail[index].state?? ""}"+", ${alGetProfileDetail[index].countryId!.countryName ?? ""}",
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
                                                            alGetProfileDetail[index]
                                                                .id,
                                                            profileFullName:
                                                            "${alGetProfileDetail[index].firstName} ${alGetProfileDetail[index].lastName}",
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
                        } else {
                          return _isLoading
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
