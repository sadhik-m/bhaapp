import 'dart:convert';
import 'dart:developer';

import 'package:bhaapp/cart/service/paymentService.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'package:url_launcher/url_launcher.dart';

class NewPaymentScreen extends StatefulWidget {
  bool isTestOrder;
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
  DateTime deliveryTime;
  String customerPhone;
  String categoryType;
  double amountToVendor;
  double amountToBhaApp;
  String pinCode;
  String deliveryType;
  String pickupPoint;
  String pickupPointTime;
  NewPaymentScreen({
    Key? key,
    required this.isTestOrder,
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
    required this.pinCode,
    required this.deliveryType,
    required this.pickupPoint,
    required this.pickupPointTime,
  }) : super(key: key);

  @override
  State<NewPaymentScreen> createState() => _NewPaymentScreenState();
}

class _NewPaymentScreenState extends State<NewPaymentScreen> {
  final GlobalKey webViewKey = GlobalKey();
  late InAppWebViewController _webViewController;
  PullToRefreshController? pullToRefreshController;
  String url = "";
  final urlController = TextEditingController();

  bool loading = true;
  bool capturedUrl = false;

  @override
  void initState() {
    super.initState();
    // _loadHTML();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if(widget.isTestOrder){
        onSuccess();
      }
    });

  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            //title: new Text('Are you sure?'),
            content: new Text('Do you want to cancel this transaction ?'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  /*Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HomePage()));*/
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isTestOrder?
    Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Test Order Placing......',
          style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900),))
        ],
      ),
    ):

    WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              /* SIVA: TBD REMOVE IT after test...*/
              ElevatedButton(
                  onPressed: () {
                    onSuccess();
                  },
                  child: const Text('TestOrder - RemoveIt')),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Use ',
                        style: TextStyle(fontSize: 19),
                      ),
                      TextSpan(
                        text: 'UPI Payment Method',
                        style: TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 19),
                      ),
                      TextSpan(
                        text: ' \nfor quicker payments.',
                        style: TextStyle(fontSize: 19),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: InAppWebView(
                  key: webViewKey,
                  initialUrlRequest: URLRequest(
                      url: Uri.parse(
                          'https://bhaapp.com/payments/api/app/checkout?amount=${(double.parse(widget.orderAmount.toString())).toString()}&order_id=${widget.orderid}&billing_email=${widget.email}&billing_tel=${widget.phone}')),
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                        javaScriptEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useWideViewPort: false,
                        useHybridComposition: true,
                        loadWithOverviewMode: true,
                        domStorageEnabled: true,
                      ),
                      ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                          enableViewportScale: true,
                          ignoresViewportScaleLimits: true)),
                  /*initialData: InAppWebViewInitialData(

                      data: _loadHTML()
                  ),*/
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                  },
                  pullToRefreshController: pullToRefreshController,
                  onLoadStart:
                      (InAppWebViewController controller, Uri? url) async {
                    Fluttertoast.showToast(
                        msg: 'onloadStart - url:' + url.toString());
                    setState(() {
                      this.url = url.toString();
                      urlController.text = this.url;
                      /* controller.getHtml().then((value) {
                       print('MY HTMLL  $value');
                     });*/
                    });
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var url = navigationAction.request.url;
                    Fluttertoast.showToast(
                        msg:
                            'shouldOverrideUrlLoading - url:' + url.toString());
                    if (url.toString().contains('upi://pay?pa')) {
                      Fluttertoast.showToast(
                          msg: 'shouldOverrideUrlLoading - url contains UPI:' +
                              url.toString());
                      Fluttertoast.showToast(
                          msg: 'shouldOverrideUrlLoading - lanching UPI:' +
                              url.toString());
                      launchUrl(url!);
                      return NavigationActionPolicy.CANCEL;
                      /*
                      if (await canLaunchUrl(url!)) {
                        Fluttertoast.showToast(
                            msg: 'shouldOverrideUrlLoading - lanching UPI:' +
                                url.toString());
                        launchUrl(url);
                        return NavigationActionPolicy.CANCEL;
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'shouldOverrideUrlLoading - Can not lanch UPI but lanching:' +
                                    url.toString());
                        launchUrl(url);
                        return NavigationActionPolicy.CANCEL;
                        //throw 'Could not launch UPI payment app.';
                      }
                       */
                    } else {
                      return NavigationActionPolicy.ALLOW;
                    }
                  },
                  onLoadError: (controller, url, code, message) {
                    print(message);
                    Fluttertoast.showToast(
                        msg: 'onLoadError - url:' +
                            url.toString() +
                            ' code: ' +
                            code.toString() +
                            ' msg: ' +
                            message);
                  },
                  onLoadStop:
                      (InAppWebViewController controller, Uri? pageUri) async {
                    setState(() {
                      loading = false;
                    });
                    print('current URL IS ???? ' + pageUri.toString());
                    Fluttertoast.showToast(
                        msg: 'onLoadStop - url:' + pageUri.toString());
                    final page = pageUri.toString();

                    if (page ==
                        'https://bhaapp.com/payments/api/app/payment_success') {
                      if (capturedUrl == false) {
                        onSuccess();
                      }
                    } else if (page ==
                        'https://bhaapp.com/payments/api/app/payment_error') {
                      if (capturedUrl == false) {
                        onError();
                        //onSuccess();
                      }
                    }
                  },
                ),
              ),
              (loading)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Center(),
            ],
          ),
        ),
      ),
    );
  }

  onSuccess() {
    setState(() {
      capturedUrl = true;
    });
    PaymentService().saveOrderInfo(
        context,
        false,
        widget.orderid,
        widget.deliveryAddress,
        widget.deliveryOption,
        widget.orderAmount,
        'CCAvenue',
        'payment_session_id',
        DateTime.now().toString(),
        widget.items,
        widget.uid,
        widget.vid,
        widget.deliveryTime,
        widget.customerPhone,
        widget.categoryType,
        widget.amountToVendor,
        widget.amountToBhaApp,
        widget.pinCode,
        widget.deliveryType,
        widget.pickupPoint,
        widget.pickupPointTime);
  }

  onError() {
    setState(() {
      capturedUrl = true;
    });
    setState(() {
      pageIndex = 3;
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen()),
        (route) => false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Payment Failed')));
  }
}
//https://bhaapp.com/api/app/checkout?amount=amount&order_id=orderid&billing_email=email&billing_tel=phone
