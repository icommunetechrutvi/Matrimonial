import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:matrimony/utils/shared_pref/helper.dart';

class NotificationService {
  static FirebaseMessaging ms = FirebaseMessaging.instance;

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings(
        'assets/images/icn_logo_without_shadow.png');
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

//FOR IOS
//     NotificationSettings settings = await ms.requestPermission(
//       alert: true,
//       badge: true,
//       provisional: false,
//       sound: true,
//     );
//
//     if (Platform.isIOS &&
//         settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print("Authorized");
//       FirebaseMessaging.onMessage.listen((event) {
//         NotificationService.showNotification(event);
//       });
//       FirebaseMessaging.onBackgroundMessage(
//           NotificationService.handleBackGroundMessage);
//     } else {
//       print("Authorized noRE");
//     }

    if (Platform.isAndroid) {
      FirebaseMessaging.onMessage.listen((event) {
        NotificationService.showNotification(event);
      });
      FirebaseMessaging.onBackgroundMessage(
          NotificationService.handleBackGroundMessage);
    }
  }

  static Future<void> handleBackGroundMessage(RemoteMessage? event) async {
    if (event != null) {
      showNotification(event);
    }
  }

  static Future<void> showNotification(RemoteMessage event) async {
    print("notification ${jsonEncode(event.toMap())}");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'Matrimonialapp',
      'pushnotificationappchannel',
      channelDescription: 'fraudster description',
      // icon: 'splash', //launcher_icon App_icon  notification_gray
      channelShowBadge: true,

      priority: Priority.high,
    );
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(1000, event.notification!.title,
        event.notification!.body, platformChannelSpecifics,
        payload: '_id');
  }

  ////////
  Future<void> setupInteractedMessage() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // redirect to any route as per requirement
      print(
          "Handling a background message Using Locator: ${message.messageId}");

      print("---=-------->> ${message.notification?.title}");
      print("---=-------->> ${message.data}");
      print("---=-------->> ${message.notification?.body}");

      if (message.data["groupId"] != null) {
        // Get.toNamed(Routes.chatDetails, arguments: {
        //   "chat_group_id": message.data["groupId"] ?? '',
        //   "name": 'Load #${message.data["groupId"] ?? ''}',
        // });
      }
    });

    getFCMToken();
    enableIOSNotifications();
    await registerNotificationListeners();

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  static getFCMToken() {
    final sharedPref = Get.find<SharedPreferenceHelper>();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Ref token--=-=-=-=-=->> $newToken");
      if (sharedPref.fcmToken != newToken) {
        sharedPref.saveFCMToken(newToken ?? '');
        final authToken = sharedPref.authToken;
        if (sharedPref.isLoggedIn == true &&
            authToken != null &&
            authToken.isNotEmpty) {}
      }
    });

    FirebaseMessaging.instance.getToken().then((value) {
      print("token--=-=-=-=-=->> $value");
      if (sharedPref.fcmToken != value) {
        sharedPref.saveFCMToken(value ?? '');
        final authToken = sharedPref.authToken;
        if (sharedPref.isLoggedIn == true &&
            authToken != null &&
            authToken.isNotEmpty) {}
      }
    });
  }

  Future<void> registerNotificationListeners() async {
    final AndroidNotificationChannel channel = androidNotificationChannel();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@drawable/toaapplogo');
    const IOSInitializationSettings iOSSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings, iOS: iOSSettings);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: (details) {},
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
      print('Got a message whilst in the foreground!');
      print("Got the message");

      // final jsonPayload = json.decode(message?.notification?.body ?? "");
      // var messages = jsonPayload["message"];
      //  print("---=-------->> ${jsonPayload}");

      final RemoteNotification? notification = message!.notification;
      final AndroidNotification? android = message.notification?.android;
      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.

      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          message.notification?.title ?? "Aevirt : New Notification",
          message.notification?.body ?? "Aevirt : New Notification des",
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: android.smallIcon,
            ),
          ),
        );
      }
    });
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
    print(message.notification?.title);
    print(message.notification?.body);
    return Future.value(null);
  }

  Future<void> enableIOSNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  AndroidNotificationChannel androidNotificationChannel() =>
      const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        description:
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );
}
