import 'package:bhaapp/home/model/ratingModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/loading_indicator.dart';

class RateVendor{
  Future<String> addRating(BuildContext context,String rating,String comment)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid=preferences.getString('uid');
    String vendorDocId=preferences.getString('vendorDocId')??'';



    await FirebaseFirestore.instance.collection('vendors').doc(vendorDocId).collection('rating').doc(uid)
        .set(
      RatingModel(
        rating: rating,
        cid: uid!,
        time: DateTime.now().toString(),
        comment: comment
      ).toJson(),
    );
    Fluttertoast.showToast(msg: 'rating added successfully');
    return 'success';
  }
}