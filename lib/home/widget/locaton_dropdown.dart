import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

SizedBox locationDropDown(Function(dynamic)? onchanged){
  return SizedBox(
    height: 30,
    child: DropdownButton(
      elevation: 0,
      alignment: Alignment.centerLeft,
      isExpanded: false,
      iconDisabledColor: Colors.black,
      iconEnabledColor: Colors.black,
      underline: SizedBox.shrink(),
      value: location_dropdownvalue,
      style: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Colors.black
      ),

      icon: const Icon(Icons.keyboard_arrow_down),

      items: items.map((String items) {
        return DropdownMenuItem(
          value: items,
          child: Text(items),
        );
      }).toList(),

      onChanged: onchanged,
    ),
  );
}
// Initial Selected Value
String location_dropdownvalue = 'Kochi';

// List of items in our dropdown menu
var items = [
  'Kochi',
  'Calicut',
  'Kollam',
  'Palghat',
  'Thrissur',
  'Kottayam',
];