import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/home_screen/latestProfilesModel.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_details.dart';
import 'package:matrimony/search_screen/search_screen.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenNewState();
  }
}

class _HomeScreenNewState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final imageList = [
    'assets/card_image/A.jpg',
    'assets/card_image/B.jpg',
    'assets/card_image/C.jpg',
  ];
  List<LatestData> alGetMatchList = [];
  bool _isLoading = false;
  var profileImg = "";
  List<String> genderList = ["Male", "Female"];
  late String gender = "Male";
  late int genderKey = 1;
  String? _selectedAge;
  String? _selectedAgeS;

  List<String>_selectFromAgeList=["18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34",
    "35","36","37","38","39","40","41",
    "42","43",
    "44","45",
    "46","47",
    "48","49",
    "50"
  ];

  String? _selectMaritalStatus;
  List<String> maritalStatusList = [];
  List<String> maritalStatusKeys = [];
  late String selectedMaritalKey="0";
  String? _selectedGender;
  Map<String, dynamic>? heightList;
  @override
  void initState() {
    fetchGlobalValues();
    genderData();
    favoriteListApi();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = screenHeight > screenWidth;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CommonAppBar(
        text: "Home Page",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            color: AppColor.mainAppColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 240,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
                  child: Swiper(
                    index: 1,
                    scrollDirection: Axis.horizontal,
                    itemCount: imageList.length,
                    autoplay: true,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imageList[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:  Text(
                    "Quick Search",
                    style: TextStyle(
                        fontSize: 22,
                        color: AppColor.mainText,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.0),
                Container(
                  // color: Colors.black12,
                  padding:
                  EdgeInsets.only(left: 3, right: 4, bottom: 5, top: 5),
                  margin: EdgeInsets.all(9),
                  color: AppColor.white,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Looking For"),
                          Text("Marital Status"),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: RadioListTile(
                              contentPadding:
                              EdgeInsets.only(left: 2, right: 2),
                              activeColor: AppColor.mainText,
                              title: AutoSizeText(maxLines: 1,minFontSize: 7,"Male"),
                              value: "male",
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                  genderKey = 1;
                                  print("genderKey~~${genderKey}");
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: RadioListTile(
                              contentPadding:
                              EdgeInsets.only(left: 9, right: 0),
                              activeColor: AppColor.mainText,
                              title: AutoSizeText("Female",maxLines: 1,minFontSize: 7,),
                              value: "female",
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                  genderKey = 2;
                                  print("genderKey~~${genderKey}");
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              margin: EdgeInsets.all(6),
                              decoration: AppTheme.ConDecoration(),
                              child: DropdownButton<String>(
                                menuMaxHeight: 170,
                                borderRadius: BorderRadius.circular(12),
                                isExpanded: true,
                                value: _selectMaritalStatus,
                                hint: Text('Select'),
                                underline: Column(),
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectMaritalStatus = newValue!;
                                    print(
                                        "_selectedAgeS${_selectMaritalStatus}");
                                  });
                                  if (newValue != null) {
                                    int index =
                                    maritalStatusList.indexOf(newValue);
                                    if (index != -1 &&
                                        index < maritalStatusKeys.length) {
                                      selectedMaritalKey =
                                      maritalStatusKeys[index];
                                      print(
                                          "Selected key: $selectedMaritalKey");
                                    }
                                  }
                                },
                                items: maritalStatusList
                                    .map<DropdownMenuItem<String>>(
                                        (String list) {
                                      return DropdownMenuItem<String>(
                                        value: list,
                                        child: AutoSizeText(list),
                                      );
                                    }).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                      Align(alignment: Alignment.topLeft, child: Text("Age")),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              margin: EdgeInsets.all(6),
                              decoration: AppTheme.ConDecoration(),
                              child: DropdownButton<String>(
                                menuMaxHeight: 170,
                                borderRadius: BorderRadius.circular(12),
                                isExpanded: true,
                                value: _selectedAge,
                                hint: Text('18'),
                                underline: Column(),
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAge = newValue!;
                                    print("_selectedAge$_selectedAge");
                                  });
                                },
                                items: _selectFromAgeList.map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                          Text(
                            "To",
                          ),
                          Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                margin: EdgeInsets.all(6),
                                decoration: AppTheme.ConDecoration(),
                                child: DropdownButton<String>(
                                  menuMaxHeight: 170,
                                  borderRadius: BorderRadius.circular(12),
                                  isExpanded: true,
                                  value: _selectedAgeS,
                                  hint: Text('24'),
                                  underline: Column(),
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.black),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedAgeS = newValue!;
                                      print("_selectedAgeS${_selectedAgeS}");
                                    });
                                  },
                                  items: _selectFromAgeList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                ),
                              )),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        AppColor.mainText)),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchScreen(
                                        selectedGender: genderKey.toString()??1,
                                        selectedMaritalStatus: selectedMaritalKey??0,
                                        selectedAge: _selectedAge??18,
                                        selectedAgeS: _selectedAgeS??24,
                                      ),
                                    ),
                                  );

                                },
                                child: AutoSizeText(
                                  maxLines: 1,
                                  "Search",
                                  style: AppTheme.buttonBold(),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child:  Text(
                    "Latest Profiles",
                    style: TextStyle(
                        fontSize: 22,
                        color: AppColor.mainText,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: AppColor.white,
                  ),
                )
                    : alGetMatchList.isNotEmpty
                    ? ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: alGetMatchList.length,
                  itemBuilder: (context, index) {
                    if (index < alGetMatchList.length) {
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
                                    profileFullName: "${alGetMatchList[index].firstName} ${alGetMatchList[index].lastName}",
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
                                                        profileFullName: "${alGetMatchList[index].firstName} ${alGetMatchList[index].lastName}",
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
                )
                    : Container(
                  padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: Text(
                      "No profiles found",
                      style: AppTheme.nameText(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> checkImageExists(String url) async {
    final response = await http.head(Uri.parse(url));
    return response.statusCode == 200;
  }

  Future<void> favoriteListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    final userType = prefs.getString(PrefKeys.KEYGENDER)!;
    final int gender;
    if (userType == "1") {
      gender = 1;
      profileImg = "https://rishtaforyou.com/storage/profiles/default1.png";
    } else {
      gender = 2;
      profileImg = "https://rishtaforyou.com/storage/profiles/default2.png";
    }
    setState(() {
      _isLoading = true;
    });
    final url =
    Uri.parse('${Webservices.baseUrl + Webservices.latestProfilesList}');
    print("url~~${url}");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      var jsonList = jsonDecode(response.body);
      print("jsonList$jsonList");
      final localPickData = LatestProfilesModel.fromJson(jsonList);
      print("localPickData~~~~~~~~***${localPickData}");
      alGetMatchList = localPickData.data ?? [];
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
        content: const Text("Nothing"),
        backgroundColor: AppColor.red,
      ));
      print("Nothing Data");
      throw Exception('Failed to load education_list');
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
      Map<String, dynamic> maritalLists =
      responseData['data']['maritalstatus_list'];
      maritalLists.forEach((key, value) {
        maritalStatusList.add(value as String);
        maritalStatusKeys.add(key);
      });
    } else {
      throw Exception('Failed to load income options');
    }
  }

  Future<dynamic> postData() async {
    var url = Uri.parse('${Webservices.baseUrl + Webservices.profileList}');

    var jsonData = json.encode({
      'gender': '${genderKey ?? "0"}',
      'marital_status':
      '${maritalStatusKeys.isEmpty ? "" : maritalStatusKeys}',
      'start_age': '${_selectedAge!.isEmpty ? "" : _selectedAge}',
      'end_age': '${_selectedAgeS!.isEmpty ? "" : _selectedAgeS}',
      // 'marital_status[]':'',
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
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<void> genderData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userName  = prefs.getString(PrefKeys.KEYGENDER)!;

    if(userName =="2"){
      _selectedGender="male";
      genderKey = 1;
    }
    else{
      _selectedGender="female";
      genderKey = 2;
    }
  }
}

