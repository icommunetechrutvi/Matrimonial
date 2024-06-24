import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/ContactAddModel.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/global_value_model.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/profile_edit_screen/image_edit_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_edit_screen.dart';
import 'package:matrimony/profile_edit_screen/view_model/profile_detail_model.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailScreen extends StatefulWidget {
  final profileId;
  final profileFullName;


  ProfileDetailScreen({
    Key? key,
    required this.profileId,
    required this.profileFullName,
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

  bool isLiked = false;
  bool isBlock = false;

  late var contact = "";
  bool isApiCallInProgress = false;
  bool isExpanded = false;
  late var loginId ="";
  var profileImg ="";
  bool genderMatch =false;
  var rishtaId;

  var shortListColor=AppColor.profileEditTabText;
  var connectionListColor=AppColor.profileEditTabText;
  var contactListColor=AppColor.profileEditTabText;
  var blockListColor=AppColor.profileEditTabText;



  @override
  void initState() {
    super.initState();
    setState(() {
      profileDetailApi();
      getSharedPrefValue();
      print("~~~~${widget.profileId}");
    });
  }

  getSharedPrefValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginId = prefs.getString(PrefKeys.KEYPROFILEID)!;
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

  Future<void> profileDetailApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    final userName  = prefs.getString(PrefKeys.KEYGENDER)!;
    print("ACCESSTOKEN~~~${userToken}");
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        '${Webservices.baseUrl + Webservices.profileDetail + widget.profileId.toString()}');
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
        if(alGetProfileDetail[0].data!.gender ==1){
          profileImg="https://rishtaforyou.com/storage/profiles/default1.png";
        }
        else{
          profileImg="https://rishtaforyou.com/storage/profiles/default2.png";
        }
        final userGender = alGetProfileDetail[0]?.data?.gender ?? '';
        if(userName.toString()==userGender.toString())
        {
          genderMatch=true;
        }
        else{
          genderMatch=false;
        }
        rishtaId=alGetProfileDetail[0].data!.profileID!;
        selectedComplexionTypeIndex = alGetProfileDetail[0].data!.complexion ??1;
        selectedBodyTypeIndex = alGetProfileDetail[0].data!.bodyType ?? 1;
        final wishList = alGetProfileDetail[0].data!.favorite!;
        isLiked = wishList == "yes";
        shortListColor = isLiked ? AppColor.mainText : AppColor.profileEditTabText;

        final blockList = alGetProfileDetail[0].data!.block!;
        isBlock = blockList == "yes";
        blockListColor = isBlock ? AppColor.mainText : AppColor.profileEditTabText;

        contact = alGetProfileDetail[0].data!.viewContact!;
        contactListColor=contact=="yes"?AppColor.mainText : AppColor.profileEditTabText;
        var con = alGetProfileDetail[0].data!.connectionSent!;
        connectionListColor= con=="yes"? AppColor.mainText : AppColor.profileEditTabText;
        _isLoading = false;

        for (var pro in alGetProfileDetail[0].data?.profileImages ?? []) {
          profileImages.add(pro);
        }
      });
    } else {
      throw Exception('Failed to load Profile Detail');
    }
  }

  Future<dynamic> postFavoriteAddApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";

    var url = Uri.parse('${Webservices.baseUrl + Webservices.addFavoriteApi}');
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
        // String message = userMap["message"] ??
        //     "null";
        print("response~~~~^^^^${userMap}");
        responseDialog("is successfully Added to Shortlisted.","Short List",context);
       /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${alGetProfileDetail[0].data!.firstName} is successfully Added to Shortlisted"),
          backgroundColor: AppColor.lightGreen,
        ));*/
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Token is Expire!! Please Login Again"),
          backgroundColor: AppColor.red,
        ));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ));
      }  else {
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
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    var url =
        Uri.parse('${Webservices.baseUrl + Webservices.removeFavoriteApi}');

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
        responseDialog("is successfully Remove from Favorite Shortlisted.","Short List",context);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text(
        //       "${alGetProfileDetail[0].data!.firstName} is successfully Remove from Favorite Shortlisted"),
        //   backgroundColor: AppColor.snackBarColor,
        // ));
      } else if (response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Token is Expire!! Please Login Again"),
          backgroundColor: AppColor.red,
        ));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ));
      }  else {
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

  Future<dynamic> postBlockAddApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";

    var url =
        Uri.parse('${Webservices.baseUrl + Webservices.addProfileBlockApi}');
    print("url~~${url}");

    var jsonData = json.encode({
      'blocked_profile_id': '${widget.profileId}',
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
        responseDialog("is successfully Member has been blocked.","Block",context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${alGetProfileDetail[0].data!.firstName} is successfully Member has been blocked."),
          backgroundColor: AppColor.red,
        ));
      } else {
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${response}"),
            backgroundColor: Colors.red,
          ));
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<dynamic> postBlockRemoveApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    var url =
        Uri.parse('${Webservices.baseUrl + Webservices.removeProfileBlockApi}');

    print("url~~${url}");

    var jsonData = json.encode({
      'blocked_profile_id': '${widget.profileId}',
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
        responseDialog("is successfully Member has been unblocked.","Block",context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${alGetProfileDetail[0].data!.firstName}is successfully Member has been unblocked."),
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

  Future<dynamic> postAddContactsApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";

    var url = Uri.parse('${Webservices.baseUrl + Webservices.viewContacts}');
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
        responseDialog("is successfully Added to Contact.","Contact",context);
      /*  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "${alGetProfileDetail[0].data!.firstName} is successfully Added to Contact"),
          backgroundColor: AppColor.lightGreen,
        ));*/
        setState(() {
          isApiCallInProgress = true;
        });
      } else if (response.statusCode == 500) {
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
          contactDialog(context);
          // responseDialog("View contact already exists for this profile.","Contact",context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${alGetProfileDetail[0].data!.firstName} View contact already exists for this profile."),
            backgroundColor: Colors.red,
          ));
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<dynamic> postAddConnectionApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";

    var url =
        Uri.parse('${Webservices.baseUrl + Webservices.addConnectionRequest}');
    print("url~~${url}");

    var jsonData = json.encode({
      'receiver_id': '${widget.profileId}',
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
        responseDialog("Connection request sent Successfully.","Connection Request",context);
        print("response~~~~^^^^${userMap}");
        connectionListColor=AppColor.mainText;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Connection request sent Successfully"),
          backgroundColor: AppColor.lightGreen,
        ));
        setState(() {
          isApiCallInProgress = true;
        });
      } else if (response.statusCode == 400) {
        responseDialog("Connection request already Send.","Connection Request",context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              const Text("Connection request already Send for this profile"),
          backgroundColor: AppColor.red,
        ));
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "${alGetProfileDetail[0].data!.firstName} Connection request already Send for this profile"),
            backgroundColor: Colors.red,
          ));
        });
        throw Exception('Failed to load data');
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
    final screenSize = MediaQuery.of(context).size.height;

    String cleanedLoginId = loginId;
    String cleanedProfileId = widget.profileId.toString();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          cleanedProfileId == cleanedLoginId?
          Row(children: [
            IconButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileEditScreen();
                  },
                ));/*, (route) => false)*/
              },
              icon:  Icon(Icons.mode_edit_rounded, color: AppColor.mainText),
            ),
            IconButton(
              onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ImageEditScreen();
              },));
              },
              icon: Icon(Icons.photo_camera_rounded, color: AppColor.mainText),
            )
          ],):Container(
            padding: EdgeInsets.only(right: 8.0),
          child:  Center(
            child: Text(
              textAlign: TextAlign.center,
                "Matrimonial Id: ${rishtaId ?? 0}",
                style: AppTheme.matriId()),
          ),
          )
        ],
        backgroundColor: AppColor.white,
        title: Text(
          "Profile Detail",
          style: TextStyle(
            fontSize: 16,
            color: AppColor.black,
            fontWeight: FontWeight.bold,
            fontFamily: FontName.poppinsRegular,
          ),
        ),
        leading:cleanedProfileId == cleanedLoginId?
        IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu, color: Colors.black),
        ):IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image(
              image: AssetImage("assets/icon/back_app_bar.png"),
              height: screenHeight * 0.02),
        ),
      ),
      drawer:cleanedProfileId == cleanedLoginId? SideDrawer():Container(),
      body: Container(
        color: AppColor.mainAppColor,
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: AppColor.white,
            // backgroundColor: AppColor.pink,
          ),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 7,
              ),
              profileImages.isEmpty
                  ? Container()
                  : Container(
                height: screenSize * 0.6,
                padding: EdgeInsets.symmetric(
                    horizontal: 13, vertical: 12),
                // padding: EdgeInsets.only(right: 10, left: 10),
                child: Swiper(
                  pagination: SwiperPagination(margin: EdgeInsets.all(1)),
                  index: 1,
                  curve: Curves.decelerate,
                  // scale: 0.9,
                  scrollDirection: Axis.horizontal,
                  itemCount: profileImages.length,
                  autoplay: true,
                  itemBuilder: (context, index) {
                    return Container(
                      child: profileImages[index].imageName !=null ?
                      FutureBuilder<bool>(
                        future: checkImageExists("${Webservices.imageUrl}${profileImages[index].imageName}"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(
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
                                  bottomRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage("${Webservices.imageUrl}${profileImages[index].imageName}"),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            );
                          }
                        },
                      )
                          : Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(profileImg),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),

              Container(
                height: screenSize*0.08,
                color: AppColor.white,
                padding: EdgeInsets.only(left: 12, right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        "${widget.profileFullName}",
                        style: TextStyle(
                          color: AppColor.mainText,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: FontName.poppinsRegular,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        cleanedProfileId == cleanedLoginId || genderMatch==true
                            ? Container(): Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50,),color:shortListColor),
                          child: IconButton(
                          onPressed: () {
                              setState(() {
                                dialogs("Add Shortlist","1");
                                // if (isLiked) {
                                //   postFavoriteRemoveApi();
                                // } else {
                                //   postFavoriteAddApi();
                                // }
                                // isLiked = !isLiked;
                              });
                          },
                          icon: Icon(Icons.favorite,color:AppColor.white,
                          ),
                        ),
                            ),

                        SizedBox(width: 5,),
                        /* connection == "yes"*/  cleanedProfileId == cleanedLoginId || genderMatch==true
                            ? Container()
                            : Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50,),color: connectionListColor),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                // postAddConnectionApi();
                                dialogs("Add Connection Request","2");
                              });
                            },
                            icon: Icon(Icons.person_add_alt_outlined,  color: AppColor.white,),
                          ),
                        )
                        ,
                        SizedBox(width: 5,),
                        /*  contact == "yes" ||*/ cleanedProfileId == cleanedLoginId || genderMatch==true
                            ? Container()
                            : Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50,),color: contactListColor),
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  setState(() {
                                    if(contact=="no") {
                                      dialogs("View Contact", "3");
                                    }else{
                                      contactDialog(context);
                                    }

                                    // postAddContactsApi();
                                  });
                                });
                              },
                              icon: Icon(Icons.wifi_calling_3_sharp,  color: AppColor.white,)),
                        ),
                        SizedBox(width: 5,),
                        cleanedProfileId == cleanedLoginId|| genderMatch==true?Container():  Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50,),color: blockListColor),
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                dialogs("Add Block","4");
                                // if (isBlock) {
                                //   postBlockRemoveApi();
                                // } else {
                                //   postBlockAddApi();
                                // }
                                // isBlock = !isBlock;
                                // blockColor =
                                // isBlock ? AppColor.red : AppColor.buttonColor;
                              });
                            },
                            icon: Icon(Icons.block,  color: AppColor.white,),),
                        )
                        // icon: cleanedProfileId == cleanedLoginId?Container(): Image(
                        //     image: AssetImage(
                        //         "assets/icon/profile_block.png"))),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: alGetProfileDetail.length,
                itemBuilder: (context, index) {
                  return   alGetProfileDetail[index].data!.aboutMyFamily.isNull ?Container(): Container(
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
                            "    About Myself",
                            style:TextStyle(
                                color:AppColor.mainText,
                                fontSize: 16,
                                fontFamily:  FontName.poppinsRegular,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Divider(
                                height: 0,
                                thickness: 0,
                                color: AppColor.profileDetailLine
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10,left: 10),
                            child: Text(
                              textAlign: TextAlign.justify,
                              "${alGetProfileDetail[index].data!.aboutMyFamily}",style: TextStyle(
                              color:AppColor.profileText,
                              fontSize: 14,
                              fontFamily:  FontName.poppinsRegular,
                            ),),
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
              ListView.builder(
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
                            style:TextStyle(
                                color:AppColor.mainText,
                                fontSize: 16,
                                fontFamily:  FontName.poppinsRegular,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Divider(
                              height: 0,
                              thickness: 0,
                              color:AppColor.profileDetailLine,
                            ),
                          ),
                          _buildProfileDetailRow(
                              'Name',
                              "${profile.data!.firstName ?? ''}" +
                                  " ${profile.data!.lastName ?? ''}"),
                          _buildProfileDetailRow('Age',
                              "${profile.data!.age ?? ''}" + " Years"),
                          _buildProfileDetailRow(
                              'Height', "${_selectedHeight ?? ''}"),
                          _buildProfileDetailRow('Weight',
                              "${profile.data!.weight ?? ''}" + " Kgs"),
                          _buildProfileDetailRow(
                              'Gender', "${_selectedGender ?? ''}"),
                          _buildProfileDetailRow('Body Type',
                              "${selectedBodyTypeIndex != -1 ? bodyTypeList[selectedBodyTypeIndex] : ""}"),
                          _buildProfileDetailRow('Complexion',
                              "${selectedComplexionTypeIndex != -1 ? complexionList[selectedComplexionTypeIndex] : ""}"),
                          _buildProfileDetailRow(
                              'Diet', "${_selectedDiet ?? ''}"),
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

              contact == "no"
                  ? Container()
                  : ListView.builder(
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
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 8,
                          ),
                          Text(
                            "   Contact Detail",
                            style: TextStyle(
                                color:AppColor.mainText,
                                fontSize: 16,
                                fontFamily:  FontName.poppinsRegular,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Divider(
                              height: 0,
                              thickness: 0,
                              color: AppColor.profileDetailLine,
                            ),
                          ),
                          _buildProfileDetailRow(
                            'Mobile No',
                            "${profile.data!.mobileNo ?? ''}",
                          ),
                          _buildProfileDetailRow(
                            'Alt Phone',
                            "${profile.data!.altPhone ?? ''}",
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

              ListView.builder(
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
                            "   Location Detail",
                            style: TextStyle(
                                color:AppColor.mainText,
                                fontSize: 16,
                                fontFamily:  FontName.poppinsRegular,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Divider(
                                height: 0,
                                thickness: 0,
                                color:AppColor.profileDetailLine
                            ),
                          ),
                          contact == "no"? Container():
                          _buildProfileDetailRow(
                            'Address',
                            "${profile.data!.address1 ?? ''}",
                          ),
                          _buildProfileDetailRow(
                            'City',
                            "${profile.data!.city ?? ''}",
                          ),
                          _buildProfileDetailRow(
                              'State', "${profile.data!.state ?? ''}"),
                          _buildProfileDetailRow('Country',
                              "${profile.data!.countryId?.countryName ?? ''}"),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
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
                            "    Religion Detail",
                            style: TextStyle(
                                color:AppColor.mainText,
                                fontSize: 16,
                                fontFamily:  FontName.poppinsRegular,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Divider(
                                height: 0,
                                thickness: 0,
                                color: AppColor.profileDetailLine
                            ),
                          ),
                          _buildProfileDetailRow(
                              'Religion', "${_selectedReligion ?? ''}"),
                          _buildProfileDetailRow(
                            'Cast / Sub Caste',
                            "${profile.data!.subcaste ?? ''}",
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
              ListView.builder(
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
                            "    Professional Detail",
                            style: TextStyle(
                                color:AppColor.mainText,
                                fontSize: 16,
                                fontFamily:  FontName.poppinsRegular,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Divider(
                                height: 0,
                                thickness: 0,
                                color: AppColor.profileDetailLine
                            ),
                          ),
                          _buildProfileDetailRow('Education',
                              "${profile.data!.educationId?.education ?? ''}"),
                          _buildProfileDetailRow('Profession',
                              "${profile.data!.professionId?.occupation ?? ''}"),
                          _buildProfileDetailRow(
                              'Annual Income',
                              "Rs ${profile.data!.incomeFrom ?? ''}" +
                                  " to ${profile.data!.incomeTo ?? ''} "),
                          SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
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
                            "    Family Detail",
                            style: TextStyle(
                                color:AppColor.mainText,
                                fontSize: 16,
                                fontFamily:  FontName.poppinsRegular,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Divider(
                                height: 0,
                                thickness: 0,
                                color: AppColor.profileDetailLine
                            ),
                          ),
                          _buildProfileDetailRow('Contact Person',
                              "${profile.data!.contactPerson ?? ''}"),
                          _buildProfileDetailRow('Fathers status',
                              "${_selectedFather ?? ''}"),
                          _buildProfileDetailRow('Mothers status',
                              "${_selectedMother ?? ''}"),
                          contact == "no"? Container():
                          _buildProfileDetailRow('Convenient time',
                              "${profile.data!.convenientTime ?? ''}"),
                          _buildProfileDetailRow('No of Brothers',
                              "${profile.data!.noOfBrothers}"),
                          _buildProfileDetailRow(
                            'No of Sisters',
                            "${profile.data!.noOfSisters}",
                          ),
                          _buildProfileDetailRow('Native place',
                              "${profile.data!.nativePlace ?? ''}"),
                          _buildProfileDetailRow('About my Family',
                              "${profile.data!.aboutMyFamily ?? ''}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 1),

              cleanedProfileId != cleanedLoginId
                  ? Container()
                  : Container(
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
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 18,
                        ),
                        Text('Current Plan',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800)),
                        SizedBox(
                          height: 18,
                        ),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Plan Name",
                                  style: AppTheme.profileText(),
                                ),
                                Text("Silver",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18)),
                              ],
                            ),
                            SizedBox(
                              width: 75,
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Validity",
                                  style: AppTheme.profileText(),
                                ),
                                const Text("365 Days",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Valid Till",
                              style: AppTheme.profileText(),
                            ),
                            const Text("4 February, 2025",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 18)),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 50.0,
                                  right: 50,
                                  top: 15,
                                  bottom: 12),
                              child: Text("Upgrade"),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5),
                              ),
                              backgroundColor: Color.fromARGB(
                                  255, 126, 143, 130),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 19,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }






  Widget _buildProfileDetailRow(
    String label,
    String value,
  ) {
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

  void dialogs(String textName,String apiClick){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Do you want to\n${textName} ?",maxLines: 3,style:
                    TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: AppColor.black,fontFamily: FontName.poppinsRegular),),
                  ),
                  IconButton(onPressed: () {Navigator.pop(context);  }, icon: Icon(Icons.close,color: AppColor.grey),),
                ],
              ),
            ],
          ),
          // content: ,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () async {
                      if(apiClick=="1"){
                        setState(() {
                          if (isLiked) {
                            postFavoriteRemoveApi();
                            shortListColor=AppColor.profileEditTabText;
                          } else {
                            postFavoriteAddApi();
                            shortListColor=AppColor.mainText;
                          }
                          isLiked = !isLiked;
                        });
                      }else if(apiClick=="2"){
                        setState(() {
                          postAddConnectionApi();
                          connectionListColor=AppColor.mainText;
                        });
                      }
                      else if(apiClick=="3"){
                        setState(() {
                          postAddContactsApi();
                          contactListColor=AppColor.mainText;
                        });
                      }
                      else if(apiClick=="4"){
                        setState(() {
                          if (isBlock) {
                            blockListColor=AppColor.profileEditTabText;
                            postBlockRemoveApi();
                          } else {
                            blockListColor=AppColor.mainText;
                            postBlockAddApi();
                          }
                          isBlock = !isBlock;
                        });
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text(
                              "Something want false"),
                          backgroundColor: AppColor.snackBarColor,
                        ));
                      }
                      // postAddContactsApi();
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Yes",
                      style: AppTheme.buttonBold(),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(left: 35,right: 35,top: 14,bottom: 14),
                        shape: RoundedRectangleBorder(side: BorderSide(width: 0,color: AppColor.mainText),
                          borderRadius: BorderRadius.circular(28,),
                        ),
                        backgroundColor:AppColor.mainText),
                  ),
                ),
                Container(
                  // margin: EdgeInsets.all(13),
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "No",
                      style: AppTheme.buttonBold(),
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(left: 35,right: 35,top: 14,bottom: 14),
                        shape: RoundedRectangleBorder(side: BorderSide(width: 0,color: AppColor.mainText),
                          borderRadius: BorderRadius.circular(28,),
                        ),
                        backgroundColor:AppColor.mainText),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void responseDialog(String massage,String title,BuildContext context){
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$title",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w300,color: AppColor.grey,fontFamily: FontName.poppinsRegular),),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close,color: AppColor.grey),
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Divider(height: 1,color: AppColor.grey,),
              SizedBox(height: 10,),
              Text("${alGetProfileDetail[0].data!.firstName} ${massage}",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600,color: AppColor.red,fontFamily: FontName.poppinsRegular),),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(13),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: AppTheme.buttonBold(),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(left: 35,right: 35,top: 14,bottom: 14),
                    shape: RoundedRectangleBorder(side: BorderSide(width: 0,color: AppColor.mainAppColor),
                      borderRadius: BorderRadius.circular(28,),
                    ),
                    backgroundColor:AppColor.mainText),
              ),
            ),
          ],
        );
      },
    );
  }

  void contactDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "View Contact",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: AppColor.profileEditTabText,
                      fontFamily: FontName.poppinsRegular,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close,color: AppColor.profileEditTabText),
                  ),
                ],
              ),
              Divider(color: AppColor.profileEditTabText,height: 1,),
              Text(
                maxLines: 2,
                "You have Viewed Contacts",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColor.mainText,
                  fontFamily: FontName.poppinsRegular,
                ),
              ),
              SizedBox(height: 8,),
              _buildText(
                  'Contact Person ', "${widget.profileFullName ?? ''}"),
              _buildText(
                  'Relation with Member ', "${alGetProfileDetail[0].data!.contactPerson ?? ''}"),
              _buildText(
                  'Mobile', "${alGetProfileDetail[0].data!.mobileNo ?? ''}"),
              _buildText(
                  'Alternative No.', "${alGetProfileDetail[0].data!.altPhone ?? ''}"),
              _buildText(
                  'Convenient Time to Call', "${alGetProfileDetail[0].data!.convenientTime ?? ''}"),
              _buildText(
                  'Email ID ', "${alGetProfileDetail[0].data!.emailId ?? ''}"),
              _buildText(
                  'Address : ', "${alGetProfileDetail[0].data!.address1 ?? ''}  ${alGetProfileDetail[0].data!.city ?? ""} ${alGetProfileDetail[0].data!.state} ${alGetProfileDetail[0].data!.countryId!.countryName}"),
              _buildText(
                  'Address2 ', "${alGetProfileDetail[0].data!.address2 ?? ''} ${alGetProfileDetail[0].data!.countryId!.countryName}"),
            ],
          ),
          actions: [
            Container(
              margin: EdgeInsets.all(13),
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: AppTheme.buttonBold(),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 35, right: 35, top: 14, bottom: 14),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 0, color: AppColor.mainText),
                    borderRadius: BorderRadius.circular(28,),
                  ),
                  backgroundColor: AppColor.mainText,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Widget _buildText(
      String label,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
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
              "-",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color:AppColor.black,
                  fontFamily: FontName.poppinsRegular
              ),
            ),
          ),
        ],
      ),
    );
  }
}
