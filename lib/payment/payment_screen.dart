/*import 'dart:convert';

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
import 'dart:developer' as developer;*/

/*class PayScreen extends StatefulWidget {
  String phone;
  String email;
  String name;
  String orderid;
  String deliveryAddress;
  String deliveryOption;
  String orderAmount;
  Map<String, int> items;
  String uid;
  String vid;
  String deliveryTime;
  String customerPhone;
  String categoryType;
  double amountToVendor;
  double amountToBhaApp;
  String razorpayId;
  String pinCode;
  String deliveryType;
  String paymentTolken;
  PayScreen({Key? key,
    required this.phone,
    required this.email,
    required this.name,
    required this.orderid,
    required this.deliveryAddress,
    required this.deliveryOption,
    required this.orderAmount,
    required this.items,
    required this.uid,
    required this.vid,
    required this.deliveryTime,
    required this.customerPhone,
    required this.categoryType,
    required this.amountToVendor,
    required this.amountToBhaApp,
    required this.razorpayId,
    required this.pinCode,
    required this.deliveryType,
    required this.paymentTolken,
  }) : super(key: key);

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


  void splitPayment(String orderId) async{
    var url='https://api.cashfree.com/api/v2/easy-split/orders/$orderId/split';

    var response= await http.post(Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'x-client-id' :'280475a5b573c10a4016818b7d574082',
        'x-client-secret': '2235fabf990fddb9e46dfe101f9a84ec9c0dbad2',
        'x-api-version': "2022-09-01",
        'x-request-id': "BhaApp"
      },
      body: jsonEncode({
        "split": [
          {
            "vendorId": widget.razorpayId,
            "amount": widget.amountToVendor,
            "percentage": null
          },

        ],
        "splitType": widget.orderAmount
      })
    ).then((value)  {
      developer.log('Split Payment   '+value.body.toString());
      if(value.body.contains('"status": "OK"')){
        // Navigator.of(context).pop();
        var data=json.decode(value.body.toString());

        verifyPayment(orderId);

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Transaction Failed')));
        Navigator.of(context).pop();
      }
    });

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
        PaymentService().saveOrderInfo(context, widget.orderid,
            widget.deliveryAddress, widget.deliveryOption, widget.orderAmount,
            'RazorPay',
            data['payment_session_id'],
            DateTime.now().toString(),widget.items,widget.uid,widget.vid,widget.deliveryTime,widget.customerPhone,
            widget.categoryType,
            widget.amountToVendor,widget.amountToBhaApp, widget.pinCode, widget.deliveryType);

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
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(widget.orderid).setPaymentSessionId(widget.paymentTolken).build();
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

}*/
