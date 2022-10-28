import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/otp/view/otp_screen.dart';
import 'package:bhaapp/register/services/registerService.dart';
import 'package:bhaapp/register/view/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/service/loginService.dart';

class OtpService{
 signInWithPhoneNumber(String verificationId,String enteredOtp,BuildContext context) async {
   showLoadingIndicator(context);
    FirebaseAuth firebaseAuth = await FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: enteredOtp,
    );
    try {
      firebaseAuth.signInWithCredential(credential).then((value) {
        print('Authentication successful${value.user!.uid}');
        prefs.setString("uid", value.user!.uid);
        prefs.setString('img','');
        RegisterService().checkIfUserExists(value.user!.uid).then((values) {
          if(values==true){
            RegisterService().checkIfUserActive(value.user!.uid).then((active) {
              Navigator.of(context).pop();
              if(active){
                setAsLoggedIn(true);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()), (route) => false);
                Fluttertoast.showToast(msg: 'Logged in successfully');
              }else{
                LoginService().showAccountStatusDialog(context);
              }
            });

          }else{
            Navigator.of(context).pop();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
            Fluttertoast.showToast(msg: 'Please register');
          }
        });
      });
    } catch(e){
     Navigator.of(context).pop();
     print(e);
     Fluttertoast.showToast(msg: e.toString());
    }

  }
 resendPhoneAuth(String phoneNum,BuildContext context) async{
   showLoadingIndicator(context);
   String ? _verificationId;
   FirebaseAuth _auth = await FirebaseAuth.instance;
   verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {}

   verificationFailed(FirebaseAuthException authException) {
     Navigator.of(context).pop();
     Fluttertoast.showToast(msg: 'Verification failed, try again');
   }

   codeSent( verificationId,  forceResendingToken) async {

     _verificationId = verificationId;
     Navigator.of(context).pop();
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OtpScreen(verificationId: verificationId,)));
     Fluttertoast.showToast(msg: 'Check your phone for otp');
   }


   codeAutoRetrievalTimeout(String verificationId) {
     _verificationId = verificationId;
   }

   try {
     await _auth.verifyPhoneNumber(
         phoneNumber: phoneNum,
         timeout: const Duration(seconds: 30),
         verificationCompleted: verificationCompleted,
         verificationFailed: verificationFailed,
         codeSent: codeSent,
         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
   } catch (e) {
     Navigator.of(context).pop();
     Fluttertoast.showToast(msg: e.toString());
   }
   return _verificationId;
 }
 setAsLoggedIn(bool status) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setBool('isLoggedIn', status);
 }
}