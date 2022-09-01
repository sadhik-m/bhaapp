import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

InkWell addressTypeTile(String title,VoidCallback ontap,double width,double height,int index){
  return InkWell(
    onTap: ontap,
    child: Container(
      height: height*0.04,
      width: width*0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
        color:selectedTypeIndex==index?splashBlue.withOpacity(0.2): list_blue.withOpacity(0.2)
      ),
      child: Center(
        child:Text(title,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          color:selectedTypeIndex==index?splashBlue: Colors.black,
          fontSize: 12
        ),),
      ),
    ),
  );
}
List<String> addressTypeList=[
  'Home',
  'Work',
  'Other'
];
int selectedTypeIndex=0;