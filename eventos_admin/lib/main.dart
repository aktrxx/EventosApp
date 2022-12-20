// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, must_be_immutable, unnecessary_new, use_key_in_widget_constructors, unused_element
//import 'package:eventos/HomePage.dart';
//import 'package:eventos/HomePage.dart';
import 'package:eventos/google_sign_in.dart';
//import 'package:eventos/loginpage.dart';
import 'package:eventos/tempAdminLogin.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

//import 'package:firebase_database/firebase_database.dart';
//import './loginpage.dart';
//import './AdminHomePage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  //    options: FirebaseOptions(
      //   apiKey: "AIzaSyAyYkIxhSyk0EBxqkCQ6YpZqyt-d7ZO0tA",
      //   projectId: "eventosapp-ecc89",
      //   storageBucket: "eventosapp-ecc89.appspot.com",
      //   databaseURL: "https://eventosapp-ecc89-default-rtdb.firebaseio.com",
      // messagingSenderId: "321793570525",
      // appId: "1:321793570525:web:87510e4cb0ee6a1f6b4d34",
          // )
          );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  FlutterNativeSplash.remove();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // await flutterLocalNotificationsPlugin
  //     .resolvePlatformSpecificImplementation<
  //         AndroidFlutterLocalNotificationsPlugin>()
  //     ?.createNotificationChannel(channel);
  //     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );
  runApp(MyApp());
}

Future initialization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TempLoginWidget(),
      ),
    );
  }
}
