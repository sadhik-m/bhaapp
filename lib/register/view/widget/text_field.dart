import 'package:bhaapp/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextField textField(String label,TextInputType type,Function(String) onchange){
  return TextField(
    keyboardType: type,
    onChanged:onchange ,
    decoration: InputDecoration(
      label:Text(label) ,
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
  );
}