import 'package:bhaapp/address/model/addressModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/loading_indicator.dart';
import '../../dashboard/dash_board_screen.dart';

class RegisterService{
  CollectionReference users = FirebaseFirestore.instance.collection('customers');
  final CollectionReference sendEmail =
  FirebaseFirestore.instance.collection('mail');

  Future<void> addUser(String name,String email,String phone,String country,String address,BuildContext context,String lattitude,String longitude,String pincode) async{
    showLoadingIndicator(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dev_id=preferences.getString('dev_id')??'';
    String uid=preferences.getString('uid')??'';
    String img=preferences.getString('img')??'';
    return users
    // existing document in 'users' collection: "ABC123"
        .doc(uid)
        .set({
      'active':true,
      'name': name,
      'email': email,
      'phone': phone,
      'country': country,
      'image': img,
      'orderCount': '0',
      'device_id':dev_id,
      'registrationTime':DateTime.now()
    },
      SetOptions(merge: true),
    )
        .then(
            (value){
              print("data merged with existing data!");
               FirebaseFirestore.instance.collection('customers').doc(uid).collection('customerAddresses')
                  .add(
                AddressModel(name: name, mobile: phone, email: email, country: country, address: address, type: '', id: '',pinCode: pincode,latitude: lattitude,longitude: longitude).toJson(),
              ).then((value) {
                 FirebaseFirestore.instance.collection('customers').doc(uid).set({
                   'defualtAddressId':value.id.toString()
                 },SetOptions(merge: true),);
               });
              sendEmailFromVendor(
                email: email,
                subject: 'Customer Registration Confirmation',
                msg: formVendorRegMsg(),
              );
              Navigator.of(context).pop();
              setAsLoggedIn(true);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()), (route) => false);
              Fluttertoast.showToast(msg: 'Registered successfully');
            }
    )
        .catchError((error) {
      print("Failed to merge data: $error");
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Register failed, try again');
    });
  }
  sendEmailFromVendor({String? email, String? subject, String? msg}) async {
    await sendEmail.add(
      {
        'to': "${email}",
        'cc': 'info@bhaap.com',
        'bcc': ['thumbeti@gmail.com'],
        'message': {
          'subject': "${subject}",
          'text': '${msg}',
        }
      },
    ).then(
          (value) {
        print("Queued email for delivery.");
      },
    );
    print('Email is sent');
  }
  Future<bool> checkIfUserExists(String docId) async {
    try {
      var doc = await users.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
  Future<bool> checkIfUserActive(String docId) async {
    try {
      var doc = await users.doc(docId).get();
      return doc['active'];
    } catch (e) {
      return false;
    }
  }
  setAsLoggedIn(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', status);
  }
  String formVendorRegMsg() {
    return 'Hi,\n\n'
        'Welcome to BhaApp!\n\n'
        'We\'re passionate about supporting local businesses at BhaApp, as we believe they are'
        'the backbone of thriving communities. By connecting customers with local vendors and '
        'making it easy for them to access authentic traditional products and services, '
        'we\'re helping to strengthen local economies and preserve cultural heritage.\n\n'
        'BhaApp is dedicated to providing customers with the opportunity to discover and '
        'enjoy authentic traditional products and services from local vendors. '
        'We believe that supporting local businesses is essential to building strong communities,'
        'and we\'re committed to making it easy for customers to connect with these vendors and '
        'experience their unique offerings. Our platform allows customers to browse a wide range of'
        ' products and services, all of which are delivered straight to their doorstep for maximum convenience.\n\n'
        'By registering with us, you are acknowledging that you have read, understood, and accepted to '
        'the terms & conditions and other policies specified on our website, www.bhaapp.com.\n\n'
        'If you need help or have any questions, please contact us. We\'re always happy to assist you.\n\n'
        'Thanking you,\n\n'
        'BhaApp Team\n'
        'Oxysmart Private Limited\n'
        '#324, 8th Cross, MCECHS Layout Phase 1, Bangalore 560 077, info@bhaapp.com';
  }
}