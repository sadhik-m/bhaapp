import 'package:bhaapp/common/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container searchField(double height,double width){
  return Container(
    width: width,
    height: height*0.06,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(4)),
      border: Border.all(color: border_grey.withOpacity(0.1)),
      color: fill_grey.withOpacity(0.1)
    ),
    child: TextField(
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(top:height*0.008),
        prefixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/home/search.png',
              height: height*0.03,
            ),
          ],
        ),
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/home/Group 59.png',
              height: height*0.03,
            ),
          ],
        ),
        hintText: 'Search Products',
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black.withOpacity(0.5)
        ),
      ),
      style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black
      ),
    ),
  );
}