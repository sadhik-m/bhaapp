import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

Padding benefitListTile(){
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 6,
          height: 6,
          decoration: BoxDecoration(
              color: splashBlue,
              shape: BoxShape.circle
          ),),
        SizedBox(width: 8,),
        Expanded(child: Text('Kills 99%# of infection causing\nbacteria',
          style: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Colors.black,
              height: 0.9
          ),)),
      ],
    ),
  );
}