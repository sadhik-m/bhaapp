import 'dart:convert';
import 'dart:math';

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
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../order/model/orderStatusModel.dart';
import '../../product/model/cartModel.dart';
import '../../profile/model/profileModel.dart';




class PaymentService{
  // WEB Intent
  checkOut(BuildContext context,String deliveryAddress,String deliveryOption,String orderAmount,Map<String, int> items,String deliveryTime,
      String customerPhone,String categoryType,double amountToVendor,double amountToBhaApp,String pinCode,String deliveryType)async{
    showLoadingIndicator(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid= preferences.getString('uid');
    String ? vendorId = preferences.getString('vendorId');
    String ? razorpayId = preferences.getString('razorpayId');
    /*var rndnumberOrder="";
    var rnd= new Random();
    for (var i = 0; i < 4; i++) {
      rndnumberOrder = rndnumberOrder + rnd.nextInt(9).toString();
    }*/
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        makePayment(context, documentSnapshot['phone'], documentSnapshot['email'], documentSnapshot['name'],
           '${documentSnapshot['phone'].toString().replaceAll(' ', '').replaceAll('+', '').replaceAll('(', '').replaceAll(')', '')}_${((double.parse(documentSnapshot['orderCount']))+1).toInt()}',
       deliveryAddress,deliveryOption,orderAmount,items,uid!,vendorId!,deliveryTime,
           customerPhone,categoryType,amountToVendor,amountToBhaApp,razorpayId!, pinCode, deliveryType);
      } else {

        print('Document does not exist on the database');
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'payment failed');
      }
    });
  }


  makePayment(BuildContext context,String phone,String email,String name,String orderid,
      String deliveryAddress,String deliveryOption,String orderAmount,Map<String, int> items,String uid,String vid,String deliveryTime,
      String customerPhone,String categoryType,double amountToVendor,double amountToBhaApp,String razorpayId,
      String pinCode,String deliveryType) {

    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_ZGpUT4mDZTOmrM',
      'amount': double.parse(orderAmount)*100,
      //"payment_capture": 1,
      'name': 'BhaApp',
      'description': '',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': customerPhone, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment Failed')));
      Navigator.of(context).pop();
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response)async{
      String credentials = "rzp_test_ZGpUT4mDZTOmrM:jCbWl5d6R9D1e20I87XD2ZJM";
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(credentials);

      await http.post(Uri.parse('https://api.razorpay.com/v1/payments/${response.paymentId}/capture',),
          body: json.encode({
            "amount": double.parse(orderAmount)*100,
            "currency": "INR"
          }),
          headers: {
            'Authorization':"Basic " +encoded,
            'Accept':'*/*',
            'Content-Type':'application/json',
            'Accept-Encoding':'gzip, deflate, br',
            'Connection':'keep-alive',
          }
      ).then((value) {
        print("CCCCAAAAAAAAAAAA   ${value.body.toString()}");
        print("razorpayId   ${razorpayId.toString()}");
        if(value.statusCode==200){
          http.post(Uri.parse('https://api.razorpay.com/v1/payments/${response.paymentId}/transfers',),
              body: json.encode({
                "transfers": [
                  {
                    "account": razorpayId,
                    "amount": double.parse(amountToVendor.toString())*100,
                    "currency": "INR",
                    "notes": {
                      "vendor_id": vid,
                    },
                    "linked_account_notes": [
                    ],
                    "on_hold": false
                  }
                ]
              }),
              headers: {
                'Authorization':"Basic " +encoded,
                'Accept':'*/*',
                'Content-Type':'application/json',
                'Accept-Encoding':'gzip, deflate, br',
                'Connection':'keep-alive',
              }
          ).then((value) {
            print("TTTTTRRRRRRRRRAAAAAAAAAA   ${value.body.toString()}");
            if(value.statusCode==200){
              PaymentService().saveOrderInfo(context, orderid,
                  deliveryAddress, deliveryOption, orderAmount,
                  'RazorPay',
                  response.paymentId.toString(),
                  DateTime.now().toString(),items,uid,vid,deliveryTime,customerPhone,categoryType,
                  amountToVendor,amountToBhaApp, pinCode, deliveryType);
            }else{
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('payment failed')));
              Navigator.of(context).pop();
            }
          });
        }
      });

    });
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (ExternalWalletResponse response){
      //showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
    });
    razorpay.open(options);

  }

  saveOrderInfo(BuildContext context,String orderId,String deliveryAddress,String deliveryOption,String orderAmount,
      String paymentMode,String txnId,String txTime,Map<String, int> items,String uid,String vid,
      String deliveryTime,String customerPhone,String categoryType,double amountToVendor,double amountToBhaApp,
      String pinCode,String deliveryType)async{

    //showLoadingIndicator(context);
    SharedPreferences preferences =await SharedPreferences.getInstance();
    preferences.setString('cartList',CartModel.encode([]));
    DashBoardScreen.cartValueNotifier.updateNotifier(0);
    await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
      'orderId':orderId ,
      'deliveryAddress': deliveryAddress,
      'deliveryType': deliveryOption,
      'deliveryTime': deliveryTime,
      'deliveringBy': '',
      'customerPhone': customerPhone,
      'orderAmount': orderAmount,
      'paymentMode': paymentMode,
      'txnId': txnId,
      'txTime': txTime,
      'items':items,
      'userId':uid,
      'vendorId':vid,
      'status':'Order Placed',
      'AmountToVendor':'$amountToVendor',
      'AmountToBhaApp':'$amountToBhaApp',
      'DeliveringService':'$deliveryType',
      'deliveryPincode':'$pinCode'
    },
      SetOptions(merge: true),
    ).then((value) async{
      if(categoryType=='services'){
        uploadStatusesToFirebase(serviceStatusList,orderId);
      }else{
        if(deliveryOption=='store pickup'){
          uploadStatusesToFirebase(productStatusStorePickupList,orderId);
        }else{
          uploadStatusesToFirebase(productStatusDeliverByBhaappList,orderId);
        }

      }

      await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          FirebaseFirestore.instance.collection('customers').doc(uid).update({'orderCount': '${((double.parse(documentSnapshot['orderCount']))+1).toInt()}'});
        } else {
          print('Document does not exist on the database');
        }
      });



      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Order placed successfully');
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>PaymentSuccess()), (route) => false);
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



List<OrderStatusModel> productStatusDeliverByBhaappList=[
  OrderStatusModel(name: 'Order Placed', status: true, date: DateTime.now().toString(),image: ''),
  OrderStatusModel(name: 'Accepted', status: false, date: '',image: ''),
  OrderStatusModel(name: 'Ready For Pickup', status: false, date: '',image: ''),
  OrderStatusModel(name: 'Out For Delivery', status: false, date: '',image: ''),
  OrderStatusModel(name: 'Delivered', status: false, date: '',image: ''),
  //OrderStatusModel(name: 'Order Cancelled', status: false, date: ''),
];
  List<OrderStatusModel> productStatusStorePickupList=[
  OrderStatusModel(name: 'Order Placed', status: true, date: DateTime.now().toString(),image: ''),
  OrderStatusModel(name: 'Accepted', status: false, date: '',image: ''),
  OrderStatusModel(name: 'Ready For Pickup', status: false, date: '',image: ''),
  OrderStatusModel(name: 'Delivered', status: false, date: '',image: ''),
  //OrderStatusModel(name: 'Order Cancelled', status: false, date: ''),
];
List<OrderStatusModel> serviceStatusList=[
  OrderStatusModel(name: 'Order Placed', status: true, date: DateTime.now().toString(),image: ''),
  OrderStatusModel(name: 'Accepted', status: false, date: '',image: ''),
  OrderStatusModel(name: 'InProgress', status: false, date: '',image: ''),
  OrderStatusModel(name: 'Done', status: false, date: '',image: ''),
  //OrderStatusModel(name: 'Service Canceled', status: false, date: ''),
];

}
