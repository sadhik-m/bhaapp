import 'dart:async';

//import 'package:cc_avenue/cc_avenue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CCPage extends StatefulWidget {
  @override
  _CCPageState createState() => _CCPageState();
}

class _CCPageState extends State<CCPage> {
  @override
  void initState() {
    super.initState();
  }

  /// [initPlatformState] this calls the [cCAvenueInit]
  // Platform messages are asynchronous, so we initialize in an async method.
/*  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await CcAvenue.cCAvenueInit(
          transUrl: 'https://secure.ccavenue.com/transaction/initTrans',
          accessCode: 'AVRA29KC93BJ02ARJB',
          amount: '10',
          cancelUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
          currencyType: 'INR',
          merchantId: '2146798',
          orderId: '519',
          redirectUrl: 'http://122.182.6.216/merchant/ccavResponseHandler.jsp',
          rsaKeyUrl: 'https://secure.ccavenue.com/transaction/jsp/GetRSA.jsp'
      );

    } catch(e) {
      print(e);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: (){
             // initPlatformState();
            }, child: Text('Invoke'),
          ),
        ),
      ),
    );
  }
}