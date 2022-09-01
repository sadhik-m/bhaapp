import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InkWell blackButton(String text,VoidCallback onTap,double width,double height){
  return InkWell(
    onTap: onTap,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      child: Center(
        child: Text(text,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          color: Colors.white
        ),),
      ),
    ),
  );
}