import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/login/view/widget/phone_textfield.dart';
import 'package:bhaapp/login/view/widget/social_media_button.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/loginService.dart';


class LoginScreen extends StatelessWidget {
  static String ? mobileNumber;
  static String ? emailId;
  static bool ? isPhone;
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.1
        ),
        height: screenHeight,
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/authentication/app_logo_old(1) 1-2.png',
                height: screenHeight*0.035,),
                Text('Login',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 24
                ),)
              ],
            ),
            Column(
              children: [
                phoneTextfield((v){
                  mobileNumber=v.completeNumber.toString();
                }),
                SizedBox(height: screenHeight*0.02,),
                blackButton('Continue', ()async{
                  SharedPreferences prefs=await SharedPreferences.getInstance();
                  prefs.setBool('isPhone',true);
                  if(mobileNumber!=null && mobileNumber!.length>=13){
                    isPhone=true;
                    LoginService().fireBasePhoneAuth(mobileNumber!, context);
                  }else{
                    Fluttertoast.showToast(msg: 'Enter valid mobile number');
                  }
                }, screenWidth, screenHeight*0.05
                )
              ],
            ),
            Column(
              children: [
                socialMediaButton(
                    'Continue with Google',
                    'assets/authentication/281764.png',
                    red,
                    screenHeight*0.05,
                    screenWidth, ()async{
                  SharedPreferences prefs=await SharedPreferences.getInstance();
                  prefs.setBool('isPhone',false);
                  isPhone=false;
                  LoginService().signInWithGoogle(context: context);
                }
                ),
                SizedBox(height: screenHeight*0.02,),
                socialMediaButton(
                    'Continue with facebook',
                    'assets/authentication/Shape Copy 2.png',
                    blue,
                    screenHeight*0.05,
                    screenWidth,(){}
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}
