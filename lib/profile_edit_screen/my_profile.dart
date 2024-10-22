import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/blocked_profile/model_class/ContactAddModel.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/global_value_model.dart';
import 'package:matrimony/profile_edit_screen/image_edit_screen.dart';
import 'package:matrimony/profile_edit_screen/profile_edit_screen.dart';
import 'package:matrimony/profile_edit_screen/view_model/profile_detail_model.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class MyProfileScreen extends StatefulWidget {
  final profileId;
  final profileFullName;

  MyProfileScreen({
    Key? key,
    required this.profileId,
    required this.profileFullName,
  }) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileDetailPageState();
}

class _MyProfileDetailPageState extends State<MyProfileScreen> {
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
  Color iconColor = Colors.white;
  bool isBlock = false;
  Color blockColor = Colors.white;

  bool aboutMySelf = false;
  bool isExpanded = false;
  late var connection = "";
  late var loginId = "";
  var profileImg = "";
  var rishtaId;
  bool genderMatch = false;
  late final TextEditingController fNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      profileDetailApi();
      getSharedPrefValue();
    });
  }

  Future<void> getSharedPrefValue() async {
    final url = Uri.parse('${Webservices.baseUrl+Webservices.globalValue}');
    final response = await http.get(url);
    print("url~~${url}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final localPickData = GlobalValueModel.fromJson(responseData);
      allGetGlobalValue.add(localPickData);
      Map<String, dynamic> heightLists = responseData['data']['height_list'];
      heightLists.forEach((key, value) {
        heightList.add(value as String);
        heightKeys.add(key as String);
      });

      Map<String, dynamic> dietLists = responseData['data']['diet_list'];
      dietLists.forEach((key, value) {
        dietList.add(value as String);
        dietKeys.add(key as String);
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

      complexionList = localPickData.data!.complexionList!.toList();
      bodyTypeList = localPickData.data!.bodytypeList!.toList();

    } else {
      throw Exception('Failed to load income options');
    }
  }
  Future<void> profileDetailApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    final userName = prefs.getString(PrefKeys.KEYGENDER)!;

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
        if (localPickData.status == true) {
          int profileHeightIndex =
              heightKeys.indexOf(alGetProfileDetail[0].data!.height.toString());
          if (profileHeightIndex != -1 &&
              profileHeightIndex < heightList.length) {
            _selectedHeight = heightList[profileHeightIndex];
            selectedKey = alGetProfileDetail[0].data!.height.toString();
          }

          int profileDietIndex =
              dietKeys.indexOf(alGetProfileDetail[0].data!.diet.toString());
          if (profileDietIndex != -1 && profileDietIndex < dietList.length) {
            _selectedDiet = dietList[profileDietIndex];
            selectedDietKey = alGetProfileDetail[0].data!.diet.toString();
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

          selectedComplexionTypeIndex =
              alGetProfileDetail[0].data!.complexion ?? 1;
          selectedBodyTypeIndex = alGetProfileDetail[0].data!.bodyType ?? 1;

          final wishList = alGetProfileDetail[0].data!.favorite!;
          isLiked = wishList == "yes";
          iconColor = isLiked ? AppColor.red : AppColor.buttonColor;

          final blockList = alGetProfileDetail[0].data!.block!;
          isBlock = blockList == "yes";
          blockColor = isBlock ? AppColor.red : AppColor.buttonColor;

          connection = alGetProfileDetail[0].data!.connectionSent!;
          rishtaId = alGetProfileDetail[0].data!.profileID!;

          if (alGetProfileDetail[0].data!.gender == 1) {
            profileImg =
                "https://rishtaforyou.com/storage/profiles/default1.png";
          } else {
            profileImg =
                "https://rishtaforyou.com/storage/profiles/default2.png";
          }
          final about =alGetProfileDetail[0].data?.aboutMyFamily;
          if(about.isNull){
            aboutMySelf=false;
          }
          else{
            aboutMySelf=true;

          }
          final userGender = alGetProfileDetail[0]?.data?.gender ?? '';
          if (userName.toString() == userGender.toString()) {
            genderMatch = true;
          } else {
            genderMatch = false;
          }
          _isLoading = false;

          for (var pro in alGetProfileDetail[0].data?.profileImages ?? []) {
            profileImages.add(pro);
          }
        } else {
          _isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("${alGetProfileDetail[0].message}"),
            backgroundColor: AppColor.lightGreen,
          ));
        }
      });
    } else {
      throw Exception('Failed to load Profile Detail');
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

    // String cleanedLoginId = loginId;
    // String cleanedProfileId = widget.profileId.toString();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          // cleanedProfileId == cleanedLoginId
               Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileEditScreen();
                          },
                        ));
                      },
                      icon: Icon(Icons.mode_edit_rounded,
                          color: AppColor.mainText),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return ImageEditScreen();
                        },));
                      },
                      icon: Icon(Icons.photo_camera_rounded,
                          color: AppColor.mainText),
                    ),
                  ],
                )
              // : Container(),
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
        leading:IconButton(
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                icon: const Icon(Icons.menu, color: Colors.black),
        )
      ),
      drawer: SideDrawer() ,
      body: Container(
        color: AppColor.mainAppColor,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColor.mainText,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (profileImages.isNotEmpty)
                      Container(
                        height: screenSize * 0.6,
                        padding:
                            EdgeInsets.symmetric(horizontal: 13, vertical: 12),
                        child: Swiper(
                          pagination:
                              SwiperPagination(margin: EdgeInsets.all(1)),
                          index: 1,
                          curve: Curves.decelerate,
                          scrollDirection: Axis.horizontal,
                          itemCount: profileImages.length,
                          autoplay: true,
                          itemBuilder: (context, index) {
                            return FutureBuilder<bool>(
                              future: checkImageExists(
                                  "${Webservices.imageUrl}${profileImages[index].imageName}"),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError ||
                                    !snapshot.data!) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(profileImg),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "${Webservices.imageUrl}${profileImages[index].imageName}"),
                                        fit: BoxFit.fill,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: screenSize * 0.08,
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text("Matrimonial Id : ${rishtaId ?? 0}",
                              style: AppTheme.matriId()),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        // if (!alGetProfileDetail[0].data!.goals.isNull)
                       if(aboutMySelf==true)
                        ...alGetProfileDetail
                              .map((profile) => _buildProfileCard(
                                    "About Myself",
                                    Text(
                                      profile.data!.aboutMyFamily ?? '',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        color: AppColor.profileText,
                                        fontSize: 14,
                                        fontFamily: FontName.poppinsRegular,
                                      ),
                                    ),
                                  )),
                        ...alGetProfileDetail.map((profile) =>
                            _buildProfileCard(
                              "Basic Detail",
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProfileDetailRow('Name',
                                      "${profile.data!.firstName ?? ''} ${profile.data!.lastName ?? ''}"),
                                  _buildProfileDetailRow('Age',
                                      "${profile.data!.age ?? ''} Years"),
                                  _buildProfileDetailRow(
                                      'Height', "${_selectedHeight ?? ''}"),
                                  _buildProfileDetailRow('Weight',
                                      "${profile.data!.weight ?? ''} Kgs"),
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
                                ],
                              ),
                            )),
                        ...alGetProfileDetail
                            .map((profile) => _buildProfileCard(
                                  "Contact Detail",
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildProfileDetailRow('Mobile No',
                                          "${profile.data!.mobileNo ?? ' '}"),
                                      _buildProfileDetailRow('Alt Phone',
                                          "${profile.data!.altPhone ?? ' '}"),
                                    ],
                                  ),
                                )),
                        ...alGetProfileDetail
                            .map((profile) => _buildProfileCard(
                                "Location Detail",
                                Column(
                                  children: [
                                    _buildProfileDetailRow(
                                            'Address',
                                            "${profile.data!.address1 ?? ''}",
                                          ),
                                    _buildProfileDetailRow(
                                      'City',
                                      "${profile.data!.city ?? ''}",
                                    ),
                                    _buildProfileDetailRow('State',
                                        "${profile.data!.state ?? ''}"),
                                    _buildProfileDetailRow('Country',
                                        "${profile.data!.countryId?.countryName ?? ''}"),
                                  ],
                                ))),

                        ...alGetProfileDetail
                            .map((profile) => _buildProfileCard(
                                "Religion Detail",
                                Column(
                                  children: [
                                    _buildProfileDetailRow('Religion',
                                        "${_selectedReligion ?? ' '}"),
                                    _buildProfileDetailRow('Cast / Sub Caste',
                                        "${profile.data!.subcaste ?? ' '}"),
                                  ],
                                ))),
                        ...alGetProfileDetail
                            .map((profile) => _buildProfileCard(
                                  "Professional Detail",
                                  Column(
                                    children: [
                                      _buildProfileDetailRow('Education',
                                          "${profile.data!.educationId?.education ?? ''}"),
                                      _buildProfileDetailRow('Profession',
                                          "${profile.data!.professionId?.occupation ?? ''}"),
                                      _buildProfileDetailRow(
                                          'Annual Income',
                                          "Rs ${profile.data!.incomeFrom ?? ''}" +
                                              " to ${profile.data!.incomeTo ?? ''} "),
                                    ],
                                  ),
                                )),
                        ...alGetProfileDetail
                            .map((profile) => _buildProfileCard(
                                "Family Detail",
                                Column(
                                  children: [
                                    _buildProfileDetailRow('Contact Person',
                                        "${profile.data!.contactPerson ?? ''}"),
                                    _buildProfileDetailRow('Fathers status',
                                        "${_selectedFather ?? ''}"),
                                    _buildProfileDetailRow('Mothers status',
                                        "${_selectedMother ?? ''}"),
                                   _buildProfileDetailRow(
                                            'Convenient time',
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
                                ))),
                        Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        backgroundColor:
                                            Color.fromARGB(255, 126, 143, 130),
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
                        SizedBox(
                          height: 66,
                        )
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileCard(String title, Widget content) {
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "  $title",
                style: TextStyle(
                  color: AppColor.mainText,
                  fontSize: 16,
                  fontFamily: FontName.poppinsRegular,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Divider(
                height: 1,
                thickness: 1,
                color: AppColor.profileDetailLine,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: content,
            ),
          ],
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
              style: AppTheme.profileDetail(),
            ),
          ),
        ],
      ),
    );
  }
}
