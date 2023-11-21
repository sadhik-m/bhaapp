import 'dart:convert';
import 'dart:io';

import 'package:bhaapp/order/widget/order_summary_tile.dart';
import 'package:bhaapp/order/widget/order_tracker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../Report/view/report_issue.dart';
import '../common/constants/colors.dart';
import '../common/widgets/appBar.dart';
import '../common/widgets/black_button.dart';
import '../common/widgets/loading_indicator.dart';
import 'model/orderStatusModel.dart';

class OrderSummary extends StatefulWidget {
  String orderid;
  List<String> sku = [];
  List<String> quqntity = [];
  String shopContact;
  String shopName;
  String shopAddress;
  String orderStatus;
  String orderStatusDate;
  OrderSummary(
      {Key? key,
      required this.orderid,
      required this.sku,
      required this.quqntity,
      required this.shopContact,
      required this.orderStatus,
      required this.orderStatusDate,
      required this.shopName,
      required this.shopAddress})
      : super(key: key);

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  List<OrderStatusModel> satatusList = [];

  //bool loaded=false;
  String deliveredDate = '';
  getStatusList() async {
    print(widget.orderid);
    String stsList = await FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderid)
        .get()
        .then((value) {
      return value['DeliveryStatus'].toString();
    });
    setState(() {
      var convert = json.decode(stsList);
      print(convert);
      print(convert[0]['name']);
      for (var i = 0; i < convert.length; i++) {
        satatusList.add(OrderStatusModel(
            name: convert[i]['name'],
            status: convert[i]['status'],
            date: convert[i]['date'],
            image: convert[i]['image']));
      }
    });

    /* await FirebaseFirestore.instance.collection('orders').doc(widget.orderid).collection('DeliveryStatus').get().then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        setState(() {
          satatusList.add(OrderStatusModel(name: doc['name'], status: doc['status'], date: doc['date']));
        });
      });
    });*/
    setState(() {
      deliveredDate = satatusList[satatusList.length - 1].date;
      //loaded=true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getStatusList();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("Order Details", [], true),
      body: Container(
          height: screenHeight,
          width: screenWidth,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('orderId', isEqualTo: widget.orderid)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return SizedBox.shrink();
              }

              if (snapshot.hasData) {
                satatusList.clear();
                String stsList =
                    snapshot.data!.docs[0]['DeliveryStatus'].toString();
                var convert = json.decode(stsList);
                for (var i = 0; i < convert.length; i++) {
                  satatusList.add(OrderStatusModel(
                      name: convert[i]['name'],
                      status: convert[i]['status'],
                      date: convert[i]['date'],
                      image: convert[i]['image']));
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: screenWidth,
                              height: screenHeight * 0.065,
                              color: Color(0xff28B446).withOpacity(0.2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/home/Group 78.png',
                                    color: Color(0xff28B446),
                                    height: 13.5,
                                    width: 24,
                                  ),
                                  Text(
                                    '  The Order was delivered',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Color(0xff28B446)),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.03,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.07,
                              ),
                              child: Column(
                                children: [
                                  orderSummaryTile(
                                      screenWidth,
                                      screenHeight,
                                      widget.sku,
                                      widget.quqntity,
                                      widget.shopName,
                                      widget.shopAddress,
                                      snapshot.data!.docs[0]['orderAmount']),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Order Details',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color:
                                                Colors.black.withOpacity(0.8)),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order ID:',
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        snapshot.data!.docs[0]['orderId'],
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: splashBlue),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Payment',
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        snapshot.data!.docs[0]['paymentMode'],
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  /*
                                SizedBox(height: 16,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Date',style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black
                                    ),),
                                    Text(DateFormat('d MMM y, hh:mm a').format(DateTime.parse(satatusList[satatusList.length-1].date)),style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black
                                    ),),

                                  ],
                                ),
                                 */
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Delivery Address',
                                        style: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      Container(
                                        width: screenWidth * 0.4,
                                        child: Text(
                                          snapshot.data!.docs[0]
                                              ['deliveryAddress'],
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black
                                                  .withOpacity(0.6)),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Tracking Details',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color:
                                                Colors.black.withOpacity(0.8)),
                                      )
                                    ],
                                  ),
                                  /*SizedBox(height: 10,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Text('Estimated Delivery: ',style: GoogleFonts.inter(
                                     fontSize: 10,
                                     fontWeight: FontWeight.w400,
                                     color: Colors.black.withOpacity(0.6)
                                 ),),
                                 Text('30 Sept 2022',style: GoogleFonts.inter(
                                     fontSize: 12,
                                     fontWeight: FontWeight.w600,
                                     color: Colors.black.withOpacity(0.8)
                                 ),),
                               ],
                             ),
                             */ /*Image.asset('assets/home/356674 1.png',
                             height: 25,width: 74,)*/ /*
                           ],
                         ),*/
                                  SizedBox(
                                    height: 10,
                                  ),
                                  OrderTracker(
                                    orderStatus: snapshot.data!.docs[0]
                                        ['status'],
                                    orderStatusDate: snapshot.data!.docs[0]
                                        ['txTime'],
                                    statusList: satatusList,
                                    orderId: widget.orderid,
                                    reportedStatusList: [],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    dateTimeDifference() <= 24
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.07,
                                vertical: screenHeight * 0.01),
                            child: blackButton("Report an Issue", () {
                              if (snapshot.data!.docs[0]['status'] ==
                                  'Issue Reported') {
                                Fluttertoast.showToast(
                                    msg:
                                        'Issue Already Reported On This Order!');
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ReportIssueScreen(
                                              orderid: widget.orderid,
                                            )));
                              }
                            }, screenWidth, screenHeight * 0.05),
                          )
                        : SizedBox.shrink(),
                  ],
                );
              }

              return Padding(
                padding: EdgeInsets.only(top: 0),
                child: Center(child: Text('Loading...')),
              );
            },
          )),
    );
  }

  int dateTimeDifference() {
    print(DateTime.now()
        .difference(DateTime.parse(satatusList[satatusList.length - 1].date))
        .inHours);
    return DateTime.now()
        .difference(DateTime.parse(satatusList[satatusList.length - 1].date))
        .inHours;
  }
}
