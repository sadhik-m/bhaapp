import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar appBar(String title, List<Widget> actions,bool show_back){
  return AppBar(
    automaticallyImplyLeading: show_back,
    centerTitle: true,
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    backgroundColor: Colors.white,
    elevation: 0,
    title: Text(
      title,
      style: GoogleFonts.inter(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: Colors.black
      ),
    ),
    actions: actions,
  );
}