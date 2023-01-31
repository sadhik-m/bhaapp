import 'dart:async';

import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/dashboard/widget/bottombar_dot_selection.dart';
import 'package:flutter/material.dart';

import '../../cart/service/cartLengthService.dart';
final stream_controller = StreamController<bool>();
Column BottomIcon(VoidCallback onTap,int index,String image,double height){
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
     /* pageIndex == index ?
      BottomDotBlue():BottomDotTransparent(),*/
      Stack(
        children: [

          IconButton(
              enableFeedback: false,
              onPressed:onTap,
              icon:  Image.asset(
                image=='search'?
                'assets/home/$image.png':
                'assets/dashboard/$image.png',
                color:pageIndex == index ?  Colors.white:bottom_grey,
                height: height*0.035,
                width: height*0.035,
              )
          ),
          if(index==3)
            ValueListenableBuilder(
              valueListenable: DashBoardScreen.cartValueNotifier.cartValueNotifier,
              builder: (context, value, child) {
                return Positioned(
                  top: 5,
                  //bottom: 0,
                  right: 5,
                  child:value.toString()!='0'?
                  Container(
                    height: 14,width: 14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: splashBlue
                    ),
                    child: Center(
                      child: Text(
                        value.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 8
                        ),
                      ),
                    ),
                  ):Container(),
                );
              },
            )

        ],
      )
    ],
  );
}