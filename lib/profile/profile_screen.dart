import 'package:bhaapp/login/view/login_screen.dart';
import 'package:bhaapp/order/my_orders_screen.dart';
import 'package:bhaapp/profile/model/profileModel.dart';
import 'package:bhaapp/profile/widget/profile_tile.dart';
import 'package:bhaapp/profile/wishlist_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/constants/colors.dart';
import '../common/widgets/appBar.dart';
import '../dashboard/dash_board_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel ? profileModel;
  bool loaded=false;
  getProfileDetails()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid= preferences.getString('uid');
   await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          profileModel = ProfileModel(address: documentSnapshot['address'],
              country: documentSnapshot['country'], name: documentSnapshot['name'],
              email: documentSnapshot['email'], phone: documentSnapshot['phone']);
        });
      } else {
        print('Document does not exist on the database');
      }
    });
   setState(() {
     loaded=true;
   });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfileDetails();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar("My Profile",
            [Padding(
              padding: const EdgeInsets.only(right:18.0),
              child: Center(
                child: Text('Edit Profile',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      color: splashBlue,
                      fontSize: 12
                  ),),
              ),
            )],false),
        body:loaded? Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.08
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight*0.02,),
                Container(
                  height: 88,
                    width: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black
                  ),
                  child: Center(
                    child: Icon(Icons.person,color: Colors.white,size: 30,),
                  ),
                ),
                SizedBox(height: screenHeight*0.02,),
                Text(profileModel!.name,style:
                  GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xff030303)
                  ),),
                SizedBox(height: screenHeight*0.01,),
                Text(profileModel!.email,style:
                GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xff030303)
                ),),
                SizedBox(height: screenHeight*0.03,),
                profileTile(
                  'My Orders',
                    (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderScreen(show_back: true,)));
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'My Wishlists',
                        (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>WishListScreen()));
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'My Addresses',
                        (){
                      Navigator.pushNamed(context, '/change_address');
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'Payment Methods',
                        (){
                          Navigator.pushNamed(context, '/change_payment');
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'Notifications',
                        (){
                    }
                ),
                SizedBox(height: screenHeight*0.01,),
                profileTile(
                    'Logout',
                        (){
                          showLogoutDialog(context);
                    }
                ),
              ],
            ),
          ),
        ):
            Center(child: Text('Loading..'),)
    );
  }

  showLogoutDialog(BuildContext context) {

    Widget cancelButton = TextButton(
      child:const Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child:const Text("Continue"),
      onPressed:  () {
        Navigator.of(context).pop();
        _signOut(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title:const Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _signOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await FirebaseAuth.instance.signOut();
    preferences.remove('isLoggedIn');
    preferences.remove('vendorId');
    pageIndex = 0;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
        (context)=>LoginScreen()), (route) => false);
  }
}
