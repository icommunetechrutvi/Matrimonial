import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/bottom_screet/view_model/country_model.dart';
import 'package:matrimony/bottom_screet/view_model/educations_model.dart';
import 'package:matrimony/bottom_screet/view_model/global_value_model.dart';
import 'package:matrimony/bottom_screet/view_model/occupation_model.dart';
import 'package:matrimony/bottom_screet/view_model/state_model.dart';
import 'package:matrimony/profile_screen/view_model/profile_detail_model.dart';
import 'package:matrimony/search_screen/search_screen.dart';
import 'package:matrimony/ui_screen/appBar_screen.dart';
import 'package:matrimony/ui_screen/side_drawer.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _MyProfileEditPageState();
}

class _MyProfileEditPageState extends State<ProfileEditScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  var isExpanded1 = false;
  var isExpanded2 = false;
  var isExpanded3 = false;


  List<ProfileDetailModel> alGetProfileDetail = [];
  List<ProfileImages> profileImages = [];
  List<GlobalValueModel> allGetGlobalValue = [];

  List<CountryData> countryList = [];
  CountryData? _selectedCountry;

  StateData? _selectState;
  List<StateData> stateList = [];

  String? _selectedHeight;
  List<String> heightList = [];
  List<String> heightKeys = [];
  late String selectedKey = '';

  String? _selectedComplexion;
  List<String> complexionList = [];
  late int complexionKey = 1;

  String? _selectedBodyType;
  List<String> bodyTypeList = [];
  late int bodyTypeKey = 1;

  String? _selectDiet;
  List<String> dietList = [];
  List<String> dietKeys = [];
  late String selectedDietKey;

  String? _selectBloodG;
  List<String> bloodGList = [];
  List<String> bloodKeys = [];
  late String selectedBloodKey;

  String? _selectIncome;
  List<String> incomeList = [];
  List<String> incomeKeys = [];
  late String selectedIncomeFromKey = "";
  late String selectedIncomeToKey = "";

  List<EducationsData> _education = [];
  EducationsData? _selectedEducation;
  String? _selectedEducationId;

  List<OccupationData> _occupation = [];
  OccupationData? _selectedOccupation;
  String? _selectedOccupationId;

  String? _selectMaritalStatus;
  List<String> maritalStatusList = [];
  List<String> maritalStatusKeys = [];
  late String selectedMaritalKey;

  String? _selectFatherStatus;
  List<String> fatherStatusList = [];
  List<String> fatherStatusKeys = [];
  late String selectedFatherKey;

  String? _selectMotherStatus;
  List<String> motherStatusList = [];
  List<String> motherStatusKeys = [];
  late String selectedMotherKey;

  late final TextEditingController fNameController = TextEditingController();
  late final TextEditingController lNameController = TextEditingController();
  late final TextEditingController bDateController = TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController addressController = TextEditingController();
  late final TextEditingController cityController = TextEditingController();
  late final TextEditingController mobileController = TextEditingController();
  late final TextEditingController altMobileController = TextEditingController();

  late final TextEditingController weightController = TextEditingController();

  late final TextEditingController noOfBrothersController = TextEditingController();
  late final TextEditingController noOfSisterController = TextEditingController();
  late final TextEditingController contactPersonController =TextEditingController();
  late final TextEditingController timeController = TextEditingController();
  late final TextEditingController nativePlaceController = TextEditingController();
  late final TextEditingController aboutFamilyController =  TextEditingController();

  late final TextEditingController incomeController = TextEditingController();
  late final TextEditingController noOfChildrenController = TextEditingController();

  // List<String> childrenOptions = ["Yes", "No"];
  late String _selectedChildren = "";

  late int selectedIndex = 1;
  late int selectedBodyTypeIndex = 1;

  @override
  void initState() {
    super.initState();
    setState(() {
      getSharedPrefValue();
      fetchCountry();
      getProfileDetailApi();
      fetchEducation();
      fetchOccupation();
      // fetchState(alGetProfileDetail[0].data!.countryId!.id);
    });
  }

  Future<void> getProfileDetailApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final stringValue = prefs.getString('userId')!;
    print("userId~~~**${stringValue}");
    setState(() {
      _isLoading = true;
    });
    final url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/profile_detail/${stringValue}');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // setState(() {
      var jsonList = jsonDecode(response.body) as Map<String, dynamic>;
      print("jsonList$jsonList");
      final localPickData = ProfileDetailModel.fromJson(jsonList);
      print("localPickData^^^^${localPickData.data}");

      alGetProfileDetail.add(localPickData);

      fNameController.text = alGetProfileDetail[0].data!.firstName!;
      lNameController.text = alGetProfileDetail[0].data!.lastName!;
      bDateController.text = alGetProfileDetail[0].data!.dateOfBirth!;
      addressController.text = alGetProfileDetail[0].data!.address1!;
      cityController.text = alGetProfileDetail[0].data!.city!;
      mobileController.text = alGetProfileDetail[0].data!.mobileNo!;
      altMobileController.text = alGetProfileDetail[0].data!.altPhone!;
      emailController.text = alGetProfileDetail[0].data!.emailId!;
      incomeController.text = alGetProfileDetail[0].data!.incomeTo!.toString() +
          " to " +
          alGetProfileDetail[0].data!.incomeFrom.toString();

      weightController.text = alGetProfileDetail[0].data!.weight!;
      // _selectedHeight=alGetProfileDetail[0].data!.height!.toString();

      noOfSisterController.text =
          alGetProfileDetail[0].data!.noOfSisters!.toInt().toString();
      noOfBrothersController.text =
          alGetProfileDetail[0].data!.noOfBrothers.toString();
      contactPersonController.text =
          alGetProfileDetail[0].data!.contactPerson.toString();
      timeController.text =
          alGetProfileDetail[0].data!.convenientTime.toString();
      nativePlaceController.text =
          alGetProfileDetail[0].data!.nativePlace.toString();
      aboutFamilyController.text =
          alGetProfileDetail[0].data!.aboutMyFamily.toString();
      noOfChildrenController.text =
          alGetProfileDetail[0].data!.noOfChildren.toString();

      int profileHeightIndex =
          heightKeys.indexOf(alGetProfileDetail[0].data!.height.toString());
      if (profileHeightIndex != -1 && profileHeightIndex < heightList.length) {
        _selectedHeight = heightList[profileHeightIndex];
        selectedKey = alGetProfileDetail[0].data!.height.toString();
      }

      int profileDietIndex =
          dietKeys.indexOf(alGetProfileDetail[0].data!.diet.toString());
      if (profileDietIndex != -1 && profileDietIndex < dietList.length) {
        _selectDiet = dietList[profileDietIndex];
        selectedDietKey = alGetProfileDetail[0].data!.diet.toString();
      }

      int profileBloodIndex =
          bloodKeys.indexOf(alGetProfileDetail[0].data!.bloodGroup.toString());
      if (profileBloodIndex != -1 && profileBloodIndex < bloodGList.length) {
        _selectBloodG = bloodGList[profileBloodIndex];
        selectedBloodKey = alGetProfileDetail[0].data!.bloodGroup.toString();
      }
      int profileIncomeIndex = incomeKeys.indexOf(
          alGetProfileDetail[0].data!.incomeFrom.toString() +
              "-" +
              alGetProfileDetail[0].data!.incomeTo.toString());
      if (profileIncomeIndex != -1 && profileIncomeIndex < incomeList.length) {
        _selectIncome = incomeList[profileIncomeIndex];
        selectedIncomeFromKey =
            alGetProfileDetail[0].data!.incomeFrom.toString();
        selectedIncomeToKey = alGetProfileDetail[0].data!.incomeTo.toString();
      }

      int profileFatherStatusIndex = fatherStatusKeys
          .indexOf(alGetProfileDetail[0].data!.fathersStatus.toString());
      if (profileFatherStatusIndex != -1 &&
          profileFatherStatusIndex < fatherStatusList.length) {
        _selectFatherStatus = fatherStatusList[profileFatherStatusIndex];
        selectedFatherKey =
            alGetProfileDetail[0].data!.fathersStatus.toString();
      }
      int profileMotherStatusIndex = motherStatusKeys
          .indexOf(alGetProfileDetail[0].data!.mothersStatus.toString());
      if (profileMotherStatusIndex != -1 &&
          profileMotherStatusIndex < motherStatusList.length) {
        _selectMotherStatus = motherStatusList[profileMotherStatusIndex];
        selectedMotherKey =
            alGetProfileDetail[0].data!.mothersStatus.toString();
      }
      int profileMaritalStatusIndex = maritalStatusKeys
          .indexOf(alGetProfileDetail[0].data!.maritalStatus.toString());
      if (profileMaritalStatusIndex != -1 &&
          profileMaritalStatusIndex < maritalStatusList.length) {
        _selectMaritalStatus = maritalStatusList[profileMaritalStatusIndex];
        selectedMaritalKey =
            alGetProfileDetail[0].data!.maritalStatus.toString();
      }

      selectedIndex = alGetProfileDetail[0].data!.complexion!;
      selectedBodyTypeIndex = alGetProfileDetail[0].data!.bodyType!;

      _selectedEducationId =  alGetProfileDetail[0].data!.educationId!.id.toString();
      _selectedEducation = _education .firstWhereOrNull((edu) => edu.id.toString() == _selectedEducationId);

        print("_selectedEducationId~~~${_selectedEducationId}");


      _selectedOccupationId =
          alGetProfileDetail[0].data!.professionId!.id.toString();
      _selectedOccupation = _occupation.firstWhereOrNull(
          (edu) => edu.id.toString() == _selectedOccupationId);

      _selectedChildren=alGetProfileDetail[0].data!.havechildren!;
      noOfChildrenController.text=alGetProfileDetail[0].data!.noOfChildren.toString();




      _selectedCountry = CountryData(id: alGetProfileDetail[0].data!.countryId!.id, countryName: alGetProfileDetail[0].data!.countryId!.countryName.toString());
      _selectState = StateData(state: alGetProfileDetail[0].data!.state,);

      print("_selectState~~~${_selectState!.state}");
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _isLoading = false;
      });
      // _isLoading = false;
    } else {
      throw Exception('Failed to load education_list');
    }
  }

  Future<dynamic> postProfileEdit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final stringValue = prefs.getString('userId')!;
    setState(() {
      _isLoading = true;
    });
    // showDialog(
    //     context: context,
    //     builder: (context) {
    //       return Center(
    //         child: CircularProgressIndicator(
    //           color: AppColor.mainAppColor,
    //         ),
    //       );
    //     });
    var url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/profile_edit/${stringValue}');

    var jsonData = json.encode({
      'first_name':
          '${fNameController.text.isNull ? "" : fNameController.text}',
      'last_name': '${lNameController.isNull ? "" : lNameController.text}',
      'date_of_birth':
          '${bDateController.text.isNotEmpty ? bDateController.text : '2024-03-27'}',
      'email_id':
          '${emailController.isNull ? 'text@gmail.com' : emailController.text}',
      'address1':
          '${addressController.text.isNull ? '' : addressController.text}',
      'city': '${cityController.text.isNull ? '' : cityController.text}',
      'country_id':'${_selectedCountry!.id.isNull ? '2' : _selectedCountry!.id}',
      'state': '${_selectState!.state!.isNotEmpty?_selectState!.state: '  '}',
      'mobile_no':
          '${mobileController.text.isNull ? '' : mobileController.text}',
      'alt_phone':
          '${altMobileController.text.isNull ? '' : altMobileController.text}',

      'weight': '${weightController.text.isNull ? '' : weightController.text}',
      'height': '${selectedKey.isNull ? '2' : selectedKey}',
      'complexion': '${complexionKey.isNull ? '' : complexionKey}',
      'body_type': '${bodyTypeKey.isNull ? '' : bodyTypeKey}',
      'diet': '${selectedDietKey.isNull ? '' : selectedDietKey}',
      'blood_group': '${selectedBloodKey.isNull ? '' : selectedBloodKey}',
      'income_from':
          '${selectedIncomeFromKey.isNull ? '' : selectedIncomeFromKey}',
      'income_to': '${selectedIncomeToKey.isNull ? '' : selectedIncomeToKey}',
      'education_id':
          '${_selectedEducation!.id.isNull ? '' : _selectedEducation!.id}',
      'profession_id':
          '${_selectedOccupation!.id.isNull ? '' : _selectedOccupation!.id}',
      'marital_status':
          '${selectedMaritalKey.isNull ? '' : selectedMaritalKey}',

      'fathers_status': '${selectedFatherKey!.isNull ? '' : selectedFatherKey}',
      'mothers_status': '${selectedMotherKey!.isNull ? '' : selectedMotherKey}',
      'no_of_brothers':
          '${noOfBrothersController.text.isNull ? '' : noOfBrothersController.text}',
      'no_of_sisters':
          '${noOfSisterController.text.isNull ? '' : noOfSisterController.text}',
      'contact_person':
          '${contactPersonController.text.isNull ? '' : contactPersonController.text}',
      'convenient_time':
          '${timeController.text.isNull ? '' : timeController.text}',
      'native_place':
          '${nativePlaceController.text.isNull ? '' : nativePlaceController.text}',
      'about_my_family':
          '${aboutFamilyController.text.isNull ? '' : aboutFamilyController.text}',
      if (_selectMaritalStatus != "Never Married")
        'havechildren': '${_selectedChildren.isNull ? '' : _selectedChildren}',
      if (_selectedChildren!="No")
        'no_of_children':
            '${noOfChildrenController.text.isEmpty ? '0' : noOfChildrenController.text}',

      // 'gender': '1',
      // 'religion_id': '',
      // 'paid_status': '',
      // 'photo_available': '',
      // 'address2': '',
      // 'country_code': '',
      // 'subcaste': '',
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
        print('Response DATA#######: ${response.body}');
        await Future.delayed(Duration(seconds: 1));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${alGetProfileDetail[0].message}"),
          backgroundColor: AppColor.lightGreen,
        ));
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) {
            return SearchScreen();
          },
        ));
        setState(() {
          _isLoading = false;
        });
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<void> fetchCountry() async {
    final response = await http.get(Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/country_list'));
    if (response.statusCode == 200) {
      setState(() {
        final userMap = json.decode(response.body);
        final user = CountryModel.fromJson(userMap);

        countryList = user.data!;
        setState(() {});
      });
    } else {
      throw Exception('Failed to load countries');
    }
  }

  Future<void> fetchState(countryId) async {
    final url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/state_list/$countryId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        final userMap = json.decode(response.body);
        final user = StateModel.fromJson(userMap);
        stateList = user.data!;
      });
    } else {
      throw Exception('Failed to load state');
    }
  }

  Future<void> fetchEducation() async {
    final url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/education_list');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        final userMap = json.decode(response.body);
        final user = EducationsModel.fromJson(userMap);
        _education = user.data!;
        // _selectedEducation =
        //     List.generate(_occupation.length, (index) => false);
      });
    } else {
      throw Exception('Failed to load education_list');
    }
  }

  Future<void> fetchOccupation() async {
    final url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/occupation_list');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final userMap = json.decode(response.body);
      final occupationModel = OccupationModel.fromJson(userMap);
      _occupation = occupationModel.data!;
      // _selectedOccupation =
      //     List.generate(_occupation.length, (index) => false);
    } else {
      throw Exception('Failed to load occupation_list');
    }
  }

  getSharedPrefValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final stringValue = prefs.getString('globalApiData');
    if (stringValue != null) {
      Map<String, dynamic> jsonMap = jsonDecode(stringValue);

      GlobalValueModel profileData = GlobalValueModel.fromJson(jsonMap);
      allGetGlobalValue.add(profileData);

      complexionList = profileData.data!.complexionList!.toList();
      bodyTypeList = profileData.data!.bodytypeList!.toList();

      Map<String, dynamic> responseData = json.decode(stringValue);

      Map<String, dynamic> heightLists = responseData['data']['height_list'];
      heightLists.forEach((key, value) {
        heightList.add(value as String);
        heightKeys.add(key);
      });

      Map<String, dynamic> dietLists = responseData['data']['diet_list'];
      dietLists.forEach((key, value) {
        dietList.add(value as String);
        dietKeys.add(key);
      });

      Map<String, dynamic> bloodGroupLists =
          responseData['data']['blood_group_list'];
      bloodGroupLists.forEach((key, value) {
        bloodGList.add(value as String);
        bloodKeys.add(key);
      });

      Map<String, dynamic> incomeLists = responseData['data']['income_list'];
      incomeLists.forEach((key, value) {
        incomeList.add(value as String);
        incomeKeys.add(key);
      });

      Map<String, dynamic> maritalLists =
          responseData['data']['maritalstatus_list'];
      maritalLists.forEach((key, value) {
        maritalStatusList.add(value as String);
        maritalStatusKeys.add(key);
      });

      Map<String, dynamic> fatherLists =
          responseData['data']['fatherstatus_list'];
      fatherLists.forEach((key, value) {
        fatherStatusList.add(value as String);
        fatherStatusKeys.add(key);
      });

      Map<String, dynamic> motherLists =
          responseData['data']['motherstatus_list'];
      motherLists.forEach((key, value) {
        motherStatusList.add(value as String);
        motherStatusKeys.add(key);
      });
    }
    return stringValue;
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
    double width = MediaQuery.of(context).size.width - 16.0;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 255, 241, 241),
      appBar: CommonAppBar(
        text: "Edit Profile",
        scaffoldKey: _scaffoldKey,
        key: Key("cv"),
      ),
      drawer: SideDrawer(),
      body: Stack(fit: StackFit.expand, children: [
        Image.asset(
          "assets/images/bg_pink.jpg",
          fit: BoxFit.fill,
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _gap(),
                Container(
                  padding: EdgeInsets.only(top: 6, bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  // color: Colors.white,
                  child: ExpansionTile(
                    onExpansionChanged:(bool expanded) {
                      setState(() => isExpanded1 = expanded);
                      },
                      title: Text(
                        "Profile Details",
                        style: AppTheme.profileEditText(),
                      ),
                      // subtitle: const Text('Some subtitle'),
                      trailing: Icon(isExpanded1?Icons.remove:Icons.add,
                          color: AppColor.appGreenColor, size: 29),
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/bg_pink.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _gap(),
                              buildTitle("First Name"),
                              buildTextField(fNameController, 'First Name'),
                              _drivire(),
                              buildTitle("Last Name"),
                              buildTextField(lNameController, 'Last Name'),
                              _drivire(),
                              buildTitle("Date of Birth"),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 12.0,
                                    left: 12.0,
                                    top: 5.0,
                                    bottom: 12),
                                child: Container(
                                  decoration: AppTheme.ConDecoration(),
                                  child: TextField(
                                    controller: bDateController,
                                    decoration: InputDecoration(
                                      hintText: "yyyy/mm/dd",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 12),
                                      suffixIcon: GestureDetector(
                                        onTap: () async {
                                          final DateTime? picked =
                                              await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1920),
                                            lastDate: DateTime.now(),
                                          );
                                          if (picked != null) {
                                            final newDate =
                                                "${picked.year}-${picked.month}-${picked.day}";
                                            print("newDate~~${newDate}");
                                            if (newDate.isNotEmpty) {
                                              bDateController.text = newDate;
                                            }
                                          }
                                        },
                                        child: Icon(
                                          Icons.calendar_month_sharp,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              _drivire(),
                              buildTitle("Email Id"),
                              buildTextField(emailController, 'Email Id'),
                              _drivire(),
                              buildTitle("Address"),
                              buildTextField(addressController, 'Address'),
                              _drivire(),
                              buildTitle("City"),
                              buildTextField(cityController, 'City'),
                              _drivire(),
                                Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildTitle("Country"),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: DropdownSearch<CountryData>(
                                              popupProps: PopupProps.menu(
                                                constraints: BoxConstraints.loose(Size.fromHeight(250)),
                                                // showSelectedItems: true,
                                                showSearchBox: true,
                                                searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                    hintText: "Search",
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                                  ),
                                                ),
                                              ),
                                              items: countryList,
                                              itemAsString: (CountryData item) =>
                                                  item.countryName.toString(),
                                              selectedItem: _selectedCountry,
                                              onChanged:(CountryData? selectedCountry) {
                                                setState(() {
                                                  _selectedCountry = selectedCountry;
                                                  print("_selectedCountry${_selectedCountry!.id}");
                                                  fetchState(_selectedCountry!.id);
                                                });
                                              },
                                              dropdownDecoratorProps:  DropDownDecoratorProps(
                                                dropdownSearchDecoration: InputDecoration(
                                                  hintText: 'Please Select',
                                                  suffixIcon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.black),
                                                  border: OutlineInputBorder(
                                                    borderRadius:  BorderRadius.circular(10,),
                                                  ),
                                                  fillColor: AppTheme.ConDecoration().color,filled: true,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          buildTitle("State"),
                                          Container(
                                            margin: EdgeInsets.all(2),
                                            child: DropdownSearch<StateData>(
                                              popupProps: PopupProps.menu(
                                                constraints: BoxConstraints.loose(Size.fromHeight(250)),
                                                showSelectedItems: false,
                                                showSearchBox: true,
                                                searchFieldProps: TextFieldProps(
                                                  decoration: InputDecoration(
                                                    hintText: "Search",
                                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                                                  ),
                                                ),
                                              ),
                                              items: stateList,
                                              itemAsString: (StateData item) =>
                                                  item.state.toString(),
                                              selectedItem: _selectState,
                                              onChanged:(StateData? selectedCountry) {
                                                setState(() {
                                                  _selectState = selectedCountry;
                                                  print("_selectState~~${_selectState!.state}");
                                                });
                                              },
                                              dropdownDecoratorProps:  DropDownDecoratorProps(
                                                dropdownSearchDecoration: InputDecoration(
                                                  hintText: 'Please Select',
                                                  suffixIcon: Icon(
                                                      Icons.keyboard_arrow_down,
                                                      color: Colors.black),
                                                  border: OutlineInputBorder(
                                                    borderRadius:  BorderRadius.circular(10,),
                                                  ),
                                                  fillColor: AppTheme.ConDecoration().color,filled: true,),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _gap(),
                              buildRow(
                                'Mobile No',
                                'Alt Phone',
                                mobileController,
                                altMobileController,
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                _gap(),
                Container(
                  padding: EdgeInsets.only(top: 6, bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: ExpansionTile(
                    onExpansionChanged:(bool expanded) {
                      setState(() => isExpanded2 = expanded);
                    },
                    title: Text(
                      "Personal Details",
                      style: AppTheme.profileEditText(),
                    ),
                    trailing: Icon(isExpanded2?Icons.remove:Icons.add,
                        color: AppColor.appGreenColor, size: 29),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/bg_pink.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _gap(),
                                      buildTitle("Height"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          menuMaxHeight: 300,
                                          isExpanded: true,
                                          value: _selectedHeight,
                                          hint: Text('Please Select'),
                                          underline: Column(),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedHeight = newValue;
                                            });
                                            if (newValue != null) {
                                              int index =
                                                  heightList.indexOf(newValue);
                                              if (index != -1 &&
                                                  index < heightKeys.length) {
                                                selectedKey = heightKeys[index];
                                                print( "Selected key: $selectedKey");
                                                print( "Selected key: ${alGetProfileDetail[0].data!.height}");
                                              }
                                            }
                                          },
                                          items: heightList
                                              .map<DropdownMenuItem<String>>(
                                                  (String list) {
                                            return DropdownMenuItem<String>(
                                              value: list,
                                              child: Text(list),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _gap(),
                                      buildTitle("Weight"),
                                      _gap(),
                                      buildTextField(
                                          weightController, "Weight"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _gap(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Complexion"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          isExpanded: true,
                                          // value: selectedIndex != -1 ?
                                          // complexionList[selectedIndex] : null,
                                          value: selectedIndex != -1 && selectedIndex < complexionList.length
                                              ? complexionList[selectedIndex]
                                              : null,
                                          hint: Text('Please Select'),
                                          underline: Column(),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedComplexion = newValue;
                                              complexionKey = complexionList
                                                  .indexOf(newValue!);
                                              print(
                                                  "_selectedComplexion~~$complexionKey");
                                            });
                                          },
                                          items: complexionList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Body Type"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          isExpanded: true,
                                          // value: selectedIndex != -1 && selectedIndex < complexionList.length
                                          //     ? complexionList[selectedIndex]
                                          //     : null,
                                          value: selectedBodyTypeIndex != -1 &&selectedBodyTypeIndex<bodyTypeList.length ?  bodyTypeList[ selectedBodyTypeIndex]: null,
                                          hint: Text('Please Select'),
                                          underline: Column(),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectedBodyType = newValue;
                                              bodyTypeKey = bodyTypeList
                                                  .indexOf(newValue!);
                                            });
                                          },
                                          items: bodyTypeList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _gap(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Diet"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          isExpanded: true,
                                          value: _selectDiet,
                                          hint: Text('Please Select'),
                                          underline: Column(),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectDiet = newValue;
                                            });
                                            if (newValue != null) {
                                              int index =
                                                  dietList.indexOf(newValue);
                                              if (index != -1 &&
                                                  index < dietKeys.length) {
                                                selectedDietKey =
                                                    dietKeys[index];
                                                print(
                                                    "Selected key: $selectedDietKey");
                                              }
                                            }
                                          },
                                          items: dietList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Blood Group"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          isExpanded: true,
                                          value: _selectBloodG,
                                          hint: Text('Please Select'),
                                          underline: Column(),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectBloodG = newValue;
                                            });
                                            if (newValue != null) {
                                              int index =
                                                  bloodGList.indexOf(newValue);
                                              if (index != -1 &&
                                                  index < bloodKeys.length) {
                                                selectedBloodKey =
                                                    bloodKeys[index];
                                                print( "Selected key: $selectedBloodKey");
                                              }
                                            }
                                          },
                                          items: bloodGList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _gap(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Income"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          isExpanded: true,
                                          value: _selectIncome,
                                          hint: Text('Please Select'),
                                          underline: Column(),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectIncome = newValue;
                                            });
                                            if (newValue != null) {
                                              int index =
                                                  incomeList.indexOf(newValue);
                                              if (index != -1 &&
                                                  index < incomeKeys.length) {
                                                String key = incomeKeys[index];
                                                List<String> keyParts =
                                                    key.split("-");
                                                if (keyParts.length == 2) {
                                                  selectedIncomeFromKey =
                                                      keyParts[0];
                                                  selectedIncomeToKey =
                                                      keyParts[1];
                                                  print(
                                                      "Selected key: $selectedIncomeFromKey-$selectedIncomeToKey");
                                                }
                                                // selectedIncomeFromKey = incomeKeys[index];
                                                // selectedIncomeToKey=incomeKeys[index];
                                                // print("Selected key: $selectedIncomeFromKey");
                                              }
                                            }
                                          },
                                          items: incomeList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Education"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<EducationsData>(
                                          borderRadius: BorderRadius.circular(12),
                                          isExpanded: true,
                                          value: _selectedEducation,
                                          hint: Text('Please Select'),
                                          underline: Container(),
                                          icon: const Icon( Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged:    (EducationsData? newValue) {
                                            setState(() {
                                              _selectedEducation = newValue;
                                            });
                                          },
                                          items: _education.map<
                                                  DropdownMenuItem<
                                                      EducationsData>>(
                                              (EducationsData value) {
                                            return DropdownMenuItem<
                                                EducationsData>(
                                              value: value,
                                              child: Text("${value.education}"),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _gap(),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Profession"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<OccupationData>(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          isExpanded: true,
                                          value: _selectedOccupation,
                                          hint: Text('Please Select'),
                                          underline: Column(),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged:
                                              (OccupationData? newValue) {
                                            setState(() {
                                              _selectedOccupation = newValue;
                                            });
                                          },
                                          items: _occupation.map<
                                                  DropdownMenuItem<
                                                      OccupationData>>(
                                              (OccupationData value) {
                                            return DropdownMenuItem<
                                                OccupationData>(
                                              value: value,
                                              child:
                                                  Text("${value.occupation}"),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      buildTitle("Marital Status"),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
                                        margin: EdgeInsets.all(12),
                                        decoration: AppTheme.ConDecoration(),
                                        child: DropdownButton<String>(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          isExpanded: true,
                                          value: _selectMaritalStatus,
                                          hint: Text('Please Select'),
                                          underline: Column(),
                                          icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Colors.black),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              _selectMaritalStatus = newValue;
                                            });
                                            if (newValue != null) {
                                              int index = maritalStatusList
                                                  .indexOf(newValue);
                                              if (index != -1 &&
                                                  index <
                                                      maritalStatusKeys
                                                          .length) {
                                                selectedMaritalKey =
                                                    maritalStatusKeys[index];
                                                print(
                                                    "Selected key: $selectedMaritalKey");
                                              }
                                            }
                                          },
                                          items: maritalStatusList
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            _gap(),
                            if (_selectMaritalStatus != "Never Married")
                              buildTitle("Have Children"),
                            if (_selectMaritalStatus != "Never Married")
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: ListTile(
                                      title: Text('Yes',
                                          style: AppTheme.profileDetail()),
                                      leading: Radio<String>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Color(0XFFB63728)),
                                        value: "Yes",
                                        groupValue: _selectedChildren,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedChildren =
                                                value.toString();
                                            print(
                                                "_selectedPhoto~~${_selectedChildren}");
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ListTile(
                                      title: Text('No',
                                          style: AppTheme.profileDetail()),
                                      leading: Radio<String>(
                                        fillColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Color(0XFFB63728)),
                                        value: "No",
                                        groupValue: _selectedChildren,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedChildren =
                                                value.toString();
                                            print(
                                                "_selectedPhoto~~${_selectedChildren}");
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (_selectedChildren == "Yes" && _selectMaritalStatus != "Never Married")
                              buildTitle("No Of Children"),
                            if (_selectedChildren == "Yes" && _selectMaritalStatus != "Never Married")
                              buildTextField(
                                  noOfChildrenController, 'No Of Children'),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                _gap(),
                Container(
                  padding: EdgeInsets.only(top: 6, bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                  ),
                  child: ExpansionTile(
                      onExpansionChanged:(bool expanded) {
                        setState(() => isExpanded3 = expanded);
                      },
                      title: Text(
                        "Family Details",
                        style: AppTheme.profileEditText(),
                      ),
                      trailing: Icon(isExpanded3?Icons.remove:Icons.add,
                          color: AppColor.appGreenColor, size: 29),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/bg_pink.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _gap(),
                                        buildTitle("Fathers Status"),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          margin: EdgeInsets.all(12),
                                          decoration: AppTheme.ConDecoration(),
                                          child: DropdownButton<String>(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            isExpanded: true,
                                            value: _selectFatherStatus,
                                            hint: Text('Please Select'),
                                            underline: Column(),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectFatherStatus = newValue;
                                              });
                                              if (newValue != null) {
                                                int index = fatherStatusList
                                                    .indexOf(newValue);
                                                if (index != -1 &&
                                                    index <
                                                        fatherStatusKeys
                                                            .length) {
                                                  selectedFatherKey =
                                                      fatherStatusKeys[index];
                                                  print(
                                                      "Selected key: $selectedFatherKey");
                                                }
                                              }
                                            },
                                            items: fatherStatusList
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _gap(),
                                        buildTitle("Mothers Status"),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          margin: EdgeInsets.all(12),
                                          decoration: AppTheme.ConDecoration(),
                                          child: DropdownButton<String>(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            isExpanded: true,
                                            value: _selectMotherStatus,
                                            hint: Text('Please Select'),
                                            underline: Column(),
                                            icon: const Icon(
                                                Icons.keyboard_arrow_down,
                                                color: Colors.black),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                _selectMotherStatus = newValue;
                                              });
                                              if (newValue != null) {
                                                int index = motherStatusList
                                                    .indexOf(newValue);
                                                if (index != -1 &&
                                                    index <
                                                        motherStatusKeys
                                                            .length) {
                                                  selectedMotherKey =
                                                      motherStatusKeys[index];
                                                  print(
                                                      "Selected key: $selectedMotherKey");
                                                }
                                              }
                                            },
                                            items: motherStatusList
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              _gap(),
                              buildRow(
                                'No Of Brothers',
                                'No Of Sisters',
                                noOfBrothersController,
                                noOfSisterController,
                              ),
                              _gap(),
                              buildRow(
                                'Contact Person',
                                'Convenient Time',
                                contactPersonController,
                                timeController,
                              ),
                              _gap(),
                              buildRow(
                                'Native Place',
                                'About My Family',
                                nativePlaceController,
                                aboutFamilyController,
                              ),
                            ],
                          ),
                        )
                      ]),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await postProfileEdit();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 126, 143, 130),
                  ),
                  child: Text(
                    "Update",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                _gap(),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Center(
            child: CircularProgressIndicator(color: AppColor.lightGreen),
          ),
      ]),
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(
        left: 18,
      ),
      child: Text(title, style: AppTheme.nextBold()),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 12.0, left: 12.0, top: 5.0, bottom: 12),
      child: Container(
        decoration: AppTheme.ConDecoration(),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget buildRow(
    String title1,
    String title2,
    TextEditingController controller1,
    TextEditingController controller2,
    // int flex1,
    // int flex2,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(title1),
              // SizedBox(height: 10),
              buildTextField(controller1, title1),
            ],
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitle(title2),
              // SizedBox(height: 10),
              buildTextField(controller2, title2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _gap() => const SizedBox(height: 12);

  Widget _drivire() => Divider();
}
