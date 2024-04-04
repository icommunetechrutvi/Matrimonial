import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrimony/login_screen/forgot_screen.dart';
import 'package:matrimony/login_screen/view_model/LoginModel.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:matrimony/utils/app_theme.dart';
import 'package:matrimony/utils/appcolor.dart';
import 'package:matrimony/utils/shared_pref/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _SignInPage1State();
}

class _SignInPage1State extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _emailValidated = true;
  late var deviceTokenToSendPushNotification="";


  GlobalKey<FormState> _formKey = GlobalKey<FormState>();


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
    var url = Uri.parse(
        'https://matrimonial.icommunetech.com/public/api/profile_login');

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
          // if (user.status == false) {
          //   _isLoading = false;
          //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //     content: Text("${user.message}"),
          //     backgroundColor: Colors.redAccent,
          //   ));
          // } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${user.message}"),
              backgroundColor: AppColor.lightGreen,
            ));
            _isLoading = false;
            prefs.setString('accessToken', user.accessToken.toString());
            prefs.setString('userId', user.profiles!.id.toString());
            prefs.setString('userName', user.profiles!.firstName.toString());
            prefs.setString('emailId', user.profiles!.emailId.toString());
            prefs.setString('gender', user.profiles!.gender.toString());
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (context) {
                return BottomMenuScreen();
              },
            ), (route) => false);
            // Navigator.of(context).pushReplacement(MaterialPageRoute(
            //     builder: (BuildContext context) => BottomMenuScreen()));
          // }
        });
      } else {
        setState(() {
        _isLoading = false;
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

  Future<void> getDeviceIdSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();
    deviceTokenToSendPushNotification = token.toString();
    print("Token Value!!!!!!!! $deviceTokenToSendPushNotification");
    // FirebaseMessaging.onBackgroundMessage((message) =>handleMsg(message) );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/images/bg_pink.jpg",
                ),
                fit: BoxFit.fill),
          ),
          child: Center(
            child: Card(
              elevation: 8,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/images/bg_white.jpg",
                      ),
                      fit: BoxFit.fill),
                ),
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
                                  Color.fromARGB(255, 126, 143, 130)),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              // 'Sign in',
                              'Login',
                              style: AppTheme.nextBold(),
                            ),
                          ),
                          onPressed: _submitForm,
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
