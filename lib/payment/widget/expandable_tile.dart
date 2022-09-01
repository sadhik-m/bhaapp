import 'package:bhaapp/common/constants/colors.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ExpandablePanel expandableTile(
    double width,
    double height,
    String headerImage,
    String headerTitle,
    double size,
    Widget expandedWidget){
  return ExpandablePanel(
    theme: ExpandableThemeData(iconColor: Colors.black),
    header: Row(
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              color: list_blue.withOpacity(0.2)
          ),
          child: Center(
            child: Image.asset('assets/home/$headerImage.png',
              height: size,
              width: size,),
          ),
        ),
        SizedBox(width:width*0.05,),
        Text(headerTitle,
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontSize: 14
          ),),
      ],
    ),
    collapsed: SizedBox.shrink(),
    expanded: expandedWidget,
  );
}