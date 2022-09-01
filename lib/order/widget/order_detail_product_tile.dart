import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

Column orderDetailProductListTile(double width,double height){
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: height*0.015,),
                Text('Royale Glitz',style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
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
                SizedBox(height: height*0.015,),
                Row(
                  children: [
                    Text('Product Code: ',style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.6)
                    ),),
                  ],
                ),
                SizedBox(height: height*0.004,),
                Text('Asian Paint 12345678 (In Wall Paints)',style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black
                ),),
                SizedBox(height: height*0.02,),
                Row(
                  children: [
                    Text('1 Kg',style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: splashBlue
                    ),),
                    Text(' - \$90',style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black.withOpacity(0.8)
                    ),),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: width*0.05,),
          Image.asset('assets/home/2985 1.png',
            height: height*0.12,),
        ],
      ),
      Padding(
        padding:  EdgeInsets.only(bottom:8.0,top: 8),
        child: Divider(color: Colors.black.withOpacity(0.2),),
      )
    ],
  );
}