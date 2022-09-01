import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/otp/view/widget/otp_text_field.dart';
import 'package:bhaapp/otp/view/widget/otp_timer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Login / Register', [],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.04
        ),
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("We sent you a code to verify your\nphone number",
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.8)
            ),
            textAlign: TextAlign.center,),
            SizedBox(height: screenHeight*0.02,),
            Text("Sent to +62 875 875 098",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black.withOpacity(0.3)
            ),
            textAlign: TextAlign.center,),
            SizedBox(height: screenHeight*0.06,),
            otptextfield((value){
              print(value);
            },screenWidth),
            SizedBox(height: screenHeight*0.02,),
            OtpTimer(),
            SizedBox(height: screenHeight*0.08,),
            Text("I didn’t receive a code",
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.3)
              ),
              textAlign: TextAlign.center,),
            SizedBox(height: screenHeight*0.012,),
            Text(
              "Resend",
              style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: splashBlue
              ),
            ),
            SizedBox(height: screenHeight*0.05,),
            blackButton('Login Now', (){
              Navigator.pushNamed(context, '/shop_search');
            }, screenWidth, screenHeight*0.05
            )
          ],
        ),
      ),
    );
  }
}
