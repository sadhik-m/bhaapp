import 'dart:io';

import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/services/registerService.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_pickers/country.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../login/view/login_screen.dart';
import '../common/widgets/loading_indicator.dart';

class EditProfileScreen extends StatefulWidget {
  String name,email,phone,image;
   EditProfileScreen({Key? key,required this.name,required this.phone,required this.email,required this.image}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var mobController=TextEditingController();
  var emailController=TextEditingController();
  var nameController=TextEditingController();
  bool ? isphone;
  bool loaded = false;
  getLoginMethod()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isphone = preferences.getBool('isPhone')??false;
      nameController.text=widget.name;
      emailController.text=widget.email;
      mobController.text=widget.phone;
      loaded = true;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoginMethod();
  }

  File ? _image; // Used only if you need a single picture

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: Color(0xff2E3138),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library,color: Colors.yellow,),
                      title: new Text('Photo Library',style: TextStyle(color: Colors.white),),
                      onTap: () {
                        Navigator.of(context).pop();
                        getImage(true);

                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera,color: Colors.yellow,),
                    title: new Text('Camera',style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.of(context).pop();
                      getImage(false);
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
  Future getImage(bool gallery) async {
    showLoadingIndicator(context);

    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    // Let user select photo from gallery
    if(gallery) {
      pickedFile = await picker.getImage(
          source: ImageSource.gallery,
          imageQuality: 50);
    }
    // Otherwise open camera to get new photo
    else{
      pickedFile = await picker.getImage(
          source: ImageSource.camera,
          imageQuality: 50);

    }

    setState(() {
      if (pickedFile != null) {
        //_images.add(File(pickedFile.path));
       setState(() {
         _image = File(pickedFile!.path);
         uploadFile(_image!);
       });
        // Use if you only need a single picture
      } else {

        print('No image selected.');
        Navigator.of(context).pop();
      }
    });
  }


  String  ? returnURL;
  uploadFile(File _image) async {
    /*  StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('sightings/${Path.basename(_image.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;*/
    await FirebaseStorage.instance
        .ref()
        .child('userImage/${_image.path}').putFile(_image);
    print('File Uploaded');

    await FirebaseStorage.instance
        .ref()
        .child('userImage/${_image.path}').getDownloadURL().then((fileURL) {
      setState(() {
        returnURL =  fileURL;
        Navigator.of(context).pop();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Edit Profile', [],true),
      body:loaded?
      Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.04
        ),
        child: SingleChildScrollView(
          child: Column(

            children: [
              _image!=null?
              InkWell(
                onTap: (){
                  _showPicker(context);
                },
                child: Stack(
                  children: [
                    Container(
                      height: 88,
                      width: 88,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          image: DecorationImage(image: FileImage(_image!),fit: BoxFit.cover)
                      ),
                      //child: Image.file(_image,fit: BoxFit.cover,)
                    ),
                    Positioned(
                        right: 0,top: 0,bottom: 0,left: 0,
                        child: Icon(Icons.camera_alt_outlined,color: Colors.white,))
                  ],
                ),
              ):
              widget.image!=''?
              InkWell(
                onTap: (){
                  _showPicker(context);
                },
                child: Stack(
                  children: [
                    Container(
                      height: 88,
                      width: 88,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          image: DecorationImage(
                              image: NetworkImage(widget.image),fit: BoxFit.fill)
                      ),
                    ),
                    Positioned(
                        right: 0,top: 0,bottom: 0,left: 0,
                        child: Icon(Icons.camera_alt_outlined,color: Colors.white,))
                  ],
                ),
              ):
              InkWell(
                onTap: (){
                  _showPicker(context);
                },
                child: Stack(
                  children: [
                    Container(
                      height: 88,
                      width: 88,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black
                      ),

                    ),
                    Positioned(
                      right: 0,top: 0,bottom: 0,left: 0,
                        child: Icon(Icons.camera_alt_outlined,color: Colors.white,))
                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.015,),
              TextField(
                keyboardType: TextInputType.name,
                onChanged:(value){} ,
                controller:
                nameController,
                readOnly: false,
                enabled: true,
                decoration: InputDecoration(
                    label:Text('Name') ,
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
                readOnly:isphone! ?true: false,
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
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged:(value){} ,
                controller:
                emailController,
                readOnly:isphone! ?false: true,
                enabled: true,
                decoration: InputDecoration(
                    label:Text('Email ID') ,
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
              SizedBox(height: screenHeight*0.15,),
              blackButton('Save Changes', (){
                if(nameController.text.isEmpty) {
                  Fluttertoast.showToast(msg: 'Enter valid name');
                }else if(mobController.text.toString().isEmpty ) {
                  Fluttertoast.showToast(msg: 'Enter valid mobile');
                }else if(emailController.text.isEmpty) {
                  Fluttertoast.showToast(msg: 'Enter valid email');
                }else{
                  updateProfile();
                }
              }, screenWidth, screenHeight*0.05
              )
            ],
          ),
        ),
      ):
      Center(
        child: Text('Loading..'),
      ),
    );
  }
  updateProfile()async{
    showLoadingIndicator(context);
    CollectionReference users = await FirebaseFirestore.instance.collection('customers');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid=preferences.getString('uid')??'';
    if(returnURL==null){
      setState(() {
        returnURL=widget.image;
      });
    }
    return users
        .doc(uid)
        .update({
      'name': nameController.text,
      'email': emailController.text,
      'phone': mobController.text,
      'image':returnURL
    },
    ).then((value) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'profile updated successfully');
      Future.delayed(Duration(milliseconds: 100)).then((value) {
        Navigator.of(context).pop();
      });
    });
  }
}
