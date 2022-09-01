import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ListTile profileTile(String title,VoidCallback ontap){
  return ListTile(
    onTap: ontap,
    contentPadding: EdgeInsets.all(0),
    title: Text(title,
      style: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontSize: 14
      ),),
    trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,
      size: 15,),
    shape: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black.withOpacity(0.1))
    ),
  );
}