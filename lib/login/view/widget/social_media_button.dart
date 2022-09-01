import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InkWell socialMediaButton(String title,String image,Color color,double height,double width,VoidCallback onTap){
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
        width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: color
        ),
        borderRadius: BorderRadius.all(Radius.circular(4))
      ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image,
            height: height*0.6,),
            SizedBox(width: width*0.05,),
            Text(title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: color
            ),)
          ],
        ),
    ),
  );
}