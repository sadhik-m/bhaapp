import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:bhaapp/register/services/registerService.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../login/view/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String ? name;
  String ? email;
  String   country='in';
  String ? address;
  var mobController=TextEditingController();
  var emailController=TextEditingController();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getCurrentPosition();
    });

  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    if(LoginScreen.isPhone!){
      mobController.text=LoginScreen.mobileNumber.toString();
      country=LoginScreen.countrycode.toString().toLowerCase();
    }else{
      emailController.text=LoginScreen.emailId.toString();
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('', [],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.01
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset('assets/authentication/app_logo_old(1) 1-2.png',
                      height: screenHeight*0.035,),
                  ],
                ),
                Row(
                  children: [
                    Text('Register',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 24
                      ),),
                  ],
                )
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight*0.015,),
                    textField('Full Name*',TextInputType.name,(value){
                     setState(() {
                       name=value;
                     });
                    }),
                    SizedBox(height: screenHeight*0.015,),
                    TextField(
                      keyboardType: TextInputType.number,
                      onChanged:(value){} ,
                      controller:
                      mobController,
                      readOnly: LoginScreen.isPhone!?true:false,
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
                      readOnly: LoginScreen.isPhone!?false:true,
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
                        },country,
                        LoginScreen.isPhone!
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

                  ],
                ),
              ),
            ),
            blackButton('Register', (){
              if(name==null) {
                Fluttertoast.showToast(msg: 'Enter valid name');
              }else if(mobController.text.toString().isEmpty ) {
                Fluttertoast.showToast(msg: 'Enter valid mobile');
              }else if(emailController.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Enter valid email');
              }else if(address==null) {
                Fluttertoast.showToast(msg: 'Enter valid address');
              }else{
                RegisterService().addUser(name!, emailController.text, mobController.text, country,
                    address!,context,current_lat.toString(),current_long.toString());
              }
            }, screenWidth, screenHeight*0.05
            )

          ],
        ),
      ),
    );
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

  Future<void> _getCurrentPosition() async {
    showLoadingIndicator(context);
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
      final position = await _geolocatorPlatform.getCurrentPosition().then((value) {
        setState(() {
          current_lat=value.latitude;
          current_long=value.longitude;
          print('lat $current_lat,long $current_long');
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
}
