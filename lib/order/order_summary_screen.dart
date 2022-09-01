import 'package:bhaapp/order/widget/order_summary_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/constants/colors.dart';
import '../common/widgets/appBar.dart';
import '../common/widgets/black_button.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({Key? key}) : super(key: key);

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

        child: Column(
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
                                  (){}
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
                            children: [
                              Text('Order ID:',style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black
                              ),),
                              Text('45678KHYTHRHJ',style: GoogleFonts.inter(
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
                              Text('**** **** **** 3602',style: GoogleFonts.inter(
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
                              Text('Aug 07 2022',style: GoogleFonts.inter(
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
                                child: Text('Jalan Haji Juanda No 1Paledang, Kecamatan Bogor Tengah, Kota Bogor,',style: GoogleFonts.inter(
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
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth*0.07,
                  vertical: screenHeight*0.01
              ),
              child: blackButton("Repeat Order", (){}, screenWidth, screenHeight*0.05),
            )

          ],
        ),
      ),
    );
  }
}
