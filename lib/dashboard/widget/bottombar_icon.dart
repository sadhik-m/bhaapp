import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/dashboard/widget/bottombar_dot_selection.dart';
import 'package:flutter/material.dart';

Column BottomIcon(VoidCallback onTap,int index,String image){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      pageIndex == index ?
          BottomDotBlue():BottomDotTransparent(),
      IconButton(
          enableFeedback: false,
          onPressed:onTap,
          icon:  Image.asset(
            'assets/dashboard/$image.png',
            color:pageIndex == index ?  Colors.white:bottom_grey,
            height: 24,
            width: 24,
          )
      )
    ],
  );
}