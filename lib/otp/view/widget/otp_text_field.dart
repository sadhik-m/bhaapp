import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox otptextfield(Function(String) onsubmit,double width){
  return SizedBox(
    height:width*0.15 ,
    child: OtpTextField(
      numberOfFields: 4,
      borderColor: Colors.black,
      disabledBorderColor: Colors.black.withOpacity(0.2),
      cursorColor: Colors.black,
      focusedBorderColor: Colors.black,
      borderWidth: 1,
      fieldWidth: width*0.14,
      autoFocus: true,
      showFieldAsBox: true,
      onCodeChanged: (String code) {},
      onSubmit:onsubmit,
      textStyle: GoogleFonts.inter(
        color: Colors.black.withOpacity(0.8),
        fontWeight: FontWeight.w400,
        fontSize: 22
      ),

    ),
  );
}