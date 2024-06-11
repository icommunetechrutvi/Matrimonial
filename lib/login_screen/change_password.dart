import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:matrimony/login_screen/forgot_screen.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/login_screen/view_model/ChangePasswordModel.dart';
import 'package:matrimony/search_screen/search_screen.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordScreen> {
  late bool _passwordVisible = false;
  late bool _newPasswordVisible = false;
  late bool _conPasswordVisible = false;
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {});
  }


  Future<dynamic> changePasswordApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString(PrefKeys.ACCESSTOKEN) ?? "null";
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse('${Webservices.baseUrl + Webservices.changePassword}');
    print("url~~${url}");
    var jsonData = json.encode({
      'old_password': '${_oldPasswordController.text.isNull  ? "" : _oldPasswordController.text}',
      'new_password': '${_newPasswordController.text.isNull ? "": _newPasswordController.text}',
      'confirm_password': '${_confirmPasswordController.text.isNull   ? ""  : _confirmPasswordController.text.toString() }'
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
      final userMap = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        // final userMap = json.decode(response.body);

        final user = ChangePasswordModel.fromJson(userMap);
               print("response~~~~^^^^${user.message}");
        setState(() {
          AppTheme.showAlert("${user.message}");
          _isLoading = false;


          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
            builder: (context) {
              return SearchScreen(selectedAge: "",selectedAgeS: "",selectedGender:"",selectedMaritalStatus: "",);
            },
          ), (route) => false);
        });
      } else if(response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text("Token is Expire!! Please Login Again"),
          backgroundColor: AppColor.red,
        ));
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LoginScreen();
          },
        ));
        _isLoading = false;
      }
      else if(response.statusCode == 400) {
        final userMap = json.decode(response.body);
        final user = ChangePasswordModel.fromJson(userMap);
        setState(() {
        _isLoading = false;
        });
        if (user.error != null) {

          if (user.error![0].oldPassword != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // content: Text("The old password field is required."),
              content: Text("${user.error![0].oldPassword}"),
              backgroundColor: AppColor.red,
            ));
          }

          if (user.error![0].newPassword != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("The new password field is required."),
              backgroundColor: AppColor.red,
            ));
          }


          if (user.error![1].confirmPassword != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("The confirm password field is required."),
              backgroundColor: AppColor.red,
            ));
          }
        }
      }
      else {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height / 16,
        backgroundColor: AppColor.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        elevation: 5,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: Text(
          "Change Password",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900,fontFamily: FontName.poppinsRegular),
        ),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          color: AppColor.mainAppColor,
         /* decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg_pink.jpg",
                ),
                fit: BoxFit.fill),
          ),*/
          child: Center(
            child: Card(
              elevation: 8,
              child: Container(
                color: AppColor.white,
               /* decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bg_white.jpg",
                      ),
                      fit: BoxFit.fill),
                ),*/
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 350),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // const FlutterLogo(size: 100),
                      _gap(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "Change Password",
                          style: AppTheme.nameText(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Text(
                          "You might need to Current password !",
                          textAlign: TextAlign.center,
                          style: AppTheme.profileTexts(),
                        ),
                      ),
                      _gap(),
                      _gap(),
                      TextField(
                        controller:_oldPasswordController ,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          labelText: 'Current Password',
                          hintText: 'Enter Current password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: const OutlineInputBorder(),
                          prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                          suffixIcon: IconButton(
                            icon: Icon(_passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _newPasswordController,
                        obscureText: !_newPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'New Password',
                          hintText: 'Enter New password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: const OutlineInputBorder(),
                          prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                          suffixIcon: IconButton(
                            icon: Icon(_newPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _newPasswordVisible = !_newPasswordVisible;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: !_conPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Enter confirm password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: const OutlineInputBorder(),
                          prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                          suffixIcon: IconButton(
                            icon: Icon(_conPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _conPasswordVisible = !_conPasswordVisible;
                              });
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                        ),
                      ),
                      _isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: AppColor.mainAppColor,
                                // backgroundColor: AppColor.pink,
                              ),
                            )
                          : Center(),
                      _gap(),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              backgroundColor:
                                 AppColor.mainText),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              // 'Sign in',
                              'Save Change',
                              style: AppTheme.buttonBold(),
                            ),
                          ),
                          onPressed: () {
                            changePasswordApi();
                          }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
