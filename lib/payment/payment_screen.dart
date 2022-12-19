import 'dart:convert';

import 'package:bhaapp/cart/service/paymentService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

class PayScreen extends StatefulWidget {
  String orderId;
  String paymentSessionId;
  String deliveryAddress;
  String deliveryOption;
  String orderAmount;
  Map<String, int> items;
  String uid;
  String vid;
  String deliveryTime;
  String customerPhone;
  String categoryType;
   PayScreen({Key? key,required this.orderId,required this.paymentSessionId,
   required this.deliveryAddress,
  required this.deliveryOption,
  required this.orderAmount,
  required this.items,
  required this.uid,
  required this.vid,
  required this.deliveryTime,
  required this.customerPhone,
  required this.categoryType}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {

  var cfPaymentGatewayService = CFPaymentGatewayService();

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
    pay();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        body: Container(),
      ),
    );
  }

  void verifyPayment(String orderId) async{
    var url='https://sandbox.cashfree.com/pg/orders/$orderId';

    var response= await http.get(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-client-id' :'280475a5b573c10a4016818b7d574082',
          'x-client-secret': '2235fabf990fddb9e46dfe101f9a84ec9c0dbad2',
          'x-api-version': "2022-09-01",
          'x-request-id': "BhaApp"
        }, ).then((value)  {
      developer.log('Verify Payment   '+value.body.toString());
        if(value.body.contains('"order_status":"PAID"')){
         // Navigator.of(context).pop();
          var data=json.decode(value.body.toString());
          PaymentService().saveOrderInfo(context, widget.orderId,
              widget.deliveryAddress, widget.deliveryOption, widget.orderAmount,
              'CashFree',
              data['payment_session_id'],
              DateTime.now().toString(),widget.items,widget.uid,widget.vid,widget.deliveryTime,widget.customerPhone,widget.categoryType);

        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction Failed')));
          Navigator.of(context).pop();
        }
    });

  }

  void onError(CFErrorResponse errorResponse, String orderId) {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${errorResponse.getMessage().toString()}')));
   Navigator.of(context).pop();

  }

  CFEnvironment environment = CFEnvironment.SANDBOX;

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(widget.orderId).setPaymentSessionId(widget.paymentSessionId).build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }

  pay() async {
    try {
      var session = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#FF0000").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      print(e.message);
    }

  }

}


/*{"cf_order_id":3370659,"created_at":"2022-12-19T19:20:09+05:30",
"customer_details":{"customer_id":"hybyPvBXKGWwqXpFzMle6DXRkFB2","customer_name":"sadhik",
"customer_email":"sa@gmail.com","customer_phone":"+919745870374"},
"entity":"order","order_amount":1206.75,"order_currency":"INR",
"order_expiry_time":"2023-01-18T19:20:09+05:30",
"order_id":"hybyPvBXKGWwqXpFzMle6DXRkFB220221219192008942230",
"order_meta":{"return_url":null,"notify_url":"https://test.cashfree.com","payment_methods":null},
"order_note":"some order note here","order_splits":[],"order_status":"PAID","order_tags":null,"payment_session_id":"session_pt3CnstffzOM4RNNiP2xnYqRZ6j2HM9IUKmei_muhIwRPKODcYK9-8rn0-l7axK_CRwgd81tzJ7x-awFlVahO8Jh7gFg1B1EdX0rCndlgFZS","payments":{"url":"https://sandbox.cashfree.com/pg/orders/hybyPvBXKGWwqXpFzMle6DXRkFB220221219192008942230/payments"},"refunds":{"url":"https://sandbox.cashfree.com/pg/orders/hybyPvBXKGWwqXpFzMle6DXRkFB220221219192008942230/refunds"},"settlements":{"url":"https://sandbox.cashfree.com/pg/orders/hybyPvBXKGWwqXpFzMle6DXRkFB220221219192008942230/settlements"},"terminal_data":null}*/