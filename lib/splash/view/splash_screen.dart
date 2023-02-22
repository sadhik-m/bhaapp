import 'dart:async';

import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/services/send_push_notification_service.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/login/view/login_screen.dart';
import 'package:bhaapp/shop_search/view/shop_search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  NotificationService().saveNotifications(message.notification!.title!, message.notification!.body!);
  //print('Handling a background message ${message.data}');
}
final navigatorKey = GlobalKey<NavigatorState>();
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
              'assets/home/bg-white.png',
            ),
            fit: BoxFit.fill
          )
        ),
        child: Center(
          child: Container(
               height:  120,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.white,
             borderRadius: BorderRadius.all(Radius.circular(28)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color(0xff151515).withOpacity(0.1),
                    blurRadius: 20.0,
                    offset: Offset(0, 4)
                )
              ],
            ),
            child: Center(
              child: Image.asset('assets/home/newlogo.png',
              height: 29,width: 94,),
            ),
          ),
        ),
      ),
    );
  }
  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    vendorId = prefs.getString('vendorId')??'null';

    var _duration = const Duration(seconds: 4);
    return Timer(_duration, () {
      if(isLoggedIn){
        if(vendorId=='null'){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
              (context)=>ShopSearchScreen(willPop: true,)), (route) => false);
        }else{
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
              (context)=>DashBoardScreen()), (route) => false);
        }
      }else{
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
            (context)=>LoginScreen()), (route) => false);
      }
    });
  }
  pushNotification() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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
        NotificationService().saveNotifications(message.notification!.title!, message.notification!.body!);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // print('<><><><><> ${notification.title}');
        if (message.notification != null && navigatorKey.currentContext != null) {
          NotificationService().saveNotifications(message.notification!.title!, message.notification!.body!);
          showDialog(
              context: navigatorKey.currentContext!,
              builder: (_) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                backgroundColor: Colors.black,
                title: Text(message.notification!.title!,style: TextStyle(color: Colors.white),),
                content: Text(message.notification!.body!,style: TextStyle(color: Colors.white),),
                actions: [
                  TextButton(
                    child: Text("Okay",style: TextStyle(color: Colors.blue)),
                    onPressed: () {
                      Navigator.of(navigatorKey.currentContext!).pop();
                    },
                  )
                ],
              ));
        }
      }
    });
    FirebaseMessaging.instance.getToken().then((token) {
      update(token!);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      NotificationService().saveNotifications(message.notification!.title!, message.notification!.body!);
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
