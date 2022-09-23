import 'dart:convert';

import 'package:bhaapp/address/model/addressModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetAddress{
  Future<List<AddressModel>> getAddress()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid=preferences.getString('uid');
    List<AddressModel> adressList=[];
    await FirebaseFirestore.instance.collection('customers').doc(uid).collection('customerAddresses').get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        adressList.add(AddressModel(name: doc['name'], mobile: doc['mobile'], email: doc['email'], country: doc['country'], address: doc['address'], type: doc['type']));
      });
    });

    return adressList;
  }
}