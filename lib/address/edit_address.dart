import 'package:bhaapp/address/services/addNewAddress.dart';
import 'package:bhaapp/address/widget/address_type_tile.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/profile/model/profileModel.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/widgets/loading_indicator.dart';
import '../register/view/widget/country_picker.dart';
import 'change_address_screen.dart';
import 'model/addressModel.dart';

class EditAddress extends StatefulWidget {

  String name;
  String mobile;
  String email;
  String country;
  String address;
  String pincode;
  String adrsId;
  int adresIndex;

   EditAddress({Key? key,
  required this.name,
  required this.mobile,
  required this.email,
  required this.country,
  required this.address,
  required this.pincode,
  required this.adrsId,
  required this.adresIndex
  }) : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {

  var mobController=TextEditingController();
  var emailController=TextEditingController();
  var nameController=TextEditingController();
  var addressController=TextEditingController();
  var pinCodeController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    addInitData();
    super.initState();

  }
  addInitData(){
    setState(() {
      nameController.text=widget.name;
      mobController.text=widget.mobile;
      emailController.text=widget.email;
      addressController.text=widget.address;
      pinCodeController.text=widget.pincode;
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Edit Address', [],true),
      body:
      Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.02
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                keyboardType: TextInputType.name,
                onChanged:(value){} ,
                controller:
                nameController,
                readOnly:false,
                enabled: true,
                decoration: InputDecoration(
                    label:Text('Full Name*') ,
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
              TextField(
                keyboardType: TextInputType.number,
                onChanged:(value){} ,
                controller:
                mobController,
                readOnly:false,
                enabled: true,
                decoration: InputDecoration(
                    label:Text('Mobile Number*') ,
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
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged:(value){} ,
                controller:
                emailController,
                readOnly:false,
                enabled: true,
                decoration: InputDecoration(
                    label:Text('Email Address*') ,
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
              countryPicker(
                      (Country selectedcountry) {
                    setState(() {
                      widget.country=selectedcountry.name;
                    });
                  },widget.country,false
              ),
              Padding(
                padding:  EdgeInsets.only(top:2.0),
                child: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: screenHeight*0.015,),
              TextField(
                keyboardType: TextInputType.streetAddress,
                onChanged:(value){} ,
                controller:
                addressController,
                readOnly:false,
                enabled: true,
                decoration: InputDecoration(
                    label:Text('Address*') ,
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
              TextField(
                keyboardType: TextInputType.number,
                onChanged:(value){} ,
                controller:
                pinCodeController,
                readOnly:false,
                enabled: true,
                decoration: InputDecoration(
                    label:Text('Pin Code*') ,
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
              SizedBox(height: screenHeight*0.1,),
              blackButton('Save Address', (){
                if(nameController.text.isEmpty){
                  Fluttertoast.showToast(msg: 'Enter name');
                }else if(mobController.text.isEmpty){
                  Fluttertoast.showToast(msg: 'Enter mobile');
                }else if(emailController.text.isEmpty){
                  Fluttertoast.showToast(msg: 'Enter Email');
                }else if(addressController.text.isEmpty){
                  Fluttertoast.showToast(msg: 'Enter address');
                }else if(pinCodeController.text.isEmpty){
                  Fluttertoast.showToast(msg: 'Enter pin code');
                }else{
                  print(widget.country);
                  AddNewAddress().EditAddress(AddressModel(name: nameController.text, mobile: mobController.text, email: emailController.text, country: widget.country, address: addressController.text, type: 'home',id: '',pinCode: pinCodeController.text,latitude: '',longitude: ''),widget.adrsId, context).then((value) {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ChangeAddress(
                    )));
                  });
                }
              }, screenWidth, screenHeight*0.05
              ),

            ],
          ),
        ),
      )

    );
  }

}
