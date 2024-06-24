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


  String? _selectedName;
  String? _selectedCountry;
  String? _selectedState;
  String? _selectedMaritalStatus="1";
  String? _selectedAge;
  String? _selectedAgeS;
  String? _selectedDiet ;
  String? _selectedBodyType ;
  String? _selectedComplexion ;
  String? _selectedReligion ;
  String? _selectedEducation ;
  String? _selectedProfession ;
  String? _selectedIncome ;
  String? _selectedPhoto;
  String? gender;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchGlobalValues();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent && !_isLoading && _hasMoreData) {
          _loadNextPage();
        }
      });

      if(widget.selectedGender==""||widget.selectedAge==""||widget.selectedAgeS==""||widget.selectedMaritalStatus==""){
        profileViewApi();
        print("postData(");
      }
      else
      {
        // postData();
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
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    var responseData = await showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.7,
          child: BottomScreen(
            selectedName: _selectedName,
            selectedCountry: _selectedCountry,
            selectedState: _selectedState,
            selectedGender: gender,
            selectedPhoto: _selectedPhoto,
            selectedMaritalStatus: _selectedMaritalStatus?? "",
            selectedDiet: _selectedDiet ?? "0",
            selectedBodyType: _selectedBodyType?? "",
            selectedComplexion: _selectedComplexion?? "",
            selectedReligion: _selectedReligion,
            selectedEducation: _selectedEducation??"",
            selectedProfession: _selectedProfession,
            selectedIncome: _selectedIncome,
            selectedAge: _selectedAge,
            selectedAgeS: _selectedAgeS,
          ),
        );
      },
    );
    if (responseData != null) {
      print("ALLDATA~~~${responseData}");
      setState(() {
        _isLoading = true;
        _selectedName = responseData['keyword'];
        _selectedCountry = responseData['country_id'];
        _selectedState = responseData['state'];
        gender = responseData['gender'];
        _selectedPhoto = responseData['photo_available'];
        _selectedMaritalStatus = responseData['marital_status'];
        _selectedDiet = responseData['diet'];
        _selectedBodyType = responseData['body_type'];
        _selectedComplexion = responseData['complexion'];
        _selectedReligion = responseData['religion_id'];
        _selectedEducation = responseData['education_id'];
        _selectedProfession = responseData['profession_id'];
        _selectedIncome = responseData['income'];
        _selectedAge = responseData['start_age'];
        _selectedAgeS = responseData['end_age'];
        alGetProfileDetail.clear();
      });
      print('Response Data from bottom sheet!!!: $responseData');
      fetchProfileData();
     /* try {
      *//*  ProfileListModel profileData = ProfileListModel.fromJson(responseData);
        print('Profile Datas###: ${profileData.status}');
        print('Profile Datas###: ${profileData.message}');
        if (profileData.data?.data != null) {
          for (var prod in profileData.data?.data ?? []) {
            print("prod${prod}");
            alGetProfileDetail.add(prod);
          }
        }

        setState(() {
          _isLoading = false;
        });

        final profileImages = CurrentProfileData();
        for (var img in profileImages.profileImages ?? []) {
          profileImage.add(img);
        }

        print('List after adding data: $alGetProfileDetail');*//*
      } catch (e) {
        print('Error parsing profile data: $e');
      }*/
    } else {
      print('No data received from bottom sheet');
    }

   /* print('Response Data from bottom sheet!!!: $responseData');
    ProfileListModel profileData = ProfileListModel.fromJson(responseData);
    print('Profile Datas###: ${profileData.status}');
    print('Profile Datas###: ${profileData.message}');
    for (var prod in profileData.data?.data ?? []) {
      print("prod${prod}");
      alGetProfileDetail.add(prod);
      setState(() {
        _isLoading = false;
      });
      final profileImages = CurrentProfileData();
      for (var img in profileImages.profileImages ?? []) {
        profileImage.add(img);
      }
    }
    print('List after adding data: $alGetProfileDetail');
*/

  }

  void fetchProfileData() async {
    try {
      Map<String, String?> filterParams = {
        'keyword': _selectedName,
        'country_id': _selectedCountry,
        'state': _selectedState,
        'gender': gender,
        'photo_available': _selectedPhoto,
        'marital_status': _selectedMaritalStatus,
        'diet': _selectedDiet ?? "0",
        'body_type': _selectedBodyType,
        'complexion': _selectedComplexion,
        'religion_id': _selectedReligion,
        'education_id': _selectedEducation,
        'profession_id': _selectedProfession,
        'income': _selectedIncome,
        'start_age': _selectedAge?.toString(),
        'end_age': _selectedAgeS?.toString(),
      };
      filterParams.removeWhere((key, value) => value == null);

      ProfileListModel profileData = await postData(filterParams);


      setState(() {
        _isLoading = false;
        alGetProfileDetail = profileData.data?.data ?? [];
        // profileImage = profileData.profileImages ?? [];
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching profile data: $e');
    }
  }



  /* Future<void> openBottomSheet() async {
    double screenHeight = MediaQuery.of(context).size.height;
    var responseData = await showModalBottomSheet(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: screenHeight * 0.7,
          child: BottomScreen(
            selectedName: _selectedName,
            selectedCountry: _selectedCountry,
            selectedState: _selectedState,
            selectedGender: _selectedGender,
            selectedPhoto: _selectedPhoto,
            selectedMaritalStatus: _selectedMaritalStatus,
            selectedDiet: _selectedDiet,
            selectedBodyType: _selectedBodyType,
            selectedComplexion: _selectedComplexion,
            selectedReligion: _selectedReligion,
            selectedEducation: _selectedEducation,
            selectedProfession: _selectedProfession,
            selectedIncome: _selectedIncome,
            selectedAge: _selectedAge,
            selectedAgeS: _selectedAgeS,
          ),
        );
      },
    );
    if (responseData != null) {
      var url = Uri.parse(
          '${Webservices.baseUrl+Webservices.profileList}');
      var jsonData = json.encode({
        'keyword': _selectedName,
        // 'country_id': '${_selectedCountry!.id.isNull ?" ":_selectedCountry?.id.toString()}',
        'state': _selectedState,
        'gender': _selectedGender,
        'religion_id': _selectedReligion,
        'photo_available': _selectedPhoto,
        'marital_status[]': _selectedMaritalStatus,
        'diet[]': _selectedDiet,
        'body_type[]':_selectedBodyType,
        'complexion[]': _selectedComplexion,
        'education_id[]': _selectedEducation,
        'profession_id[]': _selectedProfession,
        'income': _selectedIncome,
        'start_age': _selectedAge,
        'end_age':_selectedAgeS,

        // 'height': '${_heightRange?.start.toInt().toString()}-${_heightRange?.end.toInt().toString()}',
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
      print("ALLDATA~~~${responseData}");
     *//* setState(() {
        _isLoading = true;
        _selectedName = responseData['keyword'];
        _selectedCountry = responseData['country_id'];
        _selectedState = responseData['state'];
        _selectedGender = responseData['gender'];
        _selectedPhoto = responseData['photo_available'];
        _selectedMaritalStatus = responseData['marital_status[]'];
        _selectedDiet = responseData['diet[]'];
        _selectedBodyType = responseData['body_type[]'];
        _selectedComplexion = responseData['complexion[]'];
        _selectedReligion = responseData['religion_id'];
        _selectedEducation = responseData['education_id[]'];
        _selectedProfession = responseData['profession_id[]'];
        _selectedIncome = responseData['income'];
        _selectedAge = responseData['start_age'];
        _selectedAgeS = responseData['end_age'];
        alGetProfileDetail.clear();
      });*//*
      print('Response Data from bottom sheet!!!: $responseData');


    } else {
      print('No data received from bottom sheet');
    }
  }*/

  Future<void> profileViewApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userName  = prefs.getString(PrefKeys.KEYGENDER)!;


   if(userName =="2"){
     gender=1.toString();
     profileImg="https://rishtaforyou.com/storage/profiles/default1.png";
   }
   else{
     gender=2.toString();
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
        var jsonList = jsonDecode(response.body) as Map<String, dynamic>;
        final userMap = json.decode(response.body);
        bool status = userMap["status"];
        if(status==true) {
          print("jsonList$jsonList");
          final localPickData = ProfileListModel.fromJson(jsonList);
          print("localPickData${localPickData}");
          setState(() {
            if (localPickData.data!.data != null) {
              for (var prod in localPickData.data!.data ?? []) {
                print("prod${prod}");
                alGetProfileDetail.add(prod);
                _isLoading = false;
                final profileImages = CurrentProfileData();
                for (var img in profileImages.profileImages ?? []) {
                  profileImage.add(img);
                }
              }
            } else {
              setState(() {
                _hasMoreData = false;
              });
            }
          });
          print("UserData@@${profileImage}");
        }
        else{
          setState(() {
            _isLoading = false;
          });
        }
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> postData(Map<String, String?> parameters) async {
    var url = Uri.parse(
        '${Webservices.baseUrl+Webservices.profileList}');
    var jsonData = json.encode(parameters);
  /*  var jsonData = json.encode({
      'keyword': '${searchTextController.text.isNull ? _selectedName :searchTextController.text}',
      'gender': widget.selectedGender ?? _selectedGender,
      'marital_status[]': widget.selectedMaritalStatus ?? "",
      'start_age': widget.selectedAge ?? "",
      'end_age': widget.selectedAgeS ?? ""
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
    });*/
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
        print('Response Data from bottom sheet:^^^^^ $response');
        ProfileListModel profileData = ProfileListModel.fromJson(jsonList);
        print('Profile Data: $profileData');
        for (var prod in profileData.data!.data ?? []) {
          print("prod${prod}");
          alGetProfileDetail.add(prod);
          setState(() {
          _isLoading = false;
          });
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
                                // postData();
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
                   alGetProfileDetail.isNotEmpty ?
                   Expanded(
                 /* child: RefreshIndicator(
                    color: AppColor.mainText,
                    onRefresh: () async {
                      await Future.delayed(Duration(seconds: 1));
                      return profileViewApi();
                    },*/
                    child: _isLoading  && currentPage == 1
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColor.mainText,
                            ),
                          )
                        : ListView.builder(
                      controller: _scrollController,
                      itemCount: alGetProfileDetail.length+ (_hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < alGetProfileDetail.length) {
                          String? heightKey = alGetProfileDetail[index].height.toString();
                          String? heightValue = heightList?[heightKey??0];
                          return InkWell(
                            onTap: () {
                              // if(alGetProfileDetail[index].photoAvailable ==0) {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return ProfileDetailScreen(
                                          profileId:
                                          alGetProfileDetail[index]
                                              .id,
                                          profileFullName:
                                          "${alGetProfileDetail[index]
                                              .firstName} ${alGetProfileDetail[index].lastName}",
                                          // profileFullName: "${alGetProfileDetail[index].firstName} ${alGetProfileDetail[index].lastName}",
                                        );
                                      },
                                    ));
                              // }else{}
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
                  // ),
                ):_emptyView(),
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

  _emptyView() {
    return Container(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
             "assets/icon/ic_empty_note.png",
              height: 80,
              width: 110,
              color: AppColor.mainText,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Empty List!",
              style:TextStyle(color: AppColor.mainText,fontFamily: FontName.poppinsRegular,fontSize: 22,fontWeight: FontWeight.w900),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "No Profiles Found",
              style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,fontFamily: FontName.poppinsRegular,color: AppColor.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
