import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:bhaapp/otp/view/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
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
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }

    return user;
  }
}