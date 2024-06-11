import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:matrimony/login_screen/login_screen.dart';
import 'package:matrimony/notificationservice/local_notification_service.dart';
import 'package:matrimony/ui_screen/bottom_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setState(() {
      redirectToScreen();

      FirebaseMessaging.instance.getInitialMessage().then(
        (title) {
          print("FirebaseMessaging.instance.getInitialMessage");
          if (title != null) {
            print("New Notification");
            if (title.data['profileId'] != null) {
              print("Router Value1234### ${(title.data['profileId'])}");

              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => NotificationScreen(id: (title.data['_id']),
              //       // id: message.data['_id'],
              //     ),
              //   ),
              // );
            }
          }
        },
      );

      FirebaseMessaging.onMessage.listen(
        (message) {
          print("FirebaseMessaging.onMessage.listen");
          if (message.notification != null) {
            print(message.notification!.title);
            print(message.notification!.body);
            print("message.data11### ${message.notification!.title}");
            LocalNotificationService.createanddisplaynotification(message);
          }
        },
      );

      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) {
          print("FirebaseMessaging.onMessageOpenedApp.listen");
          if (message.notification != null) {
            print(message.notification!.title);
            print(message.notification!.body);
            print("!!!!!!${message.messageId}");
            print("message.data22### ${message.data['profileId']}");
          }
        },
      );
    });
  }

  // Future<void>handleMsg(RemoteMessage msg)async{
  //   print("@@@${msg.notification!.title}");
  //   print("@@@${msg.notification!.body}");
  //   print("@@@${msg.data}");
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Image.asset(
        // color: Color.fromARGB(255, 248, 205, 206),
        'assets/images/splash_s.png',
        fit: BoxFit.fill,
        // fit: BoxFit.fitHeight,
      ),
    );
  }

  redirectToScreen() {
    Future.delayed(const Duration(seconds: 3)).then((v) async {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stringValue = prefs.getString('accessToken')?? "null";
      print("stringValue~~~${stringValue}");
      // var pref = await SharedPreferences.getInstance();
      // if (pref != null) {
        if (stringValue=="null") {
           //Todo: User Already Login
      //     // await SharedPreferenceHelper.getUserDataFromPref();
      //     // await SharedPreferenceHelper.getUserTokenPref();
      //
          Navigator.of(context!).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => LoginScreen()));
        }
        else{
          //Todo:User Not Login
          Navigator.of(context!).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => BottomMenuScreen(pageId: 1,)));
        }
      // }
      // builder: (BuildContext context) => BottomScreen()));
    });
  }
}
