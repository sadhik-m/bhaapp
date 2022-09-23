import 'package:bhaapp/address/services/addNewAddress.dart';
import 'package:bhaapp/address/widget/address_type_tile.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../register/view/widget/country_picker.dart';
import 'model/addressModel.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  String  name='';
  String  email='';
  String  mobile='';
  String  country= 'India';
  String  address='';
  List<AddressModel> addressList=[];
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Add New Address', [],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.02
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                textField('Full Name',TextInputType.name,(value){
                  setState(() {
                    name=value;
                  });
                }),
                SizedBox(height: screenHeight*0.015,),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged:(value){
                    setState(() {
                      mobile=value;
                    });
                  } ,
                  enabled: true,
                  decoration: InputDecoration(
                      label:Text('Mobile Number') ,
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                      labelStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        //color: label_blue
                      )
                  ),
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                  ),
                ),

                SizedBox(height: screenHeight*0.015,),
                textField('Email Address (Optional)',TextInputType.emailAddress,(value){
                  setState(() {
                    email=value;
                  });
                }),
                SizedBox(height: screenHeight*0.015,),
                countryPicker(
                        (Country selectedcountry) {
                      setState(() {
                        country=selectedcountry.name;
                      });
                    }
                ),
                Padding(
                  padding:  EdgeInsets.only(top:2.0),
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenHeight*0.015,),
                textField('Address (Optional)',TextInputType.streetAddress,(value){
                  setState(() {
                    address=value;
                  });
                }),

              ],
            ),
            blackButton('Save Address', (){
              setState(() {
                addressList.add(AddressModel(name: name, mobile: mobile, email: email, country: country, address: address, type: 'home'));
              });
              AddNewAddress().addAddress(AddressModel(name: name, mobile: mobile, email: email, country: country, address: address, type: 'home'), context);
            }, screenWidth, screenHeight*0.05
            )
          ],
        ),
      ),
    );
  }
}
