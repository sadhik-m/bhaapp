import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/order/service/getOrder.dart';
import 'package:bhaapp/order/widget/order_history_tile.dart';
import 'package:bhaapp/order/widget/order_tile.dart';
import 'package:bhaapp/order/widget/product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../cart/widget/cart_list_tile.dart';
import '../common/widgets/appBar.dart';
import '../dashboard/dash_board_screen.dart';

class OrderScreen extends StatefulWidget {
  bool? show_back;
  OrderScreen({ this.show_back});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String orderType='my_orders';

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("My Orders",
          [/*Padding(
            padding: const EdgeInsets.only(right:18.0),
            child: Row(
             children: [
               Image.asset('assets/home/Vector-4.png',
               height: 20,),
               SizedBox(width: 10,),
               Image.asset('assets/home/search.png',
               height: 24,color: Colors.black,),
             ],
            ),
          )*/],widget.show_back!),
      body: Container(
        height: screenHeight,
          width: screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth*0.07,
        ),
        child: Column(
          children: [
            SizedBox(height: screenHeight*0.03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){
                    setState(() {
                      orderType='my_orders';
                    });
                  },
                  child: Container(
                    height: screenHeight*0.055,
                    width: screenWidth*0.39,
                    decoration: BoxDecoration(
                        color: orderType=='my_orders'?splashBlue.withOpacity(0.2):Colors.white,
                        border: Border.all(
                            color: orderType=='my_orders'?splashBlue:Colors.black)
                    ),
                    child: Center(
                      child: Text('Ongoing Orders',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: orderType=='my_orders'?splashBlue:Colors.black
                        ),),
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    setState(() {
                      orderType='order_history';
                    });
                  },
                  child: Container(
                    height: screenHeight*0.055,
                    width: screenWidth*0.39,
                    decoration: BoxDecoration(
                        color: orderType=='order_history'?splashBlue.withOpacity(0.2):Colors.white,
                        border: Border.all(
                            color: orderType=='order_history'?splashBlue:Colors.black)
                    ),
                    child: Center(
                      child: Text('Order History',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: orderType=='order_history'?splashBlue:Colors.black
                        ),),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight*0.03,),
            Expanded(child:
            orderType=='my_orders'?
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').where('userId',isEqualTo: userId!)
                .where('status',whereIn: ['Order Placed', 'Accepted', 'In Progress', 'Ready For Pickup', 'Out For Delivery','At Pickup Point', 'Issue Reported', 'Refund Approved', 'Refund Initiated']).orderBy('txTime',descending: true).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return SizedBox.shrink();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding:  EdgeInsets.only(top: 0),
                    child: Center(child: Text('Nothing Found!')),
                  );
                }
                if (snapshot.data!.docs.isEmpty) {
                  return Padding(
                    padding:  EdgeInsets.only(top: 0),
                    child: Center(child: Text('Nothing Found!')),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return orderTile(screenWidth, screenHeight,
                        snapshot.data!.docs[index],context);
                  },
                );
              },
            ):
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('orders').where('userId',isEqualTo: userId!).
              where('status',whereIn: ['Delivered', 'Cancelled', 'Rejected', 'Refunded', 'Refund Denied']).orderBy('txTime',descending: true).snapshots(),
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
                return  ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom:14.0),
                      child: orderHistoryTile(screenWidth, screenHeight,
                          snapshot.data!.docs[index],context),
                    );
                  },
                );
              },
            )
           )
          ],
        ),
      ),
    );
  }

}
