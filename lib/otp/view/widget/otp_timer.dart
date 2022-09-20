import 'dart:async';

import 'package:bhaapp/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpTimer extends StatefulWidget {
  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  late Timer _timer;
  int _start = 60;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec =  Duration(seconds: 1);
    _timer =  Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return _start == 0?
    Text("Time Out, click resend",
      style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: red
      ),):
    Text(
      '0:'+_start.toString().padLeft(2,'0')+' Sec',
      style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: splashBlue
      ),
    );
  }
}