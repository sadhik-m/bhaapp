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
  String ? email;
  String  country= 'India';
  String ? address;
  var mobController=TextEditingController();
  var emailController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    if(LoginScreen.isPhone!){
      mobController.text=LoginScreen.mobileNumber.toString();
    }else{
      emailController.text=LoginScreen.emailId.toString();
    }


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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
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
                      mobController,
                      readOnly: LoginScreen.isPhone!?true:false,
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
                      readOnly: LoginScreen.isPhone!?false:true,
                      enabled: true,
                      decoration: InputDecoration(
                          label:Text('Email Address') ,
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
                    textField('Address',TextInputType.streetAddress,(value){
                      setState(() {
                        address=value;
                      });
                    }),

                  ],
                ),
              ),
            ),
            blackButton('Register', (){
              if(name==null) {
                Fluttertoast.showToast(msg: 'Enter valid name');
              }else if(mobController.text.toString().isEmpty ) {
                Fluttertoast.showToast(msg: 'Enter valid mobile');
              }else if(emailController.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Enter valid email');
              }else if(address==null) {
                Fluttertoast.showToast(msg: 'Enter valid name');
              }else{
                RegisterService().addUser(name!, emailController.text, mobController.text, country, address!,context);
              }
            }, screenWidth, screenHeight*0.05
            )

          ],
        ),
      ),
    );
  }
}
