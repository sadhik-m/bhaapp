import 'package:bhaapp/order/widget/order_summary_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../common/constants/colors.dart';
import '../common/widgets/appBar.dart';
import '../common/widgets/black_button.dart';

class OrderSummary extends StatelessWidget {
  String orderid;
  List<String>sku=[];
  List<String>quqntity=[];
  String shopContact;
  String shopName;
  String shopAddress;
  String orderStatus;
  String orderStatusDate;
  OrderSummary({Key? key,required this.orderid,required this.sku,required this.quqntity,required this.shopContact,required this.orderStatus,required this.orderStatusDate,
  required this.shopName,required this.shopAddress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("Order Details",
          [],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,

        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').where('orderId',isEqualTo: orderid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return SizedBox.shrink();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding:  EdgeInsets.only(top: 0),
                child: Center(child: Text('Loading...')),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Padding(
                padding:  EdgeInsets.only(top: 0),
                child: Center(child: Text('Nothing Found!')),
              );
            }
            return  Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth,
                          height: screenHeight*0.065,
                          color: Color(0xff28B446).withOpacity(0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/home/Group 78.png',
                                color: Color(0xff28B446),
                                height: 13.5,width: 24,) ,
                              Text('  The Order was delivered',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Color(0xff28B446)
                                ),)
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight*0.03,),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth*0.07,

                          ),
                          child: Column(
                            children: [
                              orderSummaryTile(
                                  screenWidth,
                                  screenHeight,
                                  sku,
                                  quqntity,
                                  shopName,
                                  shopAddress,
                                  snapshot.data!.docs[0]['orderAmount']

                              ),
                              SizedBox(height: screenHeight*0.03,),
                              Row(
                                children: [
                                  Text('Order Details',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black.withOpacity(0.8)
                                    ),)
                                ],
                              ),
                              SizedBox(height: 16,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Order ID:',style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                  ),),
                                  Text(snapshot.data!.docs[0]['orderId'],style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: splashBlue
                                  ),),

                                ],
                              ),
                              SizedBox(height: 16,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Payment',style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                  ),),
                                  Text(snapshot.data!.docs[0]['paymentMode'],style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                  ),),

                                ],
                              ),
                              SizedBox(height: 16,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Date',style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                  ),),
                                  Text(DateFormat('d MMM y, hh:mm a').format(DateTime.parse(snapshot.data!.docs[0]['txTime'])),style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black
                                  ),),

                                ],
                              ),
                              SizedBox(height: 16,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Delivery Address',style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black
                                  ),),
                                  Container(
                                    width: screenWidth*0.4,
                                    child: Text(snapshot.data!.docs[0]['deliveryAddress'],style: GoogleFonts.inter(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black.withOpacity(0.6)
                                    ),textAlign: TextAlign.right,),
                                  ),

                                ],
                              ),
                              SizedBox(height: 10,),

                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                ),
                /*Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth*0.07,
                      vertical: screenHeight*0.01
                  ),
                  child: blackButton("Repeat Order", (){}, screenWidth, screenHeight*0.05),
                )*/

              ],
            );
          },
        )

      ),
    );
  }
}
