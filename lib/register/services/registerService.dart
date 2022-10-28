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

  Future<void> addUser(String name,String email,String phone,String country,String address,BuildContext context,String lattitude,String longitude,String pincode) async{
    showLoadingIndicator(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
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
}