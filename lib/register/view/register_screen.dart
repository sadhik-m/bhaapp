import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:bhaapp/register/services/registerService.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:country_pickers/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geocoding/geocoding.dart';
import '../../login/view/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String ? name;
  String ? email;
  String   country='india';
  var mobController=TextEditingController();
  var emailController=TextEditingController();
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
                    Image.asset('assets/dashboard/BhaApp_logo_NoBG_1.png',
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

                  ],
                ),
              ),
            ),
            blackButton('Register', (){
              if(name==null) {
                Fluttertoast.showToast(msg: 'Enter valid name');
              }else if(mobController.text.toString().isEmpty ) {
                Fluttertoast.showToast(msg: 'Enter valid mobile');
              }/*else if(emailController.text.isEmpty) {
                Fluttertoast.showToast(msg: 'Enter valid email');
              }*/else if(addressController.text.toString().isEmpty) {
                Fluttertoast.showToast(msg: 'Enter valid address');
              }else if(pinCodeController.text.toString().isEmpty) {
                Fluttertoast.showToast(msg: 'Enter valid pin code');
              }else{
                RegisterService().addUser(name!, emailController.text, mobController.text, country,
                    addressController.text,context,current_lat.toString(),current_long.toString(),pinCodeController.text);
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
}
