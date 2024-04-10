import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/ContactAddModel.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/global_value_model.dart';
import 'package:matrimony/profile_edit_screen/view_model/profile_detail_model.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailScreen extends StatefulWidget {
  final profileId;

  ProfileDetailScreen({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  State<ProfileDetailScreen> createState() => _MyProfileDetailPageState();
}

class _MyProfileDetailPageState extends State<ProfileDetailScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<ProfileDetailModel> alGetProfileDetail = [];
  List<ContactAddModel> alGetContactDetail = [];
  bool _isLoading = false;

  List<ProfileImages> profileImages = [];
  List<GlobalValueModel> allGetGlobalValue = [];

  List<String> heightList = [];
  String? _selectedHeight;
  List<String> heightKeys = [];
  late String selectedKey = '';

  List<String> genderList = [];
  String? _selectedGender;
  late String selectedGenderKey = '';
  List<String> genderKeys = [];

  List<String> dietList = [];
  String? _selectedDiet;
  List<String> dietKeys = [];
  late String selectedDietKey = '';

  List<String> bloodGroupList = [];
  String? _selectedBlood;
  List<String> bloodKeys = [];
  late String selectedBloodKey = '';

  List<String> maritalStatusList = [];
  String? _selectedMarital;
  List<String> maritalKeys = [];
  late String selectedMaritalKey = '';

  List<String> religionList = [];
  String? _selectedReligion;
  List<String> religionKeys = [];
  late String selectedReligionKey = '';

  List<String> fatherList = [];
  String? _selectedFather;
  List<String> fatherKeys = [];
  late String selectedFatherKey = '';

  List<String> motherList = [];
  String? _selectedMother;
  List<String> motherKeys = [];
  late String selectedMotherKey = '';

  List<String> bodyTypeList = [];
  late int selectedBodyTypeIndex = 1;

  List<String> complexionList = [];
  late int selectedComplexionTypeIndex = 1;

  bool contactList = false;
  bool isLiked = false;
  Color iconColor = Colors.white;

  @override
  void initState() {
    super.initState();
    setState(() {
      profileViewApi();
      getSharedPrefValue();
    });
  }

  getSharedPrefValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final stringValue = prefs.getString('globalApiData');
    if (stringValue != null) {
      Map<String, dynamic> jsonMap = jsonDecode(stringValue);

      GlobalValueModel profileData = GlobalValueModel.fromJson(jsonMap);
      allGetGlobalValue.add(profileData);

      Map<String, dynamic> responseData = json.decode(stringValue);

      Map<String, dynamic> heightLists = responseData['data']['height_list'];
      heightLists.forEach((key, value) {
        heightList.add(value as String);
        heightKeys.add(key as String);
      });

      Map<String, dynamic> genderLists = responseData['data']['gender_list'];
      genderLists.forEach((key, value) {
        genderList.add(value as String);
        genderKeys.add(key as String);
      });

      Map<String, dynamic> dietLists = responseData['data']['diet_list'];
      dietLists.forEach((key, value) {
        dietList.add(value as String);
        dietKeys.add(key as String);
      });

      Map<String, dynamic> bloodLists =
          responseData['data']['blood_group_list'];
      bloodLists.forEach((key, value) {
        bloodGroupList.add(value as String);
        bloodKeys.add(key as String);
      });

      Map<String, dynamic> maritalLists =
          responseData['data']['maritalstatus_list'];
      maritalLists.forEach((key, value) {
        maritalStatusList.add(value as String);
        maritalKeys.add(key as String);
      });

      Map<String, dynamic> religionLists =
          responseData['data']['religion_list'];
      religionLists.forEach((key, value) {
        religionList.add(value as String);
        religionKeys.add(key as String);
      });

      Map<String, dynamic> fatherLists =
          responseData['data']['fatherstatus_list'];
      fatherLists.forEach((key, value) {
        fatherList.add(value as String);
        fatherKeys.add(key as String);
      });

      Map<String, dynamic> motherLists =
          responseData['data']['motherstatus_list'];
      motherLists.forEach((key, value) {
        motherList.add(value as String);
        motherKeys.add(key as String);
      });

      complexionList = profileData.data!.complexionList!.toList();
      bodyTypeList = profileData.data!.bodytypeList!.toList();
    }
    return stringValue;
  }

  Future<void> profileViewApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('accessToken') ?? "null";
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse('${Webservices.baseUrl+Webservices.profileDetail+widget.profileId.toString()}');
    print("url~~${url}");
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $userToken',
    });

    if (response.statusCode == 200) {
      setState(() {
        var jsonList = jsonDecode(response.body) as Map<String, dynamic>;
        print("jsonList$jsonList");
        final localPickData = ProfileDetailModel.fromJson(jsonList);
        print("localPickData${localPickData}");

        alGetProfileDetail.add(localPickData);

        int profileHeightIndex =
            heightKeys.indexOf(alGetProfileDetail[0].data!.height.toString());
        if (profileHeightIndex != -1 &&
            profileHeightIndex < heightList.length) {
          _selectedHeight = heightList[profileHeightIndex];
          selectedKey = alGetProfileDetail[0].data!.height.toString();
        }

        int profileGenderIndex =
            genderKeys.indexOf(alGetProfileDetail[0].data!.gender.toString());
        if (profileGenderIndex != -1 &&
            profileGenderIndex < genderList.length) {
          _selectedGender = genderList[profileGenderIndex];
          selectedGenderKey = alGetProfileDetail[0].data!.gender.toString();
        }

        int profileDietIndex =
            dietKeys.indexOf(alGetProfileDetail[0].data!.diet.toString());
        if (profileDietIndex != -1 && profileDietIndex < dietList.length) {
          _selectedDiet = dietList[profileDietIndex];
          selectedDietKey = alGetProfileDetail[0].data!.diet.toString();
        }

        int profileBloodIndex = bloodKeys
            .indexOf(alGetProfileDetail[0].data!.bloodGroup.toString());
        if (profileBloodIndex != -1 &&
            profileBloodIndex < bloodGroupList.length) {
          _selectedBlood = bloodGroupList[profileBloodIndex];
          selectedBloodKey = alGetProfileDetail[0].data!.bloodGroup.toString();
        }

        int profileMaritalIndex = maritalKeys
            .indexOf(alGetProfileDetail[0].data!.maritalStatus.toString());
        if (profileMaritalIndex != -1 &&
            profileMaritalIndex < maritalStatusList.length) {
          _selectedMarital = maritalStatusList[profileMaritalIndex];
          selectedMaritalKey =
              alGetProfileDetail[0].data!.maritalStatus.toString();
        }

        int profileReligionIndex = religionKeys
            .indexOf(alGetProfileDetail[0].data!.religionId.toString());
        if (profileReligionIndex != -1 &&
            profileReligionIndex < religionList.length) {
          _selectedReligion = religionList[profileReligionIndex];
          selectedReligionKey =
              alGetProfileDetail[0].data!.religionId.toString();
        }

        int profileFatherIndex = fatherKeys
            .indexOf(alGetProfileDetail[0].data!.fathersStatus.toString());
        if (profileFatherIndex != -1 &&
            profileFatherIndex < fatherList.length) {
          _selectedFather = fatherList[profileFatherIndex];
          selectedFatherKey =
              alGetProfileDetail[0].data!.fathersStatus.toString();
        }

        int profileMotherIndex = fatherKeys
            .indexOf(alGetProfileDetail[0].data!.mothersStatus.toString());
        if (profileMotherIndex != -1 &&
            profileMotherIndex < motherList.length) {
          _selectedMother = motherList[profileMotherIndex];
          selectedMotherKey =
              alGetProfileDetail[0].data!.mothersStatus.toString();
        }

        selectedComplexionTypeIndex = alGetProfileDetail[0].data!.complexion!;
        selectedBodyTypeIndex = alGetProfileDetail[0].data!.bodyType!;
        final wishList = alGetProfileDetail[0].data!.favorite!;
        isLiked = wishList == "yes";
        iconColor = isLiked ? AppColor.red : AppColor.buttonColor;

        _isLoading = false;

        for (var pro in alGetProfileDetail[0].data?.profileImages ?? []) {
          profileImages.add(pro);
        }
      });
    } else {
      throw Exception('Failed to load education_list');
    }
  }

  Future<dynamic> postFavoriteAddApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('accessToken') ?? "null";

    var url = Uri.parse(
        '${Webservices.baseUrl+Webservices.addFavoriteApi}');
    print("url~~${url}");

    var jsonData = json.encode({
      'favorite_id': '${widget.profileId}',
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
      print("response~~~~~${response}");
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final userMap = json.decode(response.body);

        print("response~~~~^^^^${userMap}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${alGetProfileDetail[0].data!.firstName} is successfully Added to Shortlisted"),
          backgroundColor: AppColor.lightGreen,
        ));
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${response}"),
            backgroundColor: Colors.redAccent,
          ));
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<dynamic> postFavoriteRemoveApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('accessToken') ?? "null";
    var url = Uri.parse( '${Webservices.baseUrl+Webservices.removeFavoriteApi}');

    print("url~~${url}");

    var jsonData = json.encode({
      'favorite_id': '${widget.profileId}',
      //Login User Id~~~
      // 'profile_id': '${widget.profileId}',
      // Open to Detail Page for Favorite TO ADD ID~~
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
              "${alGetProfileDetail[0].data!.firstName} is successfully Remove from Favorite Shortlisted"),
          backgroundColor: AppColor.snackBarColor,
        ));
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${response}"),
            backgroundColor: Colors.redAccent,
          ));
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<dynamic> postViewContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('accessToken') ?? "null";

    var url = Uri.parse('${Webservices.baseUrl+Webservices.viewContacts}');
    print("url~~${url}");

    var jsonData = json.encode({
      'viewed_profile_id': '${widget.profileId}',
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
      print("response~~~~~${response}");
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final userMap = json.decode(response.body);

        print("response~~~~^^^^${userMap}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${alGetProfileDetail[0].data!.firstName} is successfully Added to Contact"),
          backgroundColor: AppColor.lightGreen,
        ));
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${response}"),
            backgroundColor: Colors.redAccent,
          ));
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait = screenHeight > screenWidth;

    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Color.fromARGB(255, 255, 241, 241),
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 12,
        backgroundColor: Color.fromARGB(255, 248, 205, 206),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Center(
          child: Text(
            "Profile Details",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isLiked) {
                  postFavoriteRemoveApi();
                } else {
                  postFavoriteAddApi();
                }
                isLiked = !isLiked;
                iconColor = isLiked ? AppColor.red : AppColor.buttonColor;
              });
            },
            icon: Icon(Icons.favorite, color: iconColor
                // color: isLiked ? AppColor.red : AppColor.buttonColor,
                ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    postViewContacts();
                  });
                },
                icon: Icon(
                  Icons.contact_phone_sharp,
                  color:
                      contactList ? AppColor.darkGreen : AppColor.buttonColor,
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(1),
            child: IconButton(
                onPressed: () {
                  setState(() {

                  });
                },
                icon: Icon(
                  Icons.block,
                  color:
                  contactList ? AppColor.darkGreen : AppColor.buttonColor,
                )),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                "assets/images/bg_pink.jpg",
              ),
              fit: BoxFit.cover),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColor.white,
                  // backgroundColor: AppColor.pink,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10, left: 10),
                      height: 690,
                      child: Swiper(
                        // viewportFraction: 2,
                        pagination: SwiperPagination(),
                        index: 1,
                        // scale: 0.8,
                        scrollDirection: Axis.horizontal,
                        itemCount: profileImages.length,
                        autoplay: true,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              // color: Colors.deepOrange,
                              shape: BoxShape.rectangle,
                              image: DecorationImage(
                                  image: profileImages.isEmpty
                                      ? NetworkImage(
                                          "https://cdn.pixabay.com/photo/2024/02/15/13/52/students-8575444_1280.png")
                                      : NetworkImage(
                                          "https://matrimonial.icommunetech.com/public/icommunetech/profiles/images/" +
                                              "${profileImages[index].imageName}",
                                        )),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                        "${alGetProfileDetail[0].data?.firstName}" +
                            " ${alGetProfileDetail[0].data?.lastName}",
                        style: AppTheme.nameText()),
                    SizedBox(
                      height: 9,
                    ),
                    Container(
                      // height: MediaQuery.of(context).size.height *0.7,//* 0.6
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: alGetProfileDetail.length,
                        itemBuilder: (context, index) {
                          var profile = alGetProfileDetail[index];
                          return Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(3),
                            child: Card(
                              color: Color.fromARGB(255, 245, 245, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  width: 3,
                                  color: Colors.transparent,
                                ),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "    Basic Detail",
                                    style: AppTheme.profileText(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Divider(
                                      height: 0,
                                      thickness: 0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  _buildProfileDetailRow(
                                      'Name',
                                      "${profile.data!.firstName}" +
                                          " ${profile.data!.lastName}"),
                                  _buildProfileDetailRow(
                                      'Age', "${profile.data!.age}" + " Yrs"),
                                  _buildProfileDetailRow(
                                      'Height', "${_selectedHeight}" + " "),
                                  _buildProfileDetailRow('Weight',
                                      "${profile.data!.weight}" + " Kgs"),
                                  _buildProfileDetailRow(
                                      'Gender', "${_selectedGender}" + " "),
                                  _buildProfileDetailRow('Body Type',
                                      "${selectedBodyTypeIndex != -1 ? bodyTypeList[selectedBodyTypeIndex] : null}"),
                                  _buildProfileDetailRow('Complexion',
                                      "${selectedComplexionTypeIndex != -1 ? complexionList[selectedComplexionTypeIndex] : null}"),
                                  _buildProfileDetailRow(
                                      'Diet', "${_selectedDiet}"),
                                  _buildProfileDetailRow(
                                      'Blood Group', "$_selectedBlood"),
                                  _buildProfileDetailRow(
                                      'Marital Status', "${_selectedMarital}"),
                                  if (_selectedMarital != "Never Married")
                                    _buildProfileDetailRow('Have Children',
                                        "${profile.data!.havechildren}"),
                                  if (profile.data!.havechildren != "No")
                                    _buildProfileDetailRow('No Of Children',
                                        "${profile.data!.noOfChildren}"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    /* Contact Details.....*/

                    Visibility(
                      visible: contactList,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.18,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: alGetProfileDetail.length,
                          itemBuilder: (context, index) {
                            var profile = alGetProfileDetail[index];
                            return Container(
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(3),
                              child: Card(
                                color: Color.fromARGB(255, 245, 245, 245),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  side: BorderSide(
                                    width: 3,
                                    color: Colors.transparent,
                                  ),
                                ),
                                elevation: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "   Contact Detail",
                                      style: AppTheme.profileText(),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Divider(
                                        height: 0,
                                        thickness: 0,
                                        color: Colors.black,
                                      ),
                                    ),
                                    _buildProfileDetailRow(
                                      'Mobile No',
                                      "${profile.data!.mobileNo}",
                                    ),
                                    _buildProfileDetailRow(
                                      'Alt Phone',
                                      "${profile.data!.altPhone}",
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: alGetProfileDetail.length,
                        itemBuilder: (context, index) {
                          var profile = alGetProfileDetail[index];
                          return Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(3),
                            child: Card(
                              color: Color.fromARGB(255, 245, 245, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  width: 3,
                                  color: Colors.transparent,
                                ),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "   Location Detail",
                                    style: AppTheme.profileText(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Divider(
                                      height: 0,
                                      thickness: 0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  _buildProfileDetailRow(
                                    'Address',
                                    "${profile.data!.address1}",
                                  ),
                                  _buildProfileDetailRow(
                                    'City',
                                    "${profile.data!.city}",
                                  ),
                                  _buildProfileDetailRow(
                                      'State', "${profile.data!.state}"),
                                  _buildProfileDetailRow('Country',
                                      "${profile.data!.countryId?.countryName}"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.18,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: alGetProfileDetail.length,
                        itemBuilder: (context, index) {
                          var profile = alGetProfileDetail[index];
                          return Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(3),
                            child: Card(
                              color: Color.fromARGB(255, 245, 245, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  width: 3,
                                  color: Colors.transparent,
                                ),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "    Religion Detail",
                                    style: AppTheme.profileText(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Divider(
                                      height: 0,
                                      thickness: 0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  _buildProfileDetailRow(
                                      'Religion', "${_selectedReligion}"),
                                  _buildProfileDetailRow(
                                    'Cast / Sub Caste',
                                    "${profile.data!.subcaste}",
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: alGetProfileDetail.length,
                        itemBuilder: (context, index) {
                          var profile = alGetProfileDetail[index];
                          return Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(3),
                            child: Card(
                              color: Color.fromARGB(255, 245, 245, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  width: 3,
                                  color: Colors.transparent,
                                ),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "    Professional Detail",
                                    style: AppTheme.profileText(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Divider(
                                      height: 0,
                                      thickness: 0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  _buildProfileDetailRow(
                                      'Education',
                                      "${profile.data!.educationId?.education}" +
                                          " "),
                                  _buildProfileDetailRow(
                                      'Profession',
                                      "${profile.data!.professionId?.occupation}" +
                                          " "),
                                  _buildProfileDetailRow(
                                      'Annual Income',
                                      "Rs ${profile.data!.incomeFrom}" +
                                          " to ${profile.data!.incomeTo} "),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        // physics: AlwaysScrollableScrollPhysics(),
                        itemCount: alGetProfileDetail.length,
                        itemBuilder: (context, index) {
                          var profile = alGetProfileDetail[index];
                          return Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(3),
                            child: Card(
                              color: Color.fromARGB(255, 245, 245, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: BorderSide(
                                  width: 3,
                                  color: Colors.transparent,
                                ),
                              ),
                              elevation: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "    Family Detail",
                                    style: AppTheme.profileText(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Divider(
                                      height: 0,
                                      thickness: 0,
                                      color: Colors.black,
                                    ),
                                  ),
                                  _buildProfileDetailRow('Contact Person',
                                      "${profile.data!.contactPerson}"),
                                  _buildProfileDetailRow(
                                      'Fathers status', "${_selectedFather}"),
                                  _buildProfileDetailRow(
                                      'Mothers status', "${_selectedMother}"),
                                  _buildProfileDetailRow('Convenient time',
                                      "${profile.data!.convenientTime}"),
                                  _buildProfileDetailRow('No of Brothers',
                                      "${profile.data!.noOfBrothers}"),
                                  _buildProfileDetailRow(
                                    'No of Sisters',
                                    "${profile.data!.noOfSisters}",
                                  ),
                                  _buildProfileDetailRow('Native place',
                                      "${profile.data!.nativePlace}"),
                                  _buildProfileDetailRow('About my Family',
                                      "${profile.data!.aboutMyFamily}"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: AppTheme.profileTexts(),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              ":",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: AppTheme.profileDetail(),
            ),
          ),
        ],
      ),
    );
  }
}
