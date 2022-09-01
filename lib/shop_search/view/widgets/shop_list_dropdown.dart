import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

DropdownButton shopDropDown(Function(dynamic)? onchanged){
 return DropdownButton(
   elevation: 0,
    alignment: Alignment.bottomCenter,
    isExpanded: true,
    iconDisabledColor: Colors.black,
    iconEnabledColor: Colors.black,
    underline: SizedBox.shrink(),
    value: dropdownvalue,
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
  );
}
// Initial Selected Value
String dropdownvalue = 'Groceries and Vegetables';

// List of items in our dropdown menu
var items = [
  'Groceries and Vegetables',
  'Groceries and Vegetables 1',
  'Groceries and Vegetables 2',
  'Groceries and Vegetables 3',
  'Groceries and Vegetables 4',
  'Groceries and Vegetables 5',
];