import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/login_screen/forgot_screen.dart';
import 'package:matrimony/login_screen/register_screen.dart';
import 'package:matrimony/login_screen/view_model/LoginModel.dart';
import 'package:matrimony/login_screen/view_model/MobileOTPModel.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/pref_keys.dart';
import 'package:matrimony/webservices/Webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _emailValidated = true;
  late var deviceTokenToSendPushNotification="";
  bool otpValidate=false;
  late var otpText="notDone";
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<MobileOTPModelClass> getMobileOTPModel = [];
  late String profileId="";

  @override
  void initState() {
    super.initState();
    getDeviceIdSendNotification();
    // NotificationService.getFCMToken();
    setState(() {
    });
  }

  void _submitForm() {
    final _isValid = _formKey.currentState!.validate();
    if (_isValid) {
      _formKey.currentState!.save();
      postLoginApi();
    }
  }

  Future<dynamic> postLoginApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse( '${Webservices.baseUrl+Webservices.profileLogin}');
    print("url~~${url}");
    var jsonData = json.encode({
      'email_number_profileid': '${_emailController.text.isNull ?"null":_emailController.text}',
      'password': '${_passwordController.text.isNull?"":_passwordController.text}',
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

        final user = LoginModel.fromJson(userMap);

        print("response~~~~^^^^${user.message}");
        setState(() {

          AppTheme.showAlert("${user.message}");
            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //   content: Text("${user.message}"),
            //   backgroundColor: AppColor.lightGreen,
            // ));
            _isLoading = false;
            // prefs.setString('accessToken', user.accessToken.toString());
            prefs.setString('userId', user.profiles!.id.toString());

            prefs.setString(PrefKeys.KEYNAME, user.profiles!.firstName.toString());
            prefs.setString(PrefKeys.KEYLNAME, user.profiles!.lastName.toString() ?? "test");
            prefs.setString(PrefKeys.KEYEMAIL, user.profiles!.emailId.toString());
            // prefs.setString(PrefKeys.KEYAVTAR, user.profiles!.imageName.toString());
            prefs.setString(PrefKeys.KEYGENDER, user.profiles!.gender.toString());
            prefs.setString(PrefKeys.KEYPROFILEID, user.profiles!.id.toString());
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
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("${response}"),
        //   backgroundColor: Colors.redAccent,
        // ));

        });
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }
  Future<dynamic> registrationWithMobileApi() async {
    setState(() {
      _isLoading = true;
    });
    var url = Uri.parse( '${Webservices.baseUrl+Webservices.registrationWithMobileApi}');
    print("url~~${url}");
    var jsonData = json.encode({
      'mobile_no': '${_mobileController.text.isNull ?"null":_mobileController.text}',

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
        final user = MobileOTPModelClass.fromJson(userMap);
        getMobileOTPModel.add(user);
        print(userMap);
        profileId= getMobileOTPModel[0].profile!.id.toString();
        setState(() {
          AppTheme.showAlert("OTP SEND");
          _isLoading = false;
          otpText = "notDone";
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return RegisterScreen(mobileNumber: _mobileController.text,profileId : profileId);
            },
          ));
          _mobileController.clear();
          _otpController.clear();
          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          //   builder: (context) {
          //     return BottomMenuScreen(pageId: 1,);
          //   },
          // ), (route) => false);
        });
      }else if(response.statusCode == 409) {
        setState(() {
          _isLoading = false;
          AppTheme.showInvalidAlert("Mobile number already registered");
          Navigator.pop(context);
          _mobileController.clear();
          _otpController.clear();
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
  void dialogs(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("FREE REGISTRATION!",
                        style: AppTheme.nameText1(), maxLines: 3,),
                      // IconButton(onPressed: () {Navigator.pop(context);  }, icon: Icon(Icons.close,color: AppColor.grey),),
                    ],
                  ),
                  _gap(),
                  _gap(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "STEP 1 ----  ",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:Colors.black,
                            fontFamily: FontName.poppinsRegular),
                      ),
                      Text(
                        "  STEP 2 ----  ",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:Colors.grey,
                            fontFamily: FontName.poppinsRegular),
                      ),
                      Text(
                        "  STEP 3",
                        style:TextStyle( fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:Colors.grey,
                            fontFamily: FontName.poppinsRegular),
                      ),
                    ],
                  ),
                ],
              ),
              // content: ,
              actions: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: _mobileController,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    onChanged: (value) {
                      setState(() {

                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Matrimonial Phone Number',
                      // prefixIcon: Icon(Icons.mobile_friendly),
                      border: OutlineInputBorder(),
                      prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 10.0),
                    ),
                  ),
                ),
                otpText == "Done"?Container():
                ElevatedButton(onPressed: () {
                  if (_mobileController.text.isEmpty) {
                    AppTheme.mobileAlert("Please enter Mobile Number");
                  } else if (_mobileController.text.length != 10) {
                    AppTheme.mobileAlert("Please enter valid Mobile Number");
                  } else {
                    setState(() {
                      otpText = "Done";
                      print("done!!!${otpText}");
                      // Navigator.pop(context); // Close current dialog
                    });
                  }
                },
                    child: Text("Send",style: AppTheme.buttonBold(),),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(side: BorderSide(
                          width: 0, color: AppColor.mainText),
                        borderRadius: BorderRadius.circular(28,),
                      ),
                      backgroundColor: AppColor.mainText),),
                SizedBox(height: 15,),
                otpText == "Done" ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: _otpController,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        onChanged: (value) {
                          setState(() {
                            // if( _otpController.text.isEmpty){
                            //   AppTheme.mobileAlert("Please enter OTP");
                            // }else if(_otpController.text.length!=4){
                            //   AppTheme.mobileAlert("Please enter 4 Digit OTP");
                            // }else {
                            //   Navigator.of(context);
                            //   Navigator.push(context, MaterialPageRoute(
                            //     builder: (context) {
                            //       return RegisterScreen(mobileNumber: _mobileController.text,);
                            //     },
                            //   ));
                            //   // Navigator.pop(context);
                            // }
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'OTP',
                          border: OutlineInputBorder(),
                          prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                if( _otpController.text.isEmpty){
                                  AppTheme.mobileAlert("Please enter OTP");
                                }else if(_otpController.text.length!=4){
                                  AppTheme.mobileAlert("Please enter 4 Digit OTP");
                                }else {
                                  // registrationWithMobileApi();
                                  otpText = "notDone";
                                  Navigator.pop(context);
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return RegisterScreen(mobileNumber: _mobileController.text,profileId : profileId);
                                    },
                                  ));
                                  Navigator.of(context);
                                  // Navigator.pop(context);
                                }
                              });
                            },
                            child: Text(
                              "Next",
                              style: AppTheme.buttonBold(),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(
                                    left: 35, right: 35, top: 14, bottom: 14),
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    width: 0, color: AppColor.mainText),
                                  borderRadius: BorderRadius.circular(28,),
                                ),
                                backgroundColor: AppColor.mainText),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(13),
                          child: ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Close",
                              style: AppTheme.buttonBold(),
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(
                                    left: 35, right: 35, top: 14, bottom: 14),
                                shape: RoundedRectangleBorder(side: BorderSide(
                                    width: 0, color: AppColor.mainText),
                                  borderRadius: BorderRadius.circular(28,),
                                ),
                                backgroundColor: AppColor.mainText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ) : Container(),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          color: AppColor.mainAppColor,
          child: Center(
            child: Card(
              elevation: 8,
              child: Container(
                color:AppColor.white,
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
                          "Welcome!!",
                          style: AppTheme.nameText(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Text(
                          "Enter your details to continue.",
                          textAlign: TextAlign.center,
                          style: AppTheme.profileTexts(),
                        ),
                      ),
                      _gap(),
                      _gap(),
                      TextFormField(
                        controller: _emailController,
                        textCapitalization: TextCapitalization.none,
                        onChanged: (value) {
                          setState(() {
                            _emailValidated =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                        .hasMatch(value) ||
                                    RegExp(r'^[0-9]{10}$').hasMatch(value);
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Matrimonial Id, Phone, Email Id',
                          prefixIcon: Icon(Icons.email_outlined),
                          border: OutlineInputBorder(),
                          prefixIconColor: Color.fromARGB(255, 126, 143, 130),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 10.0),
                          errorText: !_emailValidated
                              ? 'Please enter a valid email and Phone Number'
                              : null,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
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
                      TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ForgotScreen();
                            },
                          ));
                        },
                        child: const Text(
                            textAlign: TextAlign.end, 'Forgot Password'),
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
                              'Login',
                              style: AppTheme.buttonBold(),
                            ),
                          ),
                          onPressed: _submitForm,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          dialogs();
                                                   // Navigator.push(context, MaterialPageRoute(
                          //   builder: (context) {
                          //     return RegisterScreen();
                          //   },
                          // ));
                        },
                        child:  Align(alignment: Alignment.bottomRight,
                          child: Text(
                            'Register Free',style: TextStyle(color: Colors.pink,fontSize: 20),),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     const Text('Don`t have an account?'),
                      //     TextButton(
                      //       child: const Text(
                      //         'Register Now!',
                      //         style: TextStyle(fontSize: 15),
                      //       ),
                      //       onPressed: () {
                      //         //signup screen
                      //       },
                      //     )
                      //   ],
                      // ),

                      // _gap(),
                      // CheckboxListTile(
                      //   value: _rememberMe,
                      //   onChanged: (value) {
                      //     if (value == null) return;
                      //     setState(() {
                      //       _rememberMe = value;
                      //     });
                      //   },
                      //   title: const Text('Remember me'),
                      //   controlAffinity: ListTileControlAffinity.leading,
                      //   dense: true,
                      //   contentPadding: const EdgeInsets.all(0),
                      // ),
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


  /*Future<void> _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(

      'your_channel_id', // Change this to your channel ID
      'Channel Name', // Change this to your channel name
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await widget.flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Matrimonial', // Notification title
      'Welcome to Matrimonial Application', // Notification body
      platformChannelSpecifics,
      payload: 'item x',
    );
  }*/


}
