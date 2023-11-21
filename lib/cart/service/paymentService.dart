import 'dart:convert';
import 'dart:math';

import 'package:bhaapp/cart/service/cartLengthService.dart';
import 'package:bhaapp/cart/service/send_notification.dart';
import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/payment/payment_screen.dart';
import 'package:bhaapp/payment/payment_success_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../order/model/orderStatusModel.dart';
import '../../payment/new_payment_screen.dart';
import '../../product/model/cartModel.dart';
import '../../profile/model/profileModel.dart';

class PaymentService {
  // WEB Intent
  checkOut(
      BuildContext context,
      String deliveryAddress,
      String deliveryOption,
      String orderAmount,
      Map<String, int> items,
      DateTime deliveryTime,
      String customerPhone,
      String categoryType,
      double amountToVendor,
      double amountToBhaApp,
      String pinCode,
      String deliveryType,
      String pickupPoint,
      String pickupPointTime) async {
    showLoadingIndicator(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? uid = preferences.getString('uid');
    String? vendorId = preferences.getString('vendorId');
    /*var rndnumberOrder="";
    var rnd= new Random();
    for (var i = 0; i < 4; i++) {
      rndnumberOrder = rndnumberOrder + rnd.nextInt(9).toString();
    }*/
    final value = await FirebaseFirestore.instance.collection("testIDs").doc('testCustomerIds').get();

    List<String> testIds = List.from(value.data()!["emails"]);



    print("SSSSSSSS2 ${testIds.toString()}");
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
          makePayment(
              context,
              testIds.contains(documentSnapshot['email'])?true:false,
              documentSnapshot['phone'],
              documentSnapshot['email'],
              documentSnapshot['name'],
              '${documentSnapshot['phone'].toString().replaceAll(' ', '')
                  .replaceAll('+', '').replaceAll('(', '')
                  .replaceAll(')', '')}_${((double.parse(
                  documentSnapshot['orderCount'])) + 1).toInt()}',
              deliveryAddress,
              deliveryOption,
              orderAmount,
              items,
              uid!,
              vendorId!,
              deliveryTime,
              customerPhone,
              categoryType,
              amountToVendor,
              amountToBhaApp,
              pinCode,
              deliveryType,
              '',
              pickupPoint,
              pickupPointTime);


      } else {
        print('Document does not exist on the database');
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'payment failed');
      }
    });
  }

/*  getTolken(BuildContext context,String phone,String email,String name,String orderid,
      String deliveryAddress,String deliveryOption,String orderAmount,Map<String, int> items,String uid,String vid,String deliveryTime,
      String customerPhone,String categoryType,double amountToVendor,double amountToBhaApp,String razorpayId,
      String pinCode,String deliveryType)async{
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
    // var url='https://test.cashfree.com/api/v2/cftoken/order';
    var url='https://bhaapp.in/api/app/checkout?amount=${(double.parse(orderAmount.toString())).toString()}&order_id=$orderid';
    print(url.toString());
    var response= await http.get(Uri.parse(url)).then((value)  {
      print(value.body.toString());
      Navigator.of(context).pop();
      if(value.body.contains('payment_session_id')){
        Navigator.of(context).pop();
        var data=json.decode(value.body.toString());
        print(data['payment_session_id']);

      }else{
        Navigator.of(context).pop();
        Fluttertoast.showToast(msg: 'payment failed');
      }
    });

  }*/

  makePayment(
      BuildContext context,
      bool isTest,
      String phone,
      String email,
      String name,
      String orderid,
      String deliveryAddress,
      String deliveryOption,
      String orderAmount,
      Map<String, int> items,
      String uid,
      String vid,
      DateTime deliveryTime,
      String customerPhone,
      String categoryType,
      double amountToVendor,
      double amountToBhaApp,
      String pinCode,
      String deliveryType,
      String paymentTolken,
      String pickupPoint,
      String pickupPointTime) {
    Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewPaymentScreen(
              isTestOrder: isTest,
                phone: phone,
                email: email,
                name: name,
                orderid: orderid,
                deliveryAddress: deliveryAddress,
                deliveryOption: deliveryOption,
                orderAmount: orderAmount,
                items: items,
                uid: uid,
                vid: vid,
                deliveryTime: deliveryTime,
                customerPhone: customerPhone,
                categoryType: categoryType,
                amountToVendor: amountToVendor,
                amountToBhaApp: amountToBhaApp,
                pinCode: pinCode,
                deliveryType: deliveryType,
                pickupPoint: pickupPoint,
                pickupPointTime: pickupPointTime)));
  }

  saveOrderInfo(
      BuildContext context,
      bool isTestOrder,
      String orderId,
      String deliveryAddress,
      String deliveryOption,
      String orderAmount,
      String paymentMode,
      String txnId,
      String txTime,
      Map<String, int> items,
      String uid,
      String vid,
      DateTime deliveryTime,
      String customerPhone,
      String categoryType,
      double amountToVendor,
      double amountToBhaApp,
      String pinCode,
      String deliveryType,
      String pickupPoint,
      String pickupPointTime) async {
    showLoadingIndicator(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('cartList', CartModel.encode([]));
    DashBoardScreen.cartValueNotifier.updateNotifier(0);
    int startTimeGap = 0;
    int endTimeGap = 0;
    if (pickupPointTime.split(' ')[1].toLowerCase() == 'pm') {
      startTimeGap = 12;
    }
    if (pickupPointTime.split(' ')[4].toLowerCase() == 'pm') {
      endTimeGap = 12;
    }
    await FirebaseFirestore.instance.collection('orders').doc(orderId).set(
      {
        'isTestOrder':isTestOrder,
        'orderId': orderId,
        'deliveryAddress':
            (pickupPoint.isEmpty) ? deliveryAddress : pickupPoint,
        'deliveryType': deliveryOption,
        'deliveryTime':
            getDeliveryTime(pickupPoint, pickupPointTime, deliveryTime),
        'deliveryDate': deliveryTime,
        'deliveringBy': '',
        'customerPhone': customerPhone,
        'orderAmount': orderAmount,
        'paymentMode': paymentMode,
        'txnId': txnId,
        'txTime': txTime,
        'items': items,
        'userId': uid,
        'vendorId': vid,
        'status': 'Order Placed',
        'AmountToVendor': '$amountToVendor',
        'AmountToBhaApp': '$amountToBhaApp',
        'DeliveringService': '$deliveryType',
        'deliveryPincode': '$pinCode',
        'fetchedToPayVendor': false,
        'label': 0,
        'otpCode': 0,
        'pickupPoint': pickupPoint,
        if (pickupPoint.isNotEmpty)
          'pickupStartHour': DateTime(
              deliveryTime.year,
              deliveryTime.month,
              deliveryTime.day,
              int.parse(pickupPointTime.split(' ')[0]) + startTimeGap),
        if (pickupPoint.isNotEmpty)
          'pickupEndHour': DateTime(
              deliveryTime.year,
              deliveryTime.month,
              deliveryTime.day,
              int.parse(pickupPointTime.split(' ')[3]) + endTimeGap),
      },
      SetOptions(merge: true),
    ).then((value) async {
      if (categoryType == 'services') {
        uploadStatusesToFirebase(serviceStatusList, orderId);
      } else {
        if (pickupPoint.isNotEmpty) {
          uploadStatusesToFirebase(pickupPointStatusList, orderId);
        } else if (deliveryOption == 'store pickup') {
          uploadStatusesToFirebase(productStatusStorePickupList, orderId);
        } else {
          uploadStatusesToFirebase(productStatusDeliverByBhaappList, orderId);
        }
      }
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          FirebaseFirestore.instance.collection('customers').doc(uid).update({
            'orderCount':
                '${((double.parse(documentSnapshot['orderCount'])) + 1).toInt()}'
          });
          sendNotificationToAdmin(
              "You have a new order # $orderId from ${documentSnapshot['name']} at ${DateTime.now().toString()}.",
              "New Order");
          print('N#11');
        } else {
          print('Document does not exist on the database');
        }
      });
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Order placed successfully');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PaymentSuccess()),
          (route) => false);
    });
  }

  String getDeliveryTime(
      String pickupPoint, String pickupPointTime, DateTime deliveryTime) {
    if (pickupPoint.isEmpty) {
      String dDateTimeStr = DateFormat('d MMM y, hh a').format(deliveryTime);
      return 'Within 60 to 90 minutes from $dDateTimeStr';
      //return deliveryTime.toString();
    } else {
      String dDateStr = DateFormat('d MMM y').format(deliveryTime);
      return '$dDateStr $pickupPointTime';
    }
    //return (pickupPoint.isEmpty) ? 'Within 60 to 90 minutes' : pickupPointTime;
  }

  Future<void> uploadStatusesToFirebase(
      List<OrderStatusModel> statusList, String txnId) async {
    String encoded = jsonEncode(statusList);
    print(encoded);
    await FirebaseFirestore.instance.collection('orders').doc(txnId).set(
      {'DeliveryStatus': encoded},
      SetOptions(merge: true),
    );
    /* for(OrderStatusModel model in statusList) {
      await FirebaseFirestore.instance.collection('orders').doc(txnId).collection('DeliveryStatus').doc()
          .set(model.toJson());
    }*/
  }

  List<OrderStatusModel> productStatusDeliverByBhaappList = [
    OrderStatusModel(
        name: 'Order Placed',
        status: true,
        date: DateTime.now().toString(),
        image: ''),
    OrderStatusModel(name: 'Accepted', status: false, date: '', image: ''),
    OrderStatusModel(
        name: 'Ready For Pickup', status: false, date: '', image: ''),
    OrderStatusModel(
        name: 'Out For Delivery', status: false, date: '', image: ''),
    OrderStatusModel(name: 'Delivered', status: false, date: '', image: ''),
    //OrderStatusModel(name: 'Order Cancelled', status: false, date: ''),
  ];
  List<OrderStatusModel> productStatusStorePickupList = [
    OrderStatusModel(
        name: 'Order Placed',
        status: true,
        date: DateTime.now().toString(),
        image: ''),
    OrderStatusModel(name: 'Accepted', status: false, date: '', image: ''),
    OrderStatusModel(
        name: 'Ready For Pickup', status: false, date: '', image: ''),
    OrderStatusModel(name: 'Delivered', status: false, date: '', image: ''),
    //OrderStatusModel(name: 'Order Cancelled', status: false, date: ''),
  ];
  List<OrderStatusModel> serviceStatusList = [
    OrderStatusModel(
        name: 'Order Placed',
        status: true,
        date: DateTime.now().toString(),
        image: ''),
    OrderStatusModel(name: 'Accepted', status: false, date: '', image: ''),
    OrderStatusModel(name: 'InProgress', status: false, date: '', image: ''),
    OrderStatusModel(name: 'Done', status: false, date: '', image: ''),
    //OrderStatusModel(name: 'Service Canceled', status: false, date: ''),
  ];

  List<OrderStatusModel> pickupPointStatusList = [
    OrderStatusModel(
        name: 'Order Placed',
        status: true,
        date: DateTime.now().toString(),
        image: ''),
    OrderStatusModel(name: 'Accepted', status: false, date: '', image: ''),
    OrderStatusModel(
        name: 'Ready For Pickup', status: false, date: '', image: ''),
    OrderStatusModel(
        name: 'Out For Delivery', status: false, date: '', image: ''),
    OrderStatusModel(
        name: 'At Pickup Point', status: false, date: '', image: ''),
    OrderStatusModel(name: 'Delivered', status: false, date: '', image: ''),
    //OrderStatusModel(name: 'Order Cancelled', status: false, date: ''),
  ];
}
