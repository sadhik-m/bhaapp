import 'dart:convert';

import 'package:bhaapp/Report/model/bankdetailModel.dart';
import 'package:bhaapp/address/model/addressModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/widgets/loading_indicator.dart';
import '../../dashboard/dash_board_screen.dart';
import '../../order/model/orderStatusModel.dart';

class ReportIssueService{
  CollectionReference reportedIssues = FirebaseFirestore.instance.collection('reportedIssues');

  Future<void> reportIssue(String issue,String image,String notes,String orderid,BankDetailModel bankDetailModel,BuildContext context) async{
    showLoadingIndicator(context);
   // final docId = FirebaseFirestore.instance.collection('collectionName').doc().id;
    List<OrderStatusModel> refundStatusList=[
      OrderStatusModel(
          name: 'Issue Reported',
          status: true,
          date: DateTime.now().toString(),
          image:image),
    ];
    String reportEncoded = jsonEncode(refundStatusList);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid=preferences.getString('uid')??'';
    return reportedIssues
        .doc(orderid)
        .set({
      'status':'Issue Reported',
      'Issue': issue,
      'image': image,
      'notes': notes,
      //'refundBankDetails': bankDetailModel.toJson(),
      'orderId': orderid,
      'reportedTime':DateTime.now(),
      'reportStatusList': reportEncoded
    },
      SetOptions(merge: true),
    )
        .then(
            (value)async{

          await  FirebaseFirestore.instance.collection('customers').doc(uid).set({
              'refundBankDetails': bankDetailModel.toJson(),
            },SetOptions(merge: true),);

            await FirebaseFirestore.instance
              .collection('orders')
              .doc(orderid)
              .set(
            {'status': 'Issue Reported'},
            SetOptions(merge: true),
          );

          Navigator.of(context).pop();
          Fluttertoast.showToast(msg: 'Issue Reported successfully');
          pageIndex = 1;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => DashBoardScreen()),
                  (route) => false);
        }
    )
        .catchError((error) {
      print("Failed to report issue: $error");
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Failed to report issue: $error');
    });
  }
}