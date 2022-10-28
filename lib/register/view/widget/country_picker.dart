import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

IgnorePointer countryPicker(void Function(Country) onchange,String country,bool isIgnore){
  return IgnorePointer(
    ignoring: isIgnore,
    child: CountryPickerDropdown(
          initialValue: country,
          itemBuilder: _buildDropdownItem,
          onValuePicked: onchange,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,color: Colors.black,),

        ),
  );


}
Widget _buildDropdownItem(Country country) => Container(
  child: Row(
    children: <Widget>[
      CountryPickerUtils.getDefaultFlagImage(country),
      SizedBox(
        width: 8.0,
      ),
      Text("${country.name}",
      style: GoogleFonts.inter(
        color: Colors.black
      ),),
    ],
  ),
);