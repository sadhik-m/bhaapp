import 'dart:async';

import 'package:bhaapp/common/constants/colors.dart';
import 'package:flutter/material.dart';

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
          color: splashBlue,
          image: DecorationImage(
            image: AssetImage(
              'assets/authentication/Splash_blue.png',
            ),
            fit: BoxFit.fill
          )
        ),
      ),
    );
  }
  startTime() async {
    var _duration = const Duration(seconds: 4);
    return  Timer(_duration, () {
      navigationPage('/login');
    });

  }
  void navigationPage(String destination) {
    Navigator.of(context).pushReplacementNamed(destination);
  }
}
