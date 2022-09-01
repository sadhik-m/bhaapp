import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/order/widget/order_detail_product_tile.dart';
import 'package:bhaapp/order/widget/order_tracker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/widgets/appBar.dart';

class OrderDetail extends StatelessWidget {
  const OrderDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("Order Details",
          [Padding(
            padding: const EdgeInsets.only(right:18.0),
            child: Row(
              children: [

                Image.asset('assets/home/search.png',
                  height: 24,color: Colors.black,),
              ],
            ),
          )],true),
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
                      color: splashBlue.withOpacity(0.1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Order ID:',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black
                          ),) ,
                          Text(' 45678KHYTHRHJ',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: splashBlue
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
                          ListView.builder(
                            itemCount: 1,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return orderDetailProductListTile(screenWidth, screenHeight);
                            },
                          ),
                          Row(
                            children: [
                              Text('Tracking Details',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.8)
                              ),)
                            ],
                          ),
                          SizedBox(height: 10,),
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
                                 Text('22Aug 2022',style: GoogleFonts.inter(
                                     fontSize: 12,
                                     fontWeight: FontWeight.w600,
                                     color: Colors.black.withOpacity(0.8)
                                 ),),
                               ],
                             ),
                             Image.asset('assets/home/356674 1.png',
                             height: 25,width: 74,)
                           ],
                         ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                width: 56,
                                  height: 19.6,
                                color: Color(0xff28B446).withOpacity(0.2),
                                child: Center(
                                  child: Text('Call',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color: Color(0xff28B446)
                                  ),),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          OrderTracker()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
               padding: EdgeInsets.symmetric(
                 horizontal: screenWidth*0.07,
                 vertical: screenHeight*0.01
               ),
              child: blackButton("Cancel Order", (){}, screenWidth, screenHeight*0.05),
            )

          ],
        ),
      ),
    );
  }
}
