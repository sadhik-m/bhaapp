import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/services/registerService.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/view/login_screen.dart';
import '../common/widgets/loading_indicator.dart';

class EditProfileScreen extends StatefulWidget {
  String name,email,phone;
   EditProfileScreen({Key? key,required this.name,required this.phone,required this.email}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var mobController=TextEditingController();
  var emailController=TextEditingController();
  var nameController=TextEditingController();
  bool ? isphone;
  bool loaded = false;
  getLoginMethod()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isphone = preferences.getBool('isPhone')??false;
      nameController.text=widget.name;
      emailController.text=widget.email;
      mobController.text=widget.phone;
      loaded = true;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginMethod();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Edit Profile', [],true),
      body:loaded?
      Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.04
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextField(
                  keyboardType: TextInputType.name,
                  onChanged:(value){} ,
                  controller:
                  nameController,
                  readOnly: false,
                  enabled: true,
                  decoration: InputDecoration(
                      label:Text('Name') ,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        //color: label_blue
                      )
                  ),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: screenHeight*0.015,),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged:(value){} ,
                  controller:
                  mobController,
                  readOnly:isphone! ?true: false,
                  enabled: true,
                  decoration: InputDecoration(
                      label:Text('Mobile Number') ,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        //color: label_blue
                      )
                  ),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),
                SizedBox(height: screenHeight*0.015,),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  onChanged:(value){} ,
                  controller:
                  emailController,
                  readOnly:isphone! ?false: true,
                  enabled: true,
                  decoration: InputDecoration(
                      label:Text('Email ID') ,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        //color: label_blue
                      )
                  ),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),

              ],
            ),
            blackButton('Save Changes', (){
              if(nameController.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Enter valid name');
              }else if(mobController.text.toString().isEmpty ) {
                Fluttertoast.showToast(msg: 'Enter valid mobile');
              }else if(emailController.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Enter valid email');
              }else{
                updateProfile();
              }
            }, screenWidth, screenHeight*0.05
            )
          ],
        ),
      ):
      Center(
        child: Text('Loading..'),
      ),
    );
  }
  updateProfile()async{
    showLoadingIndicator(context);
    CollectionReference users = await FirebaseFirestore.instance.collection('customers');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid=preferences.getString('uid')??'';
    return users
        .doc(uid)
        .update({
      'name': nameController.text,
      'email': emailController.text,
      'phone': mobController.text,
    },
    ).then((value) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'profile updated successfully');
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        Navigator.of(context).pop();
      });
    });
  }
}
