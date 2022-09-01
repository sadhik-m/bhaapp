import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

IntlPhoneField phoneTextfield(Function(PhoneNumber) callback){
  return IntlPhoneField(
    decoration: InputDecoration(
      //labelText: 'Phone Number',
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      disabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      counterText: '',
      contentPadding: EdgeInsets.only(top: 15)
    ),
    initialCountryCode: 'IN',
    showCountryFlag: false,
    dropdownIconPosition: IconPosition.trailing,
    dropdownIcon: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.black,),
    onChanged: callback,
    style: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black
    ),
    dropdownTextStyle: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black
    ),


  );
}