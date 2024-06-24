import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/bottom_sheet_screen/view_model/country_model.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/educations_model.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/global_value_model.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/occupation_model.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/state_model.dart';
import 'package:matrimony/utils/ProgressHUD.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomScreen extends StatefulWidget {
  final String? selectedName;
  final String? selectedCountry;
  final String? selectedState;
  final String? selectedGender;
  final String? selectedMaritalStatus;
  final String? selectedAge;
  final String? selectedAgeS;
  final String? selectedDiet;
  final String? selectedBodyType;
  final String? selectedComplexion;
  final String? selectedReligion;
  final String? selectedEducation;
  final String? selectedProfession;
  final String? selectedIncome;
  final String? selectedPhoto;
  const BottomScreen({super.key,
    required this.selectedName,
    required this.selectedCountry,
    required this.selectedState,
    required this.selectedGender,
    required this.selectedMaritalStatus,
    required this.selectedAge,
    required this.selectedAgeS,
    required this.selectedDiet,
    required this.selectedBodyType,
    required this.selectedComplexion,
    required this.selectedReligion,
    required this.selectedEducation,
    required this.selectedProfession,
    required this.selectedIncome,
    required this.selectedPhoto,});

  @override
  State<BottomScreen> createState() {
    return _BottomScreenState();
  }
}

class _BottomScreenState extends State<BottomScreen> {
  List<String> incomeOptions = [];
  List<String> dietOptions = [];
  List<bool> _selectedDiet = [];
  List<String> religionOptions = [];
  List<String> maritalStatusOption = [];
  List<bool> _selectedMaritalStatus = [];
  // List<String> genderOption = [];
  // String? _selectedGender = "male";
  String? _selectedGender;


  // String? _selectedPhoto = "Yes";
  String? _selectedPhoto;

  List<String> bodyTypeOptions = [];
  List<bool> _selectedBodyType = [];
  List<String> ageOptions = [];
  List<String> complexionOptions = [];
  List<bool> _selectedComplexion = [];
  String? _selectedValue;
  String? _selectedIncome;
  String? _selectedAge="18";
  String? _selectedAgeS="25";

  List<String> photoOptions = ["Yes", "No"];

  List<CountryData> _country = [];
  CountryData? _selectedCountry;
  List<StateData> _state = [];
  StateData? _selectedState;
   String countryId = "97";
  List<EducationsData> _education = [];
  List<bool> _selectedEducation = [];
  List<OccupationData> _occupation = [];
  List<bool> _selectedOccupation = [];
  late Map<String, dynamic> _incomeList;
  late Map<String, dynamic> _religionList;
  late Map<String, dynamic> _maritalList;
  late Map<String, dynamic> _dietList;

  var globalValueModel = GlobalValueModel();
  List<GlobalData> incomeOption = [];
  List<CountryData> countryNames = [];

  final TextEditingController searchController = TextEditingController();
  bool iLoaded = false;
  bool isApiCallProcess = false;
  RangeValues _ageRange = RangeValues(18, 65);
  List<String> _heightKeys = [];
  RangeValues? _heightRange;
  Map<String, String> _heightList = {};


//key all ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  String? incomeKey;
  String? religionKey;
  String? maritalKey;
  String? dietKey;
  String? educationKey;
  String? professionKey;
  String? genderKey;
  String? photoKey;
  String? bodyKey;
  String? complexionKey;

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchGlobalValues().then((_) {
        setState(() {
          _heightKeys = _heightList.keys.toList();
          if (_heightKeys.isNotEmpty) {
            _heightRange = RangeValues(1, (_heightKeys.length - 1).toDouble());
          }
        });
      });
      fetchCountry();
      fetchEducation();
      fetchOccupation();
       searchController.text= widget.selectedName ?? "";
       if(widget.selectedGender==1.toString()){
         _selectedGender="male";
         genderKey = 1.toString();
       }
       else{
         _selectedGender="female";
         genderKey = 2.toString();
       }
       if(widget.selectedPhoto==1.toString()){
         _selectedPhoto="Yes";
       }
       else{
         _selectedPhoto="No";
       }

       print("widget.selectedMaritalStatus${widget.selectedMaritalStatus}");
       print("widget.selectedDiet${widget.selectedDiet}");
       maritalKey = widget.selectedMaritalStatus;
       dietKey= widget.selectedDiet;
       bodyKey=widget.selectedBodyType;
       complexionKey=widget.selectedComplexion;
       // educationKey=widget.selectedEducation;


       print("educationKey${educationKey}");
       print("widget.selectedEducation${widget.selectedEducation}");
       print("widget.selectedEducation${_selectedEducation}");
       professionKey=widget.selectedProfession;
      _selectedAge = widget.selectedAge;
      _selectedAgeS = widget.selectedAgeS;

    });
  }

  Future<dynamic> postData() async {
    var url = Uri.parse(
        '${Webservices.baseUrl+Webservices.profileList}');

    var jsonData = json.encode({
      // 'keyword': '${searchController.text.isNull ? "" :searchController.text}',
      // 'country_id': '${_selectedCountry!.id.isNull ?" ":_selectedCountry?.id.toString()}',
      // 'state': '${_selectedState?.state=="" ? _selectedState?.state: " "}',
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
      // 'start_age': '${_ageRange.start.toInt().toString().isNull ?18:_ageRange.start.toInt().toString()}',
      // 'end_age': '${_ageRange.end.toInt().toString().isNull?25:_ageRange.end.toInt().toString()}',

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
  }

  Future<void> fetchGlobalValues() async {
    setState(() {
      isApiCallProcess = true;
    });
    final response = await http.get(Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/global_values'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final localPickData = GlobalValueModel.fromJson(responseData);
      print("localPickData${localPickData.data}");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('globalApiData', response.body);

      _incomeList = responseData['data']['income_list'];
      _dietList = responseData['data']['diet_list'];
      _religionList = responseData['data']['religion_list'];
      _maritalList = responseData['data']['maritalstatus_list'];
      _maritalList = responseData['data']['maritalstatus_list'];
      // final Map<String, dynamic> genderList =
      //     responseData['data']['gender_list'];
      bodyTypeOptions =
          List<String>.from(responseData['data']['bodytype_list']);
      ageOptions = List<String>.from(responseData['data']['age_list']);
      complexionOptions =
          List<String>.from(responseData['data']['complexion_list']);
      _heightList = Map<String, String>.from(responseData['data']['height_list']);

        _selectedComplexion =
            List<bool>.filled(complexionOptions.length, false);
        _selectedBodyType = List<bool>.filled(bodyTypeOptions.length, false);
        _selectedDiet = List<bool>.filled(_dietList.length, false);
        _selectedMaritalStatus = List<bool>.filled(_maritalList.length, false);
        incomeOptions = _incomeList.values.toList().cast<String>();
        dietOptions = _dietList.values.toList().cast<String>();
        religionOptions = _religionList.values.toList().cast<String>();
        maritalStatusOption = _maritalList.values.toList().cast<String>();

      //bottom sheet selected data ..
      if (_incomeList.containsKey(widget.selectedIncome)) {
        _selectedIncome = _incomeList[widget.selectedIncome];
      }
      if (_religionList.containsKey(widget.selectedReligion)) {
        _selectedValue = _religionList[widget.selectedReligion];
      }
      _selectedMaritalStatus = List<bool>.generate(
          _maritalList.length, (index) => widget.selectedMaritalStatus!.contains(_maritalList.keys.elementAt(index)));
      _selectedDiet = List<bool>.generate(
          _dietList.length, (index) => widget.selectedDiet!.contains(_dietList.keys.elementAt(index)));

      _selectedBodyType = List<bool>.generate(
        bodyTypeOptions.length,
            (index) {
          int indexValue = index + 1;
          return widget.selectedBodyType!.split(',').any((element) => element.trim() == indexValue.toString());
        },
      );

      _selectedComplexion=List<bool>.generate(
          complexionOptions.length,
              (index){
            int indexValue=index +1;
            return widget.selectedComplexion!.split(',').any((element) => element.trim() == indexValue.toString());
          });

      setState(() {
            isApiCallProcess = false;
          });
    } else {
      setState(() {
        isApiCallProcess = false;
      });
      throw Exception('Failed to load income options');
    }
  }

  Future<void> fetchCountry() async {
    final response = await http.get(Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/country_list'));
    if (response.statusCode == 200) {
      setState(() {
        final userMap = json.decode(response.body);
        final user = CountryModel.fromJson(userMap);

        _country = user.data!;

        // final countryData = CountryModel();
        // print("countryData~~${countryData}");
        //
        // for (var country in user.data!) {
        //   if (country.countryName != null) {
        //     // _country.add(country.countryName);
        //     //  countryList = country.countryName;
        //   }
        // }

        setState(() {
          // countries.map((country) => country.countryName ?? "").toList();
          // countries = user.data ?? [];
          // for(var add in countryData.data. ?? []){
          //   countries.add()
          // }
        });
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
        _state = user.data!;
      });
    } else {
      throw Exception('Failed to load state');
    }
  }

  Future<void> fetchEducation() async {
    final url = Uri.parse(
        '${Webservices.baseUrl}${Webservices.educationList}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        final userMap = json.decode(response.body);
        final user = EducationsModel.fromJson(userMap);
        _education = user.data!;

        final selectedIdsString = widget.selectedEducation?.split(',') ?? [];
        final selectedIds = selectedIdsString.map((id) {
          try {
            return int.parse(id);
          } catch (e) {
            print('Error parsing id "$id": $e');
            return null;
          }
        }).where((id) => id != null).toSet();

        _selectedEducation = _education.map((e) => selectedIds.contains(e.id)).toList();
        educationKey = selectedIds.join(",");
        print("widget.selectedEducation: $educationKey");

        // _selectedEducation =
        //     List.generate(_occupation.length, (index) => false);
        // Initialize _selectedEducation based on widget.selectedEducation
        // final selectedIds = widget.selectedEducation!.split(',').map((id) => int.parse(id)).toSet();
        // _selectedEducation = _education.map((e) => selectedIds.contains(e.id)).toList();
        // educationKey = selectedIds.join(",");
        // print("widget.selectedEducation: $educationKey");
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
            final selectedIdsString = widget.selectedProfession?.split(',') ?? [];
            final selectedIds = selectedIdsString.map((id) {
              try {
                return int.parse(id);
              } catch (e) {
                print('Error parsing id "$id": $e');
                return null; // Return null if parsing fails
              }
            }).where((id) => id != null).toSet();

            _selectedOccupation = _occupation.map((e) => selectedIds.contains(e.id)).toList();
            professionKey = selectedIds.join(",");
        // _selectedOccupation =
        //     List.generate(_occupation.length, (index) => false);
        //     final selectedIds = widget.selectedProfession!.split(',').map((id) => int.parse(id)).toSet();
        //     _selectedOccupation = _occupation.map((e) => selectedIds.contains(e.id)).toList();
        //     professionKey = selectedIds.join(",");
        //     print("widget.selectedEducation: $professionKey");
    } else {
      throw Exception('Failed to load occupation_list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3, key: Key("new"), valueColor: AlwaysStoppedAnimation( AppColor.mainAppColor),
    );
  }

  // @override
  Widget _uiSetup(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 7,
          child: Container(
          /*  decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/images/bg_pink.jpg",
                  ),
                  fit: BoxFit.fill),
            ),*/
            color:AppColor.mainAppColor,
            child: Container(
              height: 950,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: 8, right: 8),
                child:/*iLoaded? Center(
                  child: CircularProgressIndicator(
                    color: AppColor.buttonColor,
                  ),
                ):*/ Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                   /* Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: EdgeInsets.only(right: 13),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context,{
                              'keyword': searchController.text??" ",
                              // 'country_id':countryId ?? 0,
                              // 'state':_selectedState?.state??"",
                              'gender': genderKey.isNull ?"1":genderKey.toString(),
                              'photo_available':photoKey.isNull ?"1":photoKey.toString(),
                              'marital_status[]': maritalKey.isNull?"":maritalKey.toString(),
                              'diet[]':dietKey??" ",
                              'body_type[]':bodyKey??" ",
                              'complexion[]':complexionKey??" ",
                              'religion_id':religionKey.isNull?" ":religionKey.toString(),
                              'education_id[]':educationKey??" ",
                              'profession_id[]':professionKey??" ",
                              'income':incomeKey.isNull? " ":incomeKey.toString(),
                              'start_age': _ageRange.start.toInt().toString()??0,
                              'end_age':_ageRange.end.toInt().toString()??0,
                            });
                           *//* try {
                              var data =postData();
                              // _bottomSheetClosed(data);
                              Navigator.pop(context, data);
                              print("DATA~~~${data}");
                            } catch (e) {
                              print('Error occurred: $e');
                            }*//*
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                               AppColor.mainText),
                          ),
                          child: Text(
                            "Submit",
                            style: AppTheme.buttonBold(),
                          ),
                        ),
                      ),
                    ),*/
                    buildTitle("Search By Name, Email, Phone"),
                    Container(
                      margin: EdgeInsets.all(15),
                      decoration: AppTheme.ConDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              onChanged: (text) {
                                print("searchController${searchController.text}");
                              },
                              decoration: InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),color: AppColor.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Gender"),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: RadioListTile(
                                  activeColor: AppColor.mainText,
                                  title: Text("Male"),
                                  value: "male",
                                  groupValue:_selectedGender,
                                  onChanged: (value){
                                    setState(() {
                                      _selectedGender=value;
                                      genderKey = 1.toString();
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: RadioListTile(
                                  activeColor: AppColor.mainText,
                                  title: Text("Female"),
                                  value: "female",
                                  groupValue: _selectedGender,
                                  onChanged: (value){
                                    setState(() {
                                      _selectedGender=value;
                                      genderKey = 2.toString();
                                      print("genderKey!!${genderKey}");
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12,),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),color: AppColor.white),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTitle("Country"),
                                Container(
                                  padding: EdgeInsets.only(left: 23,right: 23),
                                  // padding: EdgeInsets.symmetric(horizontal: 15,vertical: 0),
                                  margin: EdgeInsets.all(3),
                                  decoration: AppTheme.ConDecoration(),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      DropdownMenu<CountryData>(
                                        // textStyle: AppTheme.profileText(),
                                        // Adjust the width to accommodate the arrow
                                        width: 140,
                                        trailingIcon: Icon(Icons.keyboard_arrow_down,color: Colors.black,),
                                        menuStyle: MenuStyle(padding: MaterialStatePropertyAll(EdgeInsets.all(15))),
                                        inputDecorationTheme: InputDecorationTheme(border: UnderlineInputBorder(borderRadius: BorderRadius.circular(0))),
                                        hintText: "Please Select",
                                        // controller: menuController,
                                        menuHeight: 240,
                                        enableFilter: true,
                                        onSelected: (CountryData? menu) {
                                          setState(() {
                                            _selectedCountry = menu;
                                            fetchState(_selectedCountry!.id);
                                          });
                                        },
                                        dropdownMenuEntries:
                                        _country.map<DropdownMenuEntry<CountryData>>((CountryData menu) {
                                          return DropdownMenuEntry<CountryData>(
                                            value: menu,
                                            label: menu.countryName.toString(),
                                          );
                                          // leadingIcon: Icon(menu.countryName.toString()));
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            /* Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.all(6),
                              decoration: AppTheme.ConDecoration(),
                              child: DropdownButton<CountryData>(
                                borderRadius: BorderRadius.circular(12),
                                isExpanded: true,
                                value: _selectedCountry,
                                hint: Text('Please Select'),
                                underline: Column(),
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.black),
                                onChanged: (CountryData? newValue) {
                                  setState(() {
                                    _selectedCountry = newValue;
                                    countryId = _selectedCountry!.id!;
                                    fetchState(_selectedCountry!.id);
                                  });
                                },
                                items: _country.map<DropdownMenuItem<CountryData>>(
                                    (CountryData country) {
                                  return DropdownMenuItem<CountryData>(
                                    value: country,
                                    child: Text(country.countryName!),
                                  );
                                }).toList(),
                              ),
                            ),*/
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildTitle("State"),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  margin: EdgeInsets.all(6),
                                  decoration: AppTheme.ConDecoration(),
                                  child: DropdownButton<StateData>(
                                    borderRadius: BorderRadius.circular(12),
                                    isExpanded: true,
                                    value: _selectedState,
                                    hint: Text('Please Select'),
                                    underline: Column(),
                                    icon: const Icon(Icons.keyboard_arrow_down,
                                        color: Colors.black),
                                    onChanged: (StateData? newValue) {
                                      setState(() {
                                        _selectedState = newValue;
                                        print("_selectedState   ${_selectedState?.state!.isEmpty}");
                                      });
                                    },
                                    items: _state.map<DropdownMenuItem<StateData>>(
                                        (StateData state) {
                                      return DropdownMenuItem<StateData>(
                                        value: state,
                                        child: Text(state.state!),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 12,
                    ),
                     Container(
                       decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),color: AppColor.white),
                       child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Age",),
                          Column(
                            children: [
                              RangeSlider(
                                inactiveColor:AppColor.sliderColor,
                                activeColor: AppColor.mainText,
                                values: _ageRange,
                                min: 18,
                                max: 100,
                                divisions: 82,
                                labels: RangeLabels(
                                  '${_ageRange.start.toInt()}',
                                  '${_ageRange.end.toInt()}',
                                ),
                                onChanged: (RangeValues newRange) {
                                  setState(() {
                                    _ageRange = newRange;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                    ),
                     ),
                    SizedBox(
                      height: 12,
                    ),
                     Divider(height: 8),
                    _heightKeys.isEmpty || _heightRange == null
                        ? Center(child: Text('No height keys available')):  Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Height",),
                          Column(
                            children: [
                              RangeSlider(
                                inactiveColor: Colors.grey,
                                activeColor: AppColor.mainText,
                                values: _heightRange ?? RangeValues(0, 0),
                                min: 1,
                                max: (_heightKeys.length - 1).toDouble(),
                                divisions: _heightKeys.length - 1,
                                labels: RangeLabels(
                                  _heightList[_heightKeys[_heightRange?.start.toInt() ?? 0]] ?? '',
                                  _heightList[_heightKeys[_heightRange?.end.toInt() ?? 0]] ?? '',
                                ),
                                onChanged: (RangeValues newRange) {
                                  setState(() {
                                    _heightRange = newRange;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  /*  Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),color: AppColor.white),
                  child:  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         buildTitle("Age"),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                margin: EdgeInsets.all(6),
                                decoration: BoxDecoration(border: Border.all(width: 1,),borderRadius: BorderRadius.circular(30)),
                                // decoration: AppTheme.ConDecoration(),
                                child: DropdownButton<String>(
                                  menuMaxHeight: 170,
                                  borderRadius: BorderRadius.circular(12),
                                  isExpanded: true,
                                  value: _selectedAge,
                                  hint: Text('Please Select'),
                                  underline: Column(),
                                  icon: const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.black),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedAge = newValue!;
                                      print("_selectedAge$_selectedAge");
                                    });
                                  },
                                  items: ageOptions
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Text("To",),
                            Expanded(
                                child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              margin: EdgeInsets.all(6),decoration: BoxDecoration(border: Border.all(width: 1,),borderRadius: BorderRadius.circular(30)),
                              // decoration: AppTheme.ConDecoration(),
                              child: DropdownButton<String>(
                                menuMaxHeight: 170,
                                borderRadius: BorderRadius.circular(12),
                                isExpanded: true,
                                value: _selectedAgeS,
                                hint: Text('Please Select'),
                                underline: Column(),
                                icon: const Icon(Icons.keyboard_arrow_down,
                                    color: Colors.black),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAgeS = newValue!;
                                    print("_selectedAgeS${_selectedAgeS}");
                                  });
                                },
                                items: ageOptions
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                      ),
                    SizedBox(
                      height: 12,
                    ),*/

                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),color: AppColor.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Income"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 22),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(border: Border.all(width: 1,),borderRadius: BorderRadius.circular(30)),
                            // decoration: AppTheme.ConDecoration(),
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(12),
                              isExpanded: true,
                              value: _selectedIncome,
                              hint: Text('Please Select'),
                              underline:SizedBox.shrink(),
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedIncome = newValue;
                                  for (var entry in _incomeList.entries) {
                                    if (entry.value == newValue) {
                                      incomeKey = entry.key;
                                      print("INCOME!!!!${incomeKey}");
                                      break;
                                    }
                                  }
                                });
                              },
                              items: incomeOptions
                                  .map<DropdownMenuItem<String>>((String value) {
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
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),color: AppColor.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Religion"),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 22),
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(border: Border.all(width: 1,),borderRadius: BorderRadius.circular(30)),
                            // decoration: AppTheme.ConDecoration(),
                            child: DropdownButton<String>(
                              borderRadius: BorderRadius.circular(12),
                              isExpanded: true,
                              value: _selectedValue,
                              hint: const Text('Please Select'),
                              underline: Column(),
                              icon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedValue = newValue;

                                  for (var entry in _religionList.entries) {
                                    if (entry.value == newValue) {
                                      religionKey = entry.key;
                                      print("Religion!!!!${religionKey}");
                                      break;
                                    }
                                  }
                                });
                              },
                              items: religionOptions
                                  .map<DropdownMenuItem<String>>((String value) {
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
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(13),color: AppColor.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildTitle("Photo Available"),
                          Row(
                            children: photoOptions.map((option) {
                              return Expanded(
                                child: RadioListTile<String>(
                                  activeColor: MaterialStateColor.resolveWith(
                                      (states) => AppColor.mainText),
                                  title: Text(option),
                                  value: option,
                                  groupValue: _selectedPhoto,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _selectedPhoto = value;
                                      setState(() {
                                        print("option~~~$option");
                                        if (_selectedPhoto == "Yes") {
                                          photoKey = 1.toString();
                                        } else {
                                          photoKey = 0.toString();
                                        }
                                      });
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, thickness: 1),
                    ExpansionTile(
                      title: buildTitle("Body Type"),
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (bodyTypeOptions.length / 2).ceil(),
                          itemBuilder: (context, index) => Card(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    checkColor: Colors.white,
                                    activeColor:AppColor.mainText,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    value: _selectedBodyType.length > index * 2
                                        ? _selectedBodyType[index * 2]
                                        : false,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_selectedBodyType.length <= index * 2) {
                                          _selectedBodyType.addAll(
                                              List<bool>.generate(
                                                  index * 2 -
                                                      _selectedBodyType.length +
                                                      1,
                                                  (_) => false));
                                        }
                                        _selectedBodyType[index * 2] = value!;

                                        List<int> selectedIndices = [];
                                        for (int i = 0;i < _selectedBodyType.length;i++) {
                                          if (_selectedBodyType[i]) {
                                            selectedIndices.add(i + 1);
                                          }
                                        }
                                        print("_selectedBodyType${selectedIndices}");
                                        bodyKey = selectedIndices.join(',');
                                      });
                                    },
                                    title: Text(
                                      bodyTypeOptions[index * 2],
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                if ((index * 2 + 1) < bodyTypeOptions.length)
                                  Expanded(
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor:AppColor.mainText,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: _selectedBodyType.length > index * 2 + 1
                                          ? _selectedBodyType[index * 2 + 1]
                                          : false,
                                      onChanged: (value) {
                                        setState(() {
                                          if (_selectedBodyType.length <=
                                              index * 2 + 1) {
                                            _selectedBodyType.addAll(
                                                List<bool>.generate(
                                                    index * 2 +
                                                        2 -
                                                        _selectedBodyType.length,
                                                    (_) => false));
                                          }
                                          _selectedBodyType[index * 2 + 1] = value!;
                                          List<int> selectedIndices = [];

                                          for (int i = 0;
                                              i < _selectedBodyType.length;
                                              i++) {
                                            if (_selectedBodyType[i]) {
                                              selectedIndices.add(i + 1);
                                            }
                                          }
                                          bodyKey = selectedIndices.join(',');
                                          print(
                                              "_selectedBodyType${selectedIndices}");
                                        });
                                      },
                                      title: Text(
                                        bodyTypeOptions[index * 2 + 1],
                                        style: const TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1, thickness: 1),
                    ExpansionTile(
                      title: buildTitle("Complexion"),
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (complexionOptions.length / 2).ceil(),
                          itemBuilder: (context, index) => Card(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    checkColor: Colors.white,
                                    activeColor:AppColor.mainText,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    value: _selectedComplexion.length > index * 2
                                        ? _selectedComplexion[index * 2]
                                        : false,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_selectedComplexion.length <= index * 2) {
                                          _selectedComplexion.addAll(
                                              List<bool>.generate(
                                                  index * 2 -
                                                      _selectedComplexion.length +
                                                      1,
                                                  (_) => false));
                                        }
                                        _selectedComplexion[index * 2] = value!;
                                        List<int> selectedIndices = [];
                                        for (int i = 0;
                                            i < _selectedComplexion.length;
                                            i++) {
                                          if (_selectedComplexion[i]) {
                                            selectedIndices.add(i + 1);
                                          }
                                        }
                                        complexionKey = selectedIndices.join(',');
                                      });
                                    },
                                    title: Text(
                                      complexionOptions[index * 2],
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                                if ((index * 2 + 1) < complexionOptions.length)
                                  Expanded(
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor:AppColor.mainText,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value:
                                          _selectedComplexion.length > index * 2 + 1
                                              ? _selectedComplexion[index * 2 + 1]
                                              : false,
                                      onChanged: (value) {
                                        setState(() {
                                          if (_selectedComplexion.length <=
                                              index * 2 + 1) {
                                            _selectedComplexion.addAll(
                                                List<bool>.generate(
                                                    index * 2 +
                                                        2 -
                                                        _selectedComplexion.length,
                                                    (_) => false));
                                          }
                                          _selectedComplexion[index * 2 + 1] = value!;
                                          List<int> selectedIndices = [];
                                          for (int i = 0;
                                              i < _selectedComplexion.length;
                                              i++) {
                                            if (_selectedComplexion[i]) {
                                              selectedIndices.add(i + 1);
                                            }
                                          }
                                          complexionKey = selectedIndices.join(',');
                                        });
                                      },
                                      title: Text(
                                        complexionOptions[index * 2 + 1],
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1, thickness: 1),
                    ExpansionTile(
                      title: buildTitle("Diet"),
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (dietOptions.length / 2).ceil(),
                          itemBuilder: (context, index) => Card(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    checkColor: Colors.white,
                                    activeColor:AppColor.mainText,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    value: _selectedDiet.length > index * 2
                                        ? _selectedDiet[index * 2]
                                        : false,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_selectedDiet.length <= index * 2) {
                                          _selectedDiet.addAll(List<bool>.generate(
                                              index * 2 - _selectedDiet.length + 1,
                                              (_) => false));
                                        }
                                        _selectedDiet[index * 2] = value!;
                                        List<String> dietListKey = [];
                                        for (int i = 0;
                                            i < _selectedDiet.length;
                                            i++) {
                                          if (_selectedDiet[i]) {
                                            dietListKey
                                                .add(_dietList.keys.elementAt(i));
                                          }
                                        }
                                        print("dietListKey${dietListKey}");
                                        dietKey = dietListKey.join(",");
                                      });
                                    },
                                    title: Text(
                                      dietOptions[index * 2],
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                                if ((index * 2 + 1) < dietOptions.length)
                                  Expanded(
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor:AppColor.mainText,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: _selectedDiet.length > index * 2 + 1
                                          ? _selectedDiet[index * 2 + 1]
                                          : false,
                                      onChanged: (value) {
                                        setState(() {
                                          if (_selectedDiet.length <= index * 2 + 1) {
                                            _selectedDiet.addAll(List<bool>.generate(
                                                index * 2 + 2 - _selectedDiet.length,
                                                (_) => false));
                                          }
                                          _selectedDiet[index * 2 + 1] = value!;
                                          List<String> dietListKey = [];
                                          for (int i = 0;
                                              i < _selectedDiet.length;
                                              i++) {
                                            if (_selectedDiet[i]) {
                                              dietListKey.add(
                                                  _dietList.keys.elementAt(i));
                                            }
                                          }
                                          dietKey = dietListKey.join(",");
                                        });
                                      },
                                      title: Text(
                                        dietOptions[index * 2 + 1],
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1, thickness: 1),
                    ExpansionTile(
                      title: buildTitle("Education"),
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (_education.length / 2).ceil(),
                          itemBuilder: (context, index) {
                            final education = _education[index];
                            int firstIndex = index * 2;
                            int secondIndex = index * 2 + 1;
                            return Card(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor:AppColor.mainText,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: _selectedEducation.length > firstIndex
                                          ? _selectedEducation[firstIndex]
                                          : false,
                                      onChanged: (value) {
                                        setState(() {
                                          if (_selectedEducation.length <=
                                              firstIndex) {
                                            _selectedEducation.addAll(
                                                List<bool>.generate(
                                                    firstIndex -
                                                        _selectedEducation.length +
                                                        1,
                                                    (_) => false));
                                          }
                                          _selectedEducation[firstIndex] =
                                              value ?? false;
                                          // educationKey =
                                          //     _education[firstIndex].id.toString();
                                          educationKey = _selectedEducation
                                              .asMap()
                                              .entries
                                              .where((entry) => entry.value)
                                              .map((entry) => _education[entry.key].id.toString())
                                              .join(",");
                                          print("educationKey: $educationKey");

                                        });
                                      },
                                      title: Text(
                                        _education[firstIndex].education!,
                                        style: const TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  if (secondIndex < _education.length)
                                    Expanded(
                                      child: CheckboxListTile(
                                        checkColor: Colors.white,
                                        activeColor:AppColor.mainText,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value: _selectedEducation.length > secondIndex
                                            ? _selectedEducation[secondIndex]
                                            : false,
                                        onChanged: (value) {
                                          setState(() {
                                            if (_selectedEducation.length <=
                                                secondIndex) {
                                              _selectedEducation.addAll(
                                                  List<bool>.generate(
                                                      secondIndex -
                                                          _selectedEducation.length +
                                                          1,
                                                      (_) => false));
                                            }
                                            _selectedEducation[secondIndex] =
                                                value ?? false;
                                            educationKey = _selectedEducation
                                                .asMap()
                                                .entries
                                                .where((entry) => entry.value)
                                                .map((entry) => _education[entry.key].id.toString())
                                                .join(",");
                                            print("educationKey: $educationKey");
                                          });
                                        },
                                        title: Text(
                                          _education[secondIndex].education!,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Divider(height: 1, thickness: 1),
                    ExpansionTile(
                      title: buildTitle("Profession"),
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (_occupation.length / 2).ceil(),
                          itemBuilder: (context, index) {
                            int firstIndex = index * 2;
                            int secondIndex = index * 2 + 1;
                            return Card(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor:AppColor.mainText,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: _selectedOccupation.length > firstIndex
                                          ? _selectedOccupation[firstIndex]
                                          : false,
                                      onChanged: (value) {
                                        setState(() {
                                          if (_selectedOccupation.length <=
                                              firstIndex) {
                                            _selectedOccupation.addAll(
                                                List<bool>.generate(
                                                    firstIndex -
                                                        _selectedOccupation.length +
                                                        1,
                                                    (_) => false));
                                          }
                                          _selectedOccupation[firstIndex] =
                                              value ?? false;
                                          professionKey = _selectedOccupation
                                              .asMap()
                                              .entries
                                              .where((entry) => entry.value)
                                              .map((entry) => _occupation[entry.key].id.toString())
                                              .join(",");
                                          print("educationKey: $professionKey");
                                          // professionKey =
                                          //     _occupation[firstIndex].id.toString();
                                          // print(
                                          //     "_selectedOccupation${_occupation[firstIndex].id}");
                                        });
                                      },
                                      title: Text(
                                        _occupation[firstIndex].occupation!,
                                        style: const TextStyle(color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                  if (secondIndex < _occupation.length)
                                    Expanded(
                                      child: CheckboxListTile(
                                        checkColor: Colors.white,
                                        activeColor:AppColor.mainText,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        value:
                                            _selectedOccupation.length > secondIndex
                                                ? _selectedOccupation[secondIndex]
                                                : false,
                                        onChanged: (value) {
                                          setState(() {
                                            if (_selectedOccupation.length <=
                                                secondIndex) {
                                              _selectedOccupation.addAll(
                                                  List<bool>.generate(
                                                      secondIndex -
                                                          _selectedOccupation.length +
                                                          1,
                                                      (_) => false));
                                            }
                                            _selectedOccupation[secondIndex] =
                                                value ?? false;
                                            professionKey = _selectedOccupation
                                                .asMap()
                                                .entries
                                                .where((entry) => entry.value)
                                                .map((entry) => _occupation[entry.key].id.toString())
                                                .join(",");
                                            print("educationKey: $professionKey");
                                            // professionKey = _occupation[secondIndex]
                                            //     .id
                                            //     .toString();
                                            // print(
                                            //     "_selectedOccupation${_occupation[secondIndex].id}");
                                          });
                                        },
                                        title: Text(
                                          _occupation[secondIndex].occupation!,
                                          style: const TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Divider(height: 1, thickness: 1),
                    ExpansionTile(
                      title: buildTitle("Marital Status"),
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: (maritalStatusOption.length / 2).ceil(),
                          itemBuilder: (context, index) => Card(
                            child: Row(
                              children: [
                                Expanded(
                                  child: CheckboxListTile(
                                    checkColor: Colors.white,
                                    activeColor:AppColor.mainText,
                                    controlAffinity: ListTileControlAffinity.leading,
                                    value: _selectedMaritalStatus.length > index * 2
                                        ? _selectedMaritalStatus[index * 2]
                                        : false,
                                    onChanged: (value) {
                                      setState(() {
                                        if (_selectedMaritalStatus.length <=
                                            index * 2) {
                                          _selectedMaritalStatus.addAll(
                                            List<bool>.generate(
                                                index * 2 -
                                                    _selectedMaritalStatus.length +
                                                    1,
                                                (_) => false),
                                          );
                                        }
                                        _selectedMaritalStatus[index * 2] = value!;
                                        List<String> selectedMaritalKey = [];
                                        selectedMaritalKey.clear();

                                        for (int i = 0;
                                            i < _selectedMaritalStatus.length;
                                            i++) {
                                          if (_selectedMaritalStatus[i]) {
                                            selectedMaritalKey
                                                .add(_maritalList.keys.elementAt(i));
                                          }
                                        }

                                        String selectedKeysString =
                                            selectedMaritalKey.join(",");
                                        print(
                                            "selectedMaritalKey: $selectedKeysString");
                                        maritalKey = selectedMaritalKey.join(",");
                                      });
                                    },
                                    title: Text(
                                      maritalStatusOption[index * 2],
                                      style: const TextStyle(color: Colors.black87),
                                    ),
                                  ),
                                ),
                                if ((index * 2 + 1) < maritalStatusOption.length)
                                  Expanded(
                                    child: CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor:AppColor.mainText,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: _selectedMaritalStatus.length >
                                              index * 2 + 1
                                          ? _selectedMaritalStatus[index * 2 + 1]
                                          : false,
                                      onChanged: (value) {
                                        setState(() {
                                            _selectedMaritalStatus[index * 2 + 1] =
                                                value!;
                                            List<String> selectedMaritalKey = [];
                                            selectedMaritalKey.clear();

                                            for (int i = 0;
                                                i < _selectedMaritalStatus.length;
                                                i++) {
                                              if (_selectedMaritalStatus[i]) {
                                                selectedMaritalKey.add(
                                                    _maritalList.keys.elementAt(i));
                                              }
                                            }

                                            maritalKey = selectedMaritalKey.join(",");
                                        });
                                      },
                                      title: Text(
                                        maritalStatusOption[index * 2 + 1],
                                        style: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(child:Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(0),color: AppColor.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Clear all",
                    style: TextStyle( fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColor.mainText,
                        fontFamily: FontName.poppinsRegular),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 30,right: 30,top: 14,bottom: 14),
                      shape: RoundedRectangleBorder(side: BorderSide(width: 2,color: AppColor.mainText),
                        borderRadius: BorderRadius.circular(28,),),
                      backgroundColor:AppColor.white),
                ),
              ),
              Container(
                margin: EdgeInsets.all(13),
                child: ElevatedButton(
                  onPressed: () async {
                    // old code.....
                    // postData();
                    // try {
                    //   var data = /*await*/ postData();
                    //   _bottomSheetClosed(data);
                    //   Navigator.pop(context, data);
                    //   print("DATA~~~${data}");
                    // } catch (e) {
                    //   print('Error occurred: $e');
                    // }

                    Navigator.pop(context,{
                      // 'keyword': searchController.text??" ",
                      'country_id':_selectedCountry?.id.toString() ?? "",
                      'state':_selectedState?.state??"",
                      'gender': genderKey.isNull ?"1":genderKey.toString(),
                      'photo_available':photoKey.isNull ?"1":photoKey.toString(),
                      'marital_status': maritalKey.isNull?"":maritalKey.toString(),
                      'diet':dietKey??"",
                      'body_type':bodyKey??"",
                      'complexion':complexionKey??"",
                      'religion_id':religionKey.isNull?"":religionKey.toString(),
                      'education_id':educationKey??"",
                      'profession_id':professionKey??" ",
                      'income':incomeKey.isNull ? "" : incomeKey,
                      'start_age': _selectedAge?? "",
                      'end_age':_selectedAgeS??"",
                      // if(selectedKey1!="")
                      //   'height':'${selectedKey1.toString().isNull ? '4' : selectedKey1.toString()}-${selectedKey2.isNull ? '6' : selectedKey2}',
                    });
                  },
                  child: Text(
                    "Apply",
                    style: AppTheme.buttonBold(),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(left: 35,right: 35,top: 14,bottom: 14),
                      shape: RoundedRectangleBorder(side: BorderSide(width: 0,color: AppColor.mainAppColor),
                        borderRadius: BorderRadius.circular(28,),
                      ),
                      backgroundColor:AppColor.mainText),
                  // style: ButtonStyle(
                  //   backgroundColor: MaterialStatePropertyAll(
                  //       AppColor.newAppMain1),
                  // ),
                ),
              ),
            ],
          ),
        ),
        ),
      ],
    );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 9),
      child: Text(title, style: AppTheme.nextBold()),
    );
  }
}
