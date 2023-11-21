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
import 'model/addressModel.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  String  country='';
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
          country=profileModel!.country;
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
  var addressController=TextEditingController();
  var pinCodeController=TextEditingController();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getCurrentPosition();
    });
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
                    label:Text('Email Address (optional)') ,
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
               }/*else if(emailController.text.isEmpty){
                 Fluttertoast.showToast(msg: 'Enter Email');
               }*/else if(addressController.text.isEmpty){
                 Fluttertoast.showToast(msg: 'Enter address');
               }else if(pinCodeController.text.isEmpty){
                 Fluttertoast.showToast(msg: 'Enter pin code');
               }else{
                 print(country);
                 setState(() {
                   addressList.add(AddressModel(name: nameController.text, mobile: mobController.text, email: emailController.text, country: country, address: addressController.text, type: 'home',id: '',pinCode:pinCodeController.text,latitude: current_lat.toString(),longitude: current_long.toString() ));
                 });
                 AddNewAddress().addAddress(AddressModel(name: nameController.text, mobile: mobController.text, email: emailController.text, country: country, address: addressController.text, type: 'home',id: '',pinCode: pinCodeController.text,latitude: current_lat.toString(),longitude: current_long.toString()), context).then((value) {
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
  Future<void> _getCurrentPosition() async {
    showLocationLoadingIndicator(context);
    var hasPermission = await _handlePermission().then((value) {
      print("ERRRRRR  $value");
      if(value==false){
        Navigator.of(context, rootNavigator: true).pop();
        infoDialog(context);
      }
      return value;
    });
    print(hasPermission);
    if (hasPermission==false) {

      return;
    }

    try{
      final position = await _geolocatorPlatform.getCurrentPosition().then((pos)async {
        setState(() {
          current_lat=pos.latitude;
          current_long=pos.longitude;

          print('lat $current_lat,long $current_long');

        });
        List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude,pos.longitude).then((value) {
          setState(() {
            addressController.text="${value[0].street}${value[0].street!.isNotEmpty?',':''} ${value[0].subThoroughfare}${value[0].subThoroughfare!.isNotEmpty?',':''} ${value[0].thoroughfare}${value[0].thoroughfare!.isNotEmpty?',':''} ${value[0].subLocality}${value[0].subLocality!.isNotEmpty?',':''} ${value[0].locality}${value[0].locality!.isNotEmpty?',':''} ${value[0].subAdministrativeArea}${value[0].subAdministrativeArea!.isNotEmpty?',':''} ${value[0].administrativeArea}";
            pinCodeController.text="${value[0].postalCode}";
          });
          return value;
        });

        Navigator.of(context, rootNavigator: true).pop();
      });
    }catch(e){
      Navigator.of(context, rootNavigator: true).pop();
      infoDialog(context);
    }
  }
  double current_lat=0;
  double current_long=0;
  Future<bool> _handlePermission() async {

    late LocationPermission permission;

    await _geolocatorPlatform.checkPermission().then((value) {
      print("PEERRRRRR $value");
      setState(() {
        permission =value;
      });
    });
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {

        return false;
      }

    }

    if (permission == LocationPermission.deniedForever) {

      return false;
    }

    return true;
  }
  infoDialog(BuildContext context) {

    AlertDialog alert = AlertDialog(
      title:Text("The location service on the device is disabled",
        style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18
        ),),
      actions: [
        TextButton(
          child: Text("Cancel",style: TextStyle(color: Colors.blue),),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();

          },
        ),
        TextButton(
          child: Text("Enable",style: TextStyle(color: Colors.red),),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            _getCurrentPosition();

          },
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  void showLocationLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: SizedBox(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                      backgroundColor: Colors.white,
                      title: Text("Fetching Your location info.......",
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                        ),),
                      content: SpinKitWave(color: Colors.black)
                  ),
                ],
              ),
            )
        );
      },
    );
  }
}
