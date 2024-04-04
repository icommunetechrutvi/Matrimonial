import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:matrimony/notificationservice/local_notification_service.dart';
import 'package:matrimony/splash_screen/splash_screen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';


Future<void> backgroundHandler(RemoteMessage message) async {
  print("########${message.messageId}");
  print("######${message.notification!.title}");
}
// Future<void> main()  async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Permission.notification.isDenied.then(
//         (bool value) {
//       if (value) {
//         Permission.notification.request();
//       }
//     },
//   );
//   await Firebase.initializeApp();
//   FirebaseMessaging.onBackgroundMessage(backgroundHandler);
//   LocalNotificationService.initialize();
//
//
//
//   SystemChrome.setPreferredOrientations([
//   ]).then((fn) {
//     runApp(
//       MaterialApp(
//         debugShowCheckedModeBanner: false,
//         darkTheme: ThemeData.dark().copyWith(
//           useMaterial3: true,
//           cardTheme: const CardTheme().copyWith(
//             // color: kDarkColorSchema.secondaryContainer,
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           ),
//         ),
//         themeMode: ThemeMode.system,
//         home: SplashScreen(),
//       ),
//     );
//   });
//
// }


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then(
        (bool value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
  await Firebase.initializeApp();
  // LocalNotificationService.initialize();
  // LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
    runApp(MatrimonialApp());

}

class MatrimonialApp extends StatelessWidget {
  const MatrimonialApp({super.key});

  @override
  Widget build(BuildContext context) {
    LocalNotificationService.initialize();
    return OverlaySupport(
      child: Sizer(builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // fallbackLocale: const Locale('en', 'US'),
          title: 'Matrimonial',
          home: SplashScreen(),
        );
      }),
    );
  }
}