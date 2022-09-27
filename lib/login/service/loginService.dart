import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:bhaapp/login/view/login_screen.dart';
import 'package:bhaapp/otp/view/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../dashboard/dash_board_screen.dart';
import '../../register/services/registerService.dart';
import '../../register/view/register_screen.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginService{
  fireBasePhoneAuth(String phoneNum,BuildContext context) async{
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpScreen(verificationId: verificationId,)));
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
   Future<User?> signInWithGoogle({required BuildContext context}) async {
    SharedPreferences prefs=await SharedPreferences.getInstance();
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      showLoadingIndicator(context);
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user;
        print('Authentication successful${user!.uid}');
        prefs.setString("uid", user.uid);
        LoginScreen.emailId=user.email.toString();

        RegisterService().checkIfUserExists(user.uid).then((value) {
          Navigator.of(context).pop();
          if(value==true){
            setAsLoggedIn(true);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()), (route) => false);
            Fluttertoast.showToast(msg: 'Logged in successfully');
          }else{
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
            Fluttertoast.showToast(msg: 'Please register');
          }
        });

      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: '$e');
      } catch (e) {
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: '$e');      }
    }

    return user;
  }
  setAsLoggedIn(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', status);
  }
}