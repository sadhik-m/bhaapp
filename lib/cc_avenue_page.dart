/*
import 'dart:async';

//import 'package:cc_avenue/cc_avenue.dart';
import 'package:bhaapp/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CCPage extends StatefulWidget {
  @override
  _CCPageState createState() => _CCPageState();
}

class _CCPageState extends State<CCPage> {
  bool loading = true;
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // _loadHTML();
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        // appBar: AppBar(
        //   title: Text('Payment'),
        // ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: InAppWebView(
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
                  initialData: InAppWebViewInitialData(

                      data: _loadHTML()),
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                  },
                  onLoadError: (controller, url, code, message) {
                    print(message);
                  },
                  onLoadStop:
                      (InAppWebViewController controller, Uri? pageUri) async {
                    setState(() {
                      loading = false;
                    });
                    print(pageUri.toString());
                    final page = pageUri.toString();

                    if (page == '') {
                      var html = await controller.evaluateJavascript(
                          source:
                          "window.document.getElementsByTagName('html')[0].outerHTML;");

                      String html1 = html.toString();
                      print(html1);
                      if (html1.contains('<body>')) {
                        html1 = html1.split('<body>')[1].split('</body>')[0];

                        // Map<String, dynamic> map = jsonDecode(html1);
                        // String status = map['order_status'];
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentStatus(resp: html1.toString())),
                                (Route<dynamic> route) => false);
                      }
                    }
                  },
                ),
              ),
              (loading)
                  ? Center(
                child: CircularProgressIndicator(),
              )
                  : Center(),
            ],
          ),
        ),
      ),
    );
  }

  String _loadHTML() {
    final url = Uri.parse('https://qasecure.ccavenue.com/transaction.do');
    final command = "initiateTransaction";
    final encRequest = '3B0FE3681EB145DB3684B75196CBB7C4';
    final accessCode = 'AVRA29KC93BJ02ARJB';

    String html =
        "<html> <head><meta name='viewport' content='width=device-width, initial-scale=1.0'></head> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$url'>" +
            "<input type='hidden' name='command' value='$command'/>" +
            "<input type='hidden' name='encRequest' value='$encRequest' />" +
            "<input  type='hidden' name='access_code' value='$accessCode' />";
    print(html);
    return html + "</form> </body> </html>";
  }
}



class PaymentStatus extends StatefulWidget {
  final String resp;

  const PaymentStatus({required this.resp});

  @override
  _PaymentStatusState createState() => _PaymentStatusState();
}

class _PaymentStatusState extends State<PaymentStatus> {
  Future<bool> _onWillPop() async {
    Navigator.of(context).pushAndRemoveUntil<bool>(
        MaterialPageRoute(builder: (context) => HomeScreen()),
            (Route<dynamic> route) => false);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
          appBar: AppBar(
            title: Text("Payment Status"),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 40),
                  Text(
                    widget.resp,
                    style:
                    new TextStyle(fontSize: 14, color: Colors.black),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
*/
