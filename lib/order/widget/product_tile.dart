import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

Column productListTile(double width,double height){
  return Column(
    children: [
      Padding(
        padding:  EdgeInsets.symmetric(horizontal: width*0.07),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/home/2985 1.png',
              height: height*0.12,),
            SizedBox(width: width*0.05,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: height*0.015,),
                  Text('Item 1',style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),),
                  SizedBox(height: height*0.004,),
                  Row(
                    children: [
                      Text('Product Code: ',style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.6)
                      ),),
                      Text('IDR468K',style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.8)
                      ),),
                    ],
                  ),
                  SizedBox(height: height*0.004,),
                  Row(
                    children: [
                      Text('1 Kg',style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: splashBlue
                      ),),
                      Text(' - \$90',style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black.withOpacity(0.8)
                      ),),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      Padding(
        padding:  EdgeInsets.only(bottom:4.0),
        child: Divider(color: Colors.black.withOpacity(0.2),),
      )
    ],
  );
}