import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                textField('Full Name',TextInputType.name,(value){}),
                SizedBox(height: screenHeight*0.015,),
                textField('Mobile Number',TextInputType.number,(value){}),
                SizedBox(height: screenHeight*0.015,),
                textField('Email Address (Optional)',TextInputType.emailAddress,(value){}),
                SizedBox(height: screenHeight*0.015,),
                countryPicker(),
                Padding(
                  padding:  EdgeInsets.only(top:2.0),
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenHeight*0.015,),
                textField('Address (Optional)',TextInputType.streetAddress,(value){}),

              ],
            ),
            blackButton('Register', (){
              Navigator.pushNamed(context, '/otp');
            }, screenWidth, screenHeight*0.05
            )
          ],
        ),
      ),
    );
  }
}
