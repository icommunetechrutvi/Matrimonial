import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/bottom_sheet_screen/view_model/country_model.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/educations_model.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/occupation_model.dart';
import 'package:matrimony/bottom_sheet_screen/view_model/state_model.dart';
import 'package:matrimony/login_screen/view_model/LoginModel.dart';
import 'package:matrimony/login_screen/view_model/RegisterComplete%20Model.dart';
import 'package:matrimony/search_screen/search_screen.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  var mobileNumber;
  var profileId;

   RegisterScreen({required this.mobileNumber,required this.profileId});

  @override
  State<RegisterScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<RegisterScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dOBController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool isFirstNameEnabled = true;
  bool isLastNameEnabled = false;
  bool isDOBEnabled = false;
  bool isEmailEnabled = false;
  bool isPasswordEnabled = false;
  bool isHeightEnabled = false;


  bool isReligionEnabled = true;
  bool isEducationEnabled = false;
  bool isProfessionEnabled = false;
  bool isCountryEnabled = false;
  bool isStateEnabled = false;
  bool isCityEnabled = false;
  bool isAddressEnabled = false;

  Timer? _firstNameDebounce;
  Timer? _lastNameDebounce;

  List<String> heightList = [];
  List<String> heightKeys = [];
  String? _selectedHeight;
  late String selectedKey = '';

  List<String> religionList = [];
  List<String> religionKeys = [];
  String? _selectedReligion;
  late String selectedReligionKey = '';


  List<EducationsData> _education = [];
  EducationsData? _selectedEducation;
  String? _selectedEducationId;

  List<OccupationData> _occupation = [];
  OccupationData? _selectedOccupation;
  String? _selectedOccupationId;

  StateData? _selectState;
  List<StateData> stateList = [];

  bool _isLoading = false;
  late var deviceTokenToSendPushNotification = "";
  String? _selectedGender = "";
  String? genderKey;

  List<CountryData> countryList = [];
  CountryData? _selectedCountry;


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int _currentStep = 0;


  @override
  void initState() {
    super.initState();
    fetchCountry();
    fetchEducation();
    fetchOccupation();
    fetchGlobalValues();
    setState(() {
      getDeviceIdSendNotification();
    });
    print("userID${widget.profileId}");
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dOBController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _onFirstNameChanged(String keyName,String values)async {
    if (_firstNameDebounce?.isActive ?? false) _firstNameDebounce?.cancel();
    _firstNameDebounce = Timer(const Duration(milliseconds: 900), () {
      if (values.isNotEmpty) {
        // AppTheme.showAlert("first_name + ${values}");
        // AppTheme.showAlert("profile_id + ${widget.profileId}");
        // postRegistrationApis(value, "firstName");
      }
      profileFieldsUpdateApi(keyName,values);
      _updateFieldStates();
    });
  }

  Future<dynamic> profileFieldsUpdateApi(String keyName,String valueName) async {
    var url = Uri.parse( '${Webservices.baseUrl+Webservices.profileFieldsUpdate}');
    print("url~~${url}");
    var jsonData = json.encode({
      'key': keyName,
      'profile_id': 62,//widget.profileId,
      'value': valueName,

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
        final userMap = json.decode(response.body);
        setState(() {
          // AppTheme.showAlert("OTP SEND");
        });
      }else if(response.statusCode == 409) {
        setState(() {
          AppTheme.showInvalidAlert("Mobile number already registered");
          Navigator.pop(context);
        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }

  Future<void> getDeviceIdSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value!!!!!!!! $deviceTokenToSendPushNotification");
  }
  void _updateFieldStates() {
    setState(() {
      isLastNameEnabled = _firstNameController.text.isNotEmpty;
      isDOBEnabled = isLastNameEnabled && _lastNameController.text.isNotEmpty;
      isEmailEnabled = isDOBEnabled && _dOBController.text.isNotEmpty;
      isPasswordEnabled = isEmailEnabled && _emailController.text.isNotEmpty;
      isHeightEnabled = isPasswordEnabled && _passwordController.text.isNotEmpty;

      isEducationEnabled= isReligionEnabled && selectedReligionKey.isNotEmpty;
      isProfessionEnabled= isEducationEnabled && _selectedEducation!=null;
      isCountryEnabled= isProfessionEnabled && _selectedOccupation!=null;
      isStateEnabled= isCountryEnabled && _selectedCountry!=null;
      isCityEnabled= isStateEnabled && _selectState!=null;
      isAddressEnabled= isCityEnabled && cityController.text.isNotEmpty;
    });
  }

  Future<void> fetchGlobalValues() async {
    final url = Uri.parse('${Webservices.baseUrl + Webservices.globalValue}');
    final response = await http.get(url);
    print("url~~${url}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      Map<String, dynamic> heightLists = responseData['data']['height_list'];
      heightLists.forEach((key, value) {
        heightList.add(value as String);
        heightKeys.add(key);
      });

      Map<String, dynamic> religionLists =
      responseData['data']['religion_list'];
      religionLists.forEach((key, value) {
        religionList.add(value as String);
        religionKeys.add(key);
      });
    } else {
      throw Exception('Failed to load income options');
    }
  }
  Future<void> fetchEducation() async {
    final url = Uri.parse('${Webservices.baseUrl+Webservices.educationList}');
    print("url~~${url}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        final userMap = json.decode(response.body);
        final user = EducationsModel.fromJson(userMap);
        _education = user.data!;
      });
    } else {
      throw Exception('Failed to load education_list');
    }
  }
  Future<void> fetchOccupation() async {
    final url = Uri.parse('${Webservices.baseUrl+Webservices.occupationList}');
    print("url~~${url}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final userMap = json.decode(response.body);
      final occupationModel = OccupationModel.fromJson(userMap);
      _occupation = occupationModel.data!;
    } else {
      throw Exception('Failed to load occupation_list');
    }
  }
  Future<void> fetchCountry() async {
    final url=Uri.parse('${Webservices.baseUrl+Webservices.countryList}');
    final response = await http.get(url);
    print("url~~${url}");
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
        '${Webservices.baseUrl+Webservices.stateList+countryId.toString()}');
    print("url~~${url}");
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

  void _nextStep() {
    if (_currentStep < 1) {
      setState(() {
        _currentStep += 1;
      });
    }
  }
  void _backStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
       child: Container(
         color: AppColor.mainAppColor,
         child: PageView(
           children: [
             if (_currentStep == 0) _build1(),
             if (_currentStep == 1) _build2(),
             // if (_currentStep == 2) _build3(),
           ],
         ),
       ),
       /* child: Container(
          color: AppColor.mainAppColor,
          child: Center(
            child: Card(
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.white
                ), padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 350),
                child: PageView(
                 children: [
                   if (_currentStep == 0) _buildPersonalInfoFields(),
                   if (_currentStep == 1) _buildAdditionalInfoFields(),
                   if (_currentStep == 2) _buildAdditionalInfoField(),

                 ],
                ),
              ),
            ),
          ),
        ),*/
      ),
    );
  }

  Widget _build1() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Card(
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16,horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "FREE REGISTRATION!",
                      style: AppTheme.nameText1(),
                    ),
                  ),
                    FloatingActionButton(backgroundColor:AppColor.mainText,onPressed: () {
                      Navigator.pop(context);
                    },child: Icon(Icons.arrow_back)),
                ],),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 0),
                  //   child: Text(
                  //     "Your partner search begins with a",
                  //     textAlign: TextAlign.center,
                  //     style: AppTheme.profileTexts(),
                  //   ),
                  // ),
                  _gap(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "STEP 1 ----  ",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                             color:_currentStep==-1?AppColor.black:Colors.grey,
                            fontFamily: FontName.poppinsRegular),
                      ),
                      Text(
                        "  STEP 2 ----  ",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:_currentStep==-1?AppColor.grey:Colors.black,
                            fontFamily: FontName.poppinsRegular),
                      ),
                      Text(
                        "  STEP 3",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:_currentStep==-1?AppColor.black:Colors.grey,
                            fontFamily: FontName.poppinsRegular),
                      ),
                    ],
                  ),
                  _gap(),
                  _gap(),
                  TextFormField(
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                      // if (value.isNotEmpty) {
                      //   postRegistrationApis(value);
                      // }
                      // _updateFieldStates();
                      // postRegistrationApis(value);
                      _onFirstNameChanged("first_name",value);
                    },
                    enabled: isFirstNameEnabled,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isFirstNameEnabled ? Colors.blue : Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.none,
                    onChanged:
                        (value) {
                          _onFirstNameChanged("last_name",value);
                          // _onFirstNameChanged(value);
                        },
                    enabled: isLastNameEnabled,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isLastNameEnabled ? Colors.blue : Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Align(
                      alignment: Alignment.topLeft, child: Text("Gender")),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: RadioListTile(
                          activeColor: AppColor.radioButton,
                          title: Text("Male"),
                          value: "male",
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              genderKey = 1.toString();
                              _onFirstNameChanged("gender",genderKey!);
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: RadioListTile(
                          activeColor: AppColor.radioButton,
                          title: Text("Female"),
                          value: "female",
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              genderKey = 2.toString();
                              _onFirstNameChanged("gender",genderKey!);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.0),
                  TextField(
                    controller: _dOBController,
                    textCapitalization: TextCapitalization.none,
                    onTap: () async {
                    if(genderKey.isNull){
                      AppTheme.showInvalidAlert("Please First Select Gender.");
                    }
                   else {
                      if (isDOBEnabled) {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          // initialDate: DateTime.now(),
                          initialDate:  _selectedGender == "male"? DateTime(2003, 1, 1):DateTime(2006, 1, 1),
                          firstDate: DateTime(1950),
                          // lastDate: DateTime.now(),
                          lastDate: DateTime( _selectedGender == "male" ? 2003 : 2006),
                        );
                        if (picked != null) {
                          final newDate = "${picked.year}-${picked
                              .month}-${picked.day}";
                          if (newDate.isNotEmpty) {
                            _dOBController.text = newDate;
                            // _updateFieldStates();
                            _onFirstNameChanged("date_of_birth", newDate);
                          }
                        }
                      }
                    }
                    },
                    readOnly: true,
                    enabled: isDOBEnabled,
                    decoration: InputDecoration(
                      labelText: 'Date of birth',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isDOBEnabled ? Colors.blue : Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                      suffixIcon: Icon(
                        Icons.calendar_month_sharp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    textCapitalization: TextCapitalization.none,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged:(value) {
                      _onFirstNameChanged("email_id",value);
                    },
                    enabled: isEmailEnabled,
                    decoration: InputDecoration(
                      labelText: 'Email Id',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isEmailEnabled ? Colors.blue : Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (value) {
                      _onFirstNameChanged("password",value);
                    },
                    obscureText: !_isPasswordVisible,
                    enabled: isPasswordEnabled,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isPasswordEnabled ? Colors.blue : Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey, width: 1.2),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(12),
                      menuMaxHeight: 300,
                      isExpanded: true,
                      value: _selectedHeight,
                      hint: Text(' Select Height'),
                      underline: Column(),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                      onChanged: isHeightEnabled ? (String? newValue) {
                        setState(() {
                          _selectedHeight = newValue;
                        });
                        if (newValue != null) {
                          int index = heightList.indexOf(newValue);
                          if (index != -1 && index < heightKeys.length) {
                            selectedKey = heightKeys[index];
                            print("Selected key: $selectedKey");
                            _onFirstNameChanged("height",selectedKey);
                          }
                        }
                      } : null,
                      items: heightList.map<DropdownMenuItem<String>>((String list) {
                        return DropdownMenuItem<String>(
                          value: list,
                          child: Text(list),
                        );
                      }).toList(),
                    ),
                  ),
                 /* TextFormField(
                    // enabled: false,
                    // decoration: InputDecoration(
                    //   enabledBorder: OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //     borderSide: BorderSide(color: Colors.blue),
                    //   ),
                    //   disabledBorder:  OutlineInputBorder(
                    //     borderRadius: BorderRadius.circular(10.0),
                    //     borderSide: BorderSide(color: Colors.grey), // border side config
                    //   ),
                    //   filled: true,
                    // ),
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                      setState(() {
                        AppTheme.showAlert("${_firstNameController.text}");
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                      // enabledBorder: OutlineInputBorder(),
                      prefixIconColor: Colors.black,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                      setState(() {
                        // FocusScope.of(context).requestFocus(FocusNode());
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                      prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      // errorText: !_emailValidated
                      //     ? 'Please enter a First Name'
                      //     : null,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                      alignment: Alignment.topLeft, child: Text("Gender")),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: RadioListTile(
                          activeColor: AppColor.radioButton,
                          title: Text("Male"),
                          value: "male",
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              genderKey = 1.toString();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: RadioListTile(
                          activeColor: AppColor.radioButton,
                          title: Text("Female"),
                          value: "female",
                          groupValue: _selectedGender,
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value;
                              genderKey = 2.toString();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _dOBController,
                    textCapitalization: TextCapitalization.none,
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
                          _dOBController.text = newDate;
                        }
                      }
                    },
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Date of birth',
                      border: OutlineInputBorder(),
                      prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      suffixIcon: Icon(
                        Icons.calendar_month_sharp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _emailController,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                      setState(() {
                        // _emailValidated =
                        //     RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        //         .hasMatch(value) ||
                        //         RegExp(r'^[0-9]{10}$').hasMatch(value);
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email Id',
                      // prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                      prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                      // errorText: !_emailValidated
                      //     ? 'Please enter a valid email and Phone Number'
                      //     : null,
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  SizedBox(height: 10,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      border: const OutlineInputBorder(),
                      prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 0),
                    // margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: DropdownButton<String>(
                      borderRadius:
                      BorderRadius.circular(12),
                      menuMaxHeight: 300,
                      isExpanded: true,
                      value: _selectedHeight,
                      hint: Text(' Select Height'),
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
                  ),*/
                  SizedBox(height: 25.0),
                  ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColor.mainText)),
                    onPressed: () {
                      // if (_currentStep == 0) {
                        if(_firstNameController.text.isEmpty){
                          AppTheme.showInvalidAlert("First Name is required.");
                        }
                        else if(_lastNameController.text.isEmpty){
                          AppTheme.showInvalidAlert("Last Name is required.");
                        }
                        else if(genderKey.isNull){
                          AppTheme.showInvalidAlert("Please First Select Gender.");
                        }else if (_dOBController.text.isEmpty) {
                          AppTheme.showInvalidAlert("Please Select Date of Birth.");
                        }
                        else if (_emailController.text.isEmpty) {
                          AppTheme.showInvalidAlert("Email Id is required.");
                        }
                        else if (_passwordController.text.isEmpty) {
                          AppTheme.showInvalidAlert("Password is required.");
                        }
                        // else if(_emailController.text == RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').toString()){
                        //   AppTheme.showInvalidAlert("Please Enter Valid Email Id.");
                        // }
                        else if (selectedKey.isEmpty) {
                          AppTheme.showInvalidAlert("Please Select Height.");
                        }
                        else{
                          _nextStep();
                        }
                        // else if(_emailController.text == RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')){
                        //   AppTheme.showInvalidAlert("Please Enter Valid Email Id.");
                        // }

                                // .hasMatch(value) ||
                                // RegExp(r'^[0-9]{10}$').hasMatch(value));
                      // } else {
                      //   print("DONE~~~");

                      // }
                    },
                    child: Text(_currentStep == 0 ? "Next" : "Submit",style: AppTheme.buttonBold()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

        /*ElevatedButton(
          onPressed: () {
            if (_currentStep == 0) {
              if (_formKey.currentState!.validate()) {
                _nextStep();
              }
            } else {
              _submitForm();
            }
          },
          child: Text(_currentStep == 0 ? "Next" : "Submit"),
        ),*/

       /* if (_isLoading)
          Center(
            child: CircularProgressIndicator(),
          )
        else
          SizedBox.shrink(),*/

  }

  Widget _build2() {
    return Container(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Card(
          elevation: 8,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16,horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "FREE REGISTRATION!",
                        style: AppTheme.nameText1(),
                      ),
                    ),
                    FloatingActionButton(backgroundColor:AppColor.mainText,onPressed: () {
                      _backStep();
                    },child: Icon(Icons.arrow_back)),
                  ],),
                  _gap(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "STEP 1 ----  ",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _currentStep==0?AppColor.black:Colors.grey,
                            fontFamily: FontName.poppinsRegular),
                      ),
                      Text(
                        "  STEP 2 ----  ",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _currentStep==0?AppColor.black:Colors.grey,
                            fontFamily: FontName.poppinsRegular),
                      ),
                      Text(
                        "  STEP 3",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:  _currentStep==0?AppColor.grey:Colors.black,
                            fontFamily: FontName.poppinsRegular),
                      ),
                    ],
                  ),
                  _gap(),
               /*   Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: Text(
                      "Your partner search begins with a",
                      textAlign: TextAlign.center,
                      style: AppTheme.profileTexts(),
                    ),
                  ),*/
                  _gap(),
                  Container(
                    padding: EdgeInsets.only(left: 9),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      value: _selectedReligion,
                      hint: Text(' Select Religion'),
                      underline: Container(),
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.black),
                      onChanged:isReligionEnabled ? (String? newValue) {
                        setState(() {
                          _selectedReligion = newValue;
                        });
                        if (newValue != null) {
                          int index = religionList.indexOf(newValue);
                          if (index != -1 && index < religionKeys.length) {
                            selectedReligionKey = religionKeys[index];
                            _onFirstNameChanged("religion_id",selectedReligionKey);
                          }
                        }
                      }:null,
                      items: religionList
                          .map<DropdownMenuItem<String>>((String list) {
                        return DropdownMenuItem<String>(
                          value: list,
                          child: Text(list),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 18,),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 0),
                    // margin: EdgeInsets.all(4),
                    // decoration: AppTheme.ConDecoration(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: DropdownButton<EducationsData>(
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      value: _selectedEducation,
                      hint: Text(' Select Education'),
                      underline: Container(),
                      icon: const Icon( Icons.keyboard_arrow_down,
                          color: Colors.black),
                      onChanged: isEducationEnabled?   (EducationsData? newValue) {
                        setState(() {
                          _selectedEducation = newValue;
                          _onFirstNameChanged("education_id",_selectedEducation!.id.toString());
                        });
                      }:null,
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
                  SizedBox(height: 18,),
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 0),
                    // margin: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: DropdownButton<OccupationData>(
                      borderRadius:
                      BorderRadius.circular(12),
                      isExpanded: true,
                      value: _selectedOccupation,
                      hint: Text(' Select Profession'),
                      underline: Column(),
                      icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black),
                      onChanged:isProfessionEnabled?
                          (OccupationData? newValue) {
                        setState(() {
                          _selectedOccupation = newValue;
                          _onFirstNameChanged("profession_id",_selectedOccupation!.id.toString());
                        });
                      }:null,
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
                  SizedBox(height: 18,),
                  Container(
                    margin: EdgeInsets.all(0),
                    child: DropdownSearch<CountryData>(
                      popupProps: PopupProps.menu(
                        constraints: BoxConstraints.loose(Size.fromHeight(250)),
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
                      onChanged:isCountryEnabled?(CountryData? selectedCountry) {
                        setState(() {
                          _selectedCountry = selectedCountry;
                          print("_selectedCountry${_selectedCountry!.id}");
                          fetchState(_selectedCountry!.id);
                          _onFirstNameChanged("country_id",_selectedCountry!.id.toString());
                        });
                      }:null,
                      dropdownDecoratorProps:  DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: ' Select Country',
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
                  SizedBox(height: 18,),
                  Container(
                    margin: EdgeInsets.all(0),
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
                      onChanged:isStateEnabled?(StateData? selectedCountry) {
                        setState(() {
                          _selectState = selectedCountry;
                          _onFirstNameChanged("state",_selectState!.stateid.toString());
                          print("_selectState~~${_selectState!.state}");
                        });
                      }:null,
                      dropdownDecoratorProps:  DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: ' Select State',
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
                  SizedBox(height: 18,),
                  TextFormField(
                    controller: cityController,
                    enabled: isCityEnabled,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                      _onFirstNameChanged("city",value);
                    },

                    decoration:  InputDecoration(
                      labelText: 'City',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isCityEnabled ? Colors.blue : Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                  SizedBox(height: 18,),
                  TextFormField(
                    controller: _addressController,
                    enabled: isAddressEnabled,
                    textCapitalization: TextCapitalization.none,
                    onChanged: (value) {
                      _onFirstNameChanged("address1",value);
                    },
                    decoration:  InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: isAddressEnabled ? Colors.blue : Colors.grey),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColor.mainText)),
                    onPressed: () {
                        _submitForm();
                        },
                    child: Text( "Register",style: AppTheme.buttonBold()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



  Widget _gap() => const SizedBox(height: 16);

  void _submitForm() {
    if(_firstNameController.text.isEmpty){
      AppTheme.showInvalidAlert("First Name is required.");
    }
    else if(_lastNameController.text.isEmpty){
      AppTheme.showInvalidAlert("Last Name is required.");
    }
    else if(genderKey.isNull){
      AppTheme.showInvalidAlert("Please First Select Gender.");
    }
    else if (_dOBController.text.isEmpty) {
      AppTheme.showInvalidAlert("Please Select Date of Birth.");
    }
    else if (_emailController.text.isEmpty) {
      AppTheme.showInvalidAlert("Email Id is required.");
    }
    else if (selectedKey.isEmpty) {
      AppTheme.showInvalidAlert("Please Select Height.");
    }




    else if (selectedReligionKey.isEmpty) {
      AppTheme.showInvalidAlert("Please Select Religion.");
    }
    else if (_selectedEducation==null) {
      AppTheme.showInvalidAlert("Please Select Education.");
    }
    else if (_selectedOccupation==null) {
      AppTheme.showInvalidAlert("Please Select Profession.");
    }
    else if(_selectedCountry==null){
      AppTheme.showInvalidAlert("Please Select Country.");
    }
    else if(_selectState==null){
      AppTheme.showInvalidAlert("Please Select State.");
    }
    else if(cityController.text.isEmpty){
      AppTheme.showInvalidAlert("City is required.");
    }
    else if(_addressController.text.isEmpty){
      AppTheme.showInvalidAlert("Address is required.");
    }
    else if (_passwordController.text.isEmpty) {
      AppTheme.showInvalidAlert("Password is required.");
    }
    else {
      print("API");
      postRegistrationCompleteApi(context);
    }
  }
  Future<void> postRegistrationCompleteApi(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${Webservices.baseUrl + Webservices.registrationCompleteApi}');
    print("url~~${url}");
    var jsonData = json.encode({
      'profile_id':"62", //widget.profileId,
      'fcm_token':'${deviceTokenToSendPushNotification.isNull ? "null":deviceTokenToSendPushNotification }'
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
        final userMap = json.decode(response.body);

        final user = RegisterComplete.fromJson(userMap);

        print("response~~~~^^^^${user.message}");
        setState(() {
          AppTheme.showAlert("Welcome to Matrimonial. \nRegister Completed.");
          _isLoading = false;
          prefs.setString('userId', user.profile!.id.toString());

          prefs.setString(
              PrefKeys.KEYNAME, user.profile!.firstName.toString());
          prefs.setString(
              PrefKeys.KEYLNAME, user.profile!.lastName.toString() ?? "test");
          prefs.setString(PrefKeys.KEYEMAIL, user.profile!.emailId.toString());
          prefs.setString(PrefKeys.KEYGENDER, user.profile!.gender.toString());
          prefs.setString(PrefKeys.KEYPROFILEID, user.profile!.id.toString());
          prefs.setString(PrefKeys.ACCESSTOKEN, user.accessToken.toString());

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return BottomMenuScreen(pageId: 1,);
            },
          ), (route) => false);
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //     builder: (BuildContext context) => BottomMenuScreen()));
          // }
        });
      } else {
        setState(() {
          _isLoading = false;
          AppTheme.showInvalidAlert("Invalid credentials");

        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }
}
