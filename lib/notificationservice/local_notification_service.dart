import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:matrimony/profile_screen/profile_details.dart';

BuildContext? context = Get.key.currentContext;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        print("Notification tapped with payload: $payload");

        print("onSelectNotification");
        if (payload!.isNotEmpty) {
          print("Router Value1234 ${payload}");
          print("Router Value1234 ${payload}");

          Navigator.of(context!).push(
            MaterialPageRoute(
              builder: (context) => ProfileDetailScreen(
                   profileId: payload,
              ),
            ),
          );
        }
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    try {
      print("message~~~${message.notification!.title}");
      print("message~~~${message.messageId}");
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      print("id&&&${id}");
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "Matrimonialapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['profileId'],
      );
      print("notificationDetails~~~${notificationDetails.android!.channelName}");
      print("notificationDetails~~~${notificationDetails.android!.channelName}");
    } on Exception catch (e) {
      print("****${e}");
    }
  }

}
