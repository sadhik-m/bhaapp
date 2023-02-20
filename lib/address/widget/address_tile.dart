import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';
import '../edit_address.dart';
import '../model/addressModel.dart';

Column addressTile(double width,double height,VoidCallback ontap,int index,
    String name,String address,String country,String phone,String pincode,BuildContext context,
    String email,String adrsId){
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              selectedAddressIndex==index?
              Column(
                children: [
                  Container(
                    color: splashBlue.withOpacity(0.2),
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                      child: Text('Default',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 9,
                            color: splashBlue
                        ),),
                    ),
                  ),
                  SizedBox(height: height*0.02,),
                ],
              ):SizedBox.shrink(),
              Text(name,style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.black
              ),),
              SizedBox(height: height*0.005,),
              Container(
                width: width*0.45,
                child: Text('$address,${country.toString().toUpperCase()}\nPh : $phone\nPincode : $pincode',style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.6)
                ),),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>EditAddress(
                    name: name,
                      email: email,
                    mobile: phone,
                    country: country,
                    address: address,
                    pincode: pincode,
                    adresIndex: index,
                    adrsId: adrsId
                  )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red)
                  ),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                    child: Text('Edit',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 9,
                          color: Colors.red
                      ),),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: ontap,
                child: Container(
                  height: height*0.055,
                  width: width*0.25,
                  decoration: BoxDecoration(
                      border: Border.all(color:selectedAddressIndex==index?Colors.transparent: Colors.black),
                    color: selectedAddressIndex==index?splashBlue.withOpacity(0.2):Colors.white
                  ),
                  child: Center(
                    child: Text(selectedAddressIndex==index?'Selected':'Select',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color:selectedAddressIndex==index?splashBlue: Colors.black
                      ),),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      Padding(
        padding:  EdgeInsets.symmetric(vertical: height*0.02),
        child: Divider(color: Colors.black.withOpacity(0.3),),
      ),
    ],
  );
}

int selectedAddressIndex=0;