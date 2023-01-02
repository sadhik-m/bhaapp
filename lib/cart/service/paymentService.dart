import 'dart:convert';

import 'package:bhaapp/cart/service/cartLengthService.dart';
import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/payment/payment_screen.dart';
import 'package:bhaapp/payment/payment_success_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../order/model/orderStatusModel.dart';
import '../../product/model/cartModel.dart';
import '../../profile/model/profileModel.dart';




class PaymentService{
  // WEB Intent
  checkOut(BuildContext context,String deliveryAddress,String deliveryOption,String orderAmount,Map<String, int> items,String deliveryTime,String customerPhone,String categoryType)async{
    showLoadingIndicator(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid= preferences.getString('uid');
    String ? vendorId = preferences.getString('vendorId');
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
       getTolken(context, documentSnapshot['phone'], documentSnapshot['email'], documentSnapshot['name'], '$uid${DateTime.now().toString().replaceAll(RegExp('[^A-Za-z0-9]'), '').replaceAll(' ', '')}',
       deliveryAddress,deliveryOption,orderAmount,items,uid!,vendorId!,deliveryTime,customerPhone,categoryType);
      } else {
        print('Document does not exist on the database');
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'payment failed');
      }
    });
  }
  getTolken(BuildContext context,String phone,String email,String name,String orderid,String deliveryAddress,String deliveryOption,
      String orderAmount,Map<String, int> items,String uid,String vid,String deliveryTime,String customerPhone,String categoryType)async{

 // var url='https://test.cashfree.com/api/v2/cftoken/order';
  var url='https://sandbox.cashfree.com/pg/orders';
  var body=json.encode({
    "order_id": orderid,
    "order_amount":double.parse(orderAmount.toString()),
    "order_currency": "INR",
  "customer_details": {
  "customer_id": uid,
  "customer_name": name,
  "customer_email": email,
  "customer_phone": phone
  },
  "order_meta": {
  "notify_url": "https://test.cashfree.com"
  },
  "order_note": "some order note here",
  });
  var response= await http.post(Uri.parse(url),
  headers: {
    'Content-Type': 'application/json',
     'x-client-id' :'280475a5b573c10a4016818b7d574082',
     'x-client-secret': '2235fabf990fddb9e46dfe101f9a84ec9c0dbad2',
    'x-api-version': "2022-09-01",
    'x-request-id': "BhaApp"
  },
  body:body ).then((value)  {
    print(value.body.toString());
    if(value.body.contains('payment_session_id')){
      Navigator.of(context).pop();
      var data=json.decode(value.body.toString());
      print(data['payment_session_id']);
      makePayment(data['payment_session_id'],context, phone, email, name, orderid,deliveryAddress,deliveryOption,
          orderAmount,items,uid,vid,deliveryTime,customerPhone,categoryType);
    }else{
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'payment failed');
    }
  });

  }


  makePayment(String tolken,BuildContext context,String phone,String email,String name,String orderid,
      String deliveryAddress,String deliveryOption,String orderAmount,Map<String, int> items,String uid,String vid,String deliveryTime,String customerPhone,String categoryType) {
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PayScreen(orderId: orderid, paymentSessionId: tolken,
          deliveryAddress: deliveryAddress, deliveryOption: deliveryOption, orderAmount: orderAmount, items: items, uid: uid, vid: vid, deliveryTime: deliveryTime, customerPhone: customerPhone, categoryType: categoryType)));

 /*   try{
      CashfreePGSDK.doPayment(inputParams)
          .then((values) => values?.forEach((key, value) {

print(values);
        if(key=='txStatus'){
          if(values['txStatus'] =='SUCCESS'){

            saveOrderInfo(context, orderid, deliveryAddress, deliveryOption, orderAmount, values['paymentMode'],
                values['referenceId'], values['txTime'],items,uid,vid,deliveryTime,customerPhone,categoryType);

          }else if(values['txStatus'] =='FAILED'){
            Fluttertoast.showToast(msg: 'Payment Failed');
          }else if(values['txStatus'] =='CANCELLED'){
            Fluttertoast.showToast(msg: 'Payment Cancelled');
          }
        }
      }));
    }catch(e){
      print("ERROR +++++++++++++++ $e");
    }*/
  }

  saveOrderInfo(BuildContext context,String orderId,String deliveryAddress,String deliveryOption,String orderAmount,
      String paymentMode,String txnId,String txTime,Map<String, int> items,String uid,String vid,String deliveryTime,String customerPhone,String categoryType)async{

    showLoadingIndicator(context);
    SharedPreferences preferences =await SharedPreferences.getInstance();
    preferences.setString('cartList',CartModel.encode([]));
    DashBoardScreen.cartValueNotifier.updateNotifier(0);
    await FirebaseFirestore.instance.collection('orders').doc(txnId).set({
      'orderId': txnId,
      'deliveryAddress': deliveryAddress,
      'deliveryType': deliveryOption,
      'deliveryTime': deliveryTime,
      'deliveringBy': '',
      'customerPhone': customerPhone,
      'orderAmount': orderAmount,
      'paymentMode': paymentMode,
      'txnId': orderId,
      'txTime': txTime,
      'items':items,
      'userId':uid,
      'vendorId':vid,
      'status':'In Progress'
    },
      SetOptions(merge: true),
    ).then((value) {
      if(categoryType=='services'){
        uploadStatusesToFirebase(serviceStatusList,txnId);
      }else{
        uploadStatusesToFirebase(productStatusList,txnId);
      }
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Order placed successfully');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>PaymentSuccess()));
    });
  }
  Future<void> uploadStatusesToFirebase(List<OrderStatusModel> statusList,String txnId) async {
    String encoded = jsonEncode(statusList);
    print(encoded);
    await FirebaseFirestore.instance.collection('orders').doc(txnId).set({
      'DeliveryStatus':encoded
    },SetOptions(merge: true),);
   /* for(OrderStatusModel model in statusList) {
      await FirebaseFirestore.instance.collection('orders').doc(txnId).collection('DeliveryStatus').doc()
          .set(model.toJson());
    }*/
  }

List<OrderStatusModel> productStatusList=[
  OrderStatusModel(name: 'Order Placed', status: true, date: DateTime.now().toString()),
  OrderStatusModel(name: 'Order Packed', status: false, date: ''),
  OrderStatusModel(name: 'Shipped', status: false, date: ''),
  OrderStatusModel(name: 'Out For Delivery', status: false, date: ''),
  OrderStatusModel(name: 'Delivered', status: false, date: ''),
  //OrderStatusModel(name: 'Order Cancelled', status: false, date: ''),
];
List<OrderStatusModel> serviceStatusList=[
  OrderStatusModel(name: 'Request Received', status: true, date: DateTime.now().toString()),
  OrderStatusModel(name: 'Service in Progress', status: false, date: ''),
  OrderStatusModel(name: 'Service Completed', status: false, date: ''),
  //OrderStatusModel(name: 'Service Canceled', status: false, date: ''),
];

}
