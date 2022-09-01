import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

InkWell categoryList(double height,VoidCallback ontap){
  return InkWell(
    onTap: ontap,
    child: Container(
      height: height*0.07,
      child: ListView.builder(
        padding: EdgeInsets.all(0),
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: list_blue.withOpacity(0.2)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Fruits & Vegetables',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 12
                        ),),
                      ],
                    )),
              ),
            ],
          );
        },
      ),
    ),
  );
}