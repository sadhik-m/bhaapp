import 'package:bhaapp/common/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container BottomDotBlue(){
  return Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: splashBlue
    ),
  );
}
Container BottomDotTransparent(){
  return Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent
    ),
  );
}