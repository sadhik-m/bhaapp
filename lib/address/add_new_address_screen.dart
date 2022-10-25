import 'package:bhaapp/address/services/addNewAddress.dart';
import 'package:bhaapp/address/widget/address_type_tile.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/profile/model/profileModel.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../register/view/widget/country_picker.dart';
import 'model/addressModel.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  String  address='';
  String  country='';
  String  pincode='';
  List<AddressModel> addressList=[];
bool isphone=true;
bool loaded=false;
  ProfileModel ? profileModel;
  getLoginMethod()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isphone = preferences.getBool('isPhone')??false;
    });
    getProfileDetails();
  }
  getProfileDetails()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid= preferences.getString('uid');
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          profileModel = ProfileModel(
              country: documentSnapshot['country'], name: documentSnapshot['name'],
              email: documentSnapshot['email'], phone: documentSnapshot['phone'],
              image: documentSnapshot['image']);
          nameController.text=profileModel!.name;
          emailController.text=profileModel!.email;
          mobController.text=profileModel!.phone;
        });
      } else {
        print('Document does not exist on the database');
      }
    });
    setState(() {
      loaded=true;
    });
  }

  var mobController=TextEditingController();
  var emailController=TextEditingController();
  var nameController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginMethod();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Add New Address', [],true),
      body:loaded?
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
                      country=selectedcountry.name;
                    });
                  },profileModel!.country,false
              ),
              Padding(
                padding:  EdgeInsets.only(top:2.0),
                child: Container(
                  height: 1,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: screenHeight*0.015,),
              textField('Address*',TextInputType.streetAddress,(value){
                setState(() {
                  address=value;
                });
              }),
              SizedBox(height: screenHeight*0.015,),
              textField('Pin Code*',TextInputType.number,(value){
                setState(() {
                  pincode=value;
                });
              }),
              SizedBox(height: screenHeight*0.1,),
              blackButton('Save Address', (){
               if(nameController.text.isEmpty){
                 Fluttertoast.showToast(msg: 'Enter name');
               }else if(mobController.text.isEmpty){
                 Fluttertoast.showToast(msg: 'Enter mobile');
               }else if(emailController.text.isEmpty){
                 Fluttertoast.showToast(msg: 'Enter Email');
               }else if(address.isEmpty){
                 Fluttertoast.showToast(msg: 'Enter address');
               }else if(pincode.isEmpty){
                 Fluttertoast.showToast(msg: 'Enter pin code');
               }else{
                 setState(() {
                   addressList.add(AddressModel(name: nameController.text, mobile: mobController.text, email: emailController.text, country: country, address: address, type: 'home',id: '',pinCode:pincode ));
                 });
                 AddNewAddress().addAddress(AddressModel(name: nameController.text, mobile: mobController.text, email: emailController.text, country: country, address: address, type: 'home',id: '',pinCode: pincode), context).then((value) {
                   Navigator.of(context).pop();
                 });
               }
              }, screenWidth, screenHeight*0.05
              ),

            ],
          ),
        ),
      ):
      Center(child: CircularProgressIndicator()),
    );
  }
}
