import 'dart:convert';

import 'package:bhaapp/address/model/addressModel.dart';
import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNewAddress{
  Future<String> addAddress(AddressModel addressModel,BuildContext context)async{
    showLoadingIndicator(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid=preferences.getString('uid');


        await FirebaseFirestore.instance.collection('customers').doc(uid).collection('customerAddresses')
            .add(
           addressModel.toJson(),
        );


    Navigator.of(context).pop();
    Fluttertoast.showToast(msg: 'address added successfully');
    return 'success';
  }
  makeDefualt(String addressId)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid=preferences.getString('uid')??'';
    await FirebaseFirestore.instance.collection('customers').doc(uid)
        .set({
      'defualtAddressId': addressId
    },
      SetOptions(merge: true),
    );
  }
}