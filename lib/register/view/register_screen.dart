import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/services/registerService.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../login/view/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String ? name;
  String  email='';
  String  country= 'India';
  String  address='';
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Register', [],true),
      body: Container(
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
                textField('Full Name',TextInputType.name,(value){
                 setState(() {
                   name=value;
                 });
                }),
                SizedBox(height: screenHeight*0.015,),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged:(value){} ,
                  controller:
                  TextEditingController(text: LoginScreen.mobileNumber.toString(),),
                  readOnly: true,
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
                textField('Email Address (Optional)',TextInputType.emailAddress,(value){
                  setState(() {
                    email=value;
                  });
                }),
                SizedBox(height: screenHeight*0.015,),
                countryPicker(
                        (Country selectedcountry) {
                     setState(() {
                       country=selectedcountry.name;
                     });
                    }
                ),
                Padding(
                  padding:  EdgeInsets.only(top:2.0),
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenHeight*0.015,),
                textField('Address (Optional)',TextInputType.streetAddress,(value){
                  setState(() {
                    address=value;
                  });
                }),

              ],
            ),
            blackButton('Register', (){
              if(name==null) {
                Fluttertoast.showToast(msg: 'Enter valid name');
              }else{
                RegisterService().addUser(name!, email, LoginScreen.mobileNumber!, country, address,context);
              }
            }, screenWidth, screenHeight*0.05
            )
          ],
        ),
      ),
    );
  }
}
