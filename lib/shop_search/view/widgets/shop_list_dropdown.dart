import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

DropdownButton shopDropDown(Function(dynamic)? onchanged,List<String> data){
 return DropdownButton(
   elevation: 0,
    alignment: Alignment.bottomCenter,
    isExpanded: true,
    iconDisabledColor: Colors.black,
    iconEnabledColor: Colors.black,
    underline: SizedBox.shrink(),
    value: selectedCategory,
    style: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black
    ),

    icon: const Icon(Icons.keyboard_arrow_down),

    items: data.map((String items) {
      return DropdownMenuItem(
        value: items,
        child: Text(items),
      );
    }).toList(),

    onChanged: onchanged,
  );
}
// Initial Selected Value
String ? selectedCategory;
