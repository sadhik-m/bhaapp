import 'package:bhaapp/common/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InkWell ShopListTile(String shop_name,String shop_address,double width,double height,VoidCallback ontap){
  return InkWell(
    onTap: ontap,
    child: Container(
      decoration: BoxDecoration(
        color: splashBlue.withOpacity(0.1),
      ),
      padding: EdgeInsets.only(
        left: width*0.04,
        right: width*0.07,
        top: width*0.04,
        bottom: width*0.05
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shop_name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Colors.black.withOpacity(0.8)
                ),),
                SizedBox(height: height*0.007,),
                Text(shop_address,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.6)
                ),)
              ],
            ),
          ),
          Image.asset('assets/authentication/arrow-up-right.png',
          height: height*0.03,)
        ],
      ),
    ),
  );
}