import 'dart:async';

import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/login/view/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pushNotification();
    startTime();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
              'assets/authentication/Splash_White.png',
            ),
            fit: BoxFit.fill
          )
        ),
      ),
    );
  }
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    var _duration = const Duration(seconds: 4);
    return Timer(_duration, () {
      isLoggedIn ?
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
          (context)=>DashBoardScreen()), (route) => false) :
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
          (context)=>LoginScreen()), (route) => false);
    });
  }
  pushNotification() async{
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance
        .getInitialMessage()
        .then(( message) {
      if (message != null) {
        print("VVVVVVVVVV ${message.data.toString()}");
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        print('A new XXXXXXXX event was published!');
        print(notification.title);
        print(notification.body.toString());
        print(notification.body.toString());
        print(notification.body.toString());

      }
    });
    FirebaseMessaging.instance.getToken().then((token) {
      update(token!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });

  }

  void update(String token)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('TOKEN : $token');
    String textValue = token;
    prefs.setString('dev_id', token);
    setState(() {});
  }
}
