import 'package:bhaapp/order/order_detail_screen.dart';
import 'package:bhaapp/order/widget/product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'orderProductTile.dart';

StreamBuilder orderTile(double width,double height,DocumentSnapshot snapshot,BuildContext context){


  Map<String, dynamic> items=snapshot['items']as Map<String, dynamic>;
  List<String> skuList=[];
  List<String> quantityList=[];
  items.forEach((key, value) {
    skuList.add(key.toString());
    quantityList.add(value.toString());
  });
  DateTime date= DateTime.parse(snapshot['txTime'].toString());

  return  StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('vendors').where('vendorId',isEqualTo: snapshot['vendorId']).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotShop) {
      if (snapshotShop.hasError) {
        return SizedBox.shrink();
      }

      if (snapshotShop.connectionState == ConnectionState.waiting) {
        return Container();
      }
      if (snapshotShop.data!.docs.isEmpty) {
        return SizedBox.shrink();
      }
      return snapshot['status']=='Order Cancelled'?
      SizedBox.shrink(): Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(

          decoration:BoxDecoration(
              border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 2
              )
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Padding(
               padding: const EdgeInsets.only(left:8.0,right: 8,top: 8),
               child: Column(
                 children: [
                   Row(
                     children: [
                       Expanded(
                         child: Text("Shop Name : ",
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),),
                       ),
                       Expanded(
                         child: Text(snapshotShop.data!.docs[0]['shopName'],
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),overflow: TextOverflow.ellipsis,),
                       ),
                     ],
                   ),
                   SizedBox(height: 8,),
                   Row(
                     children: [
                       Expanded(
                         child: Text("Order ID : ",
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),),
                       ),
                       Expanded(
                         child: Text(snapshot['orderId'],
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),overflow: TextOverflow.ellipsis,),
                       ),
                     ],
                   ),
                   SizedBox(height: 8,),
                   Row(
                     children: [
                       Expanded(
                         child: Text("Order Date&Time : ",
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),),
                       ),
                       Expanded(
                         child: Text(DateFormat('d MMM y, hh:mm a').format(date),
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),overflow: TextOverflow.ellipsis,),
                       ),
                     ],
                   ),
                   SizedBox(height: 8,),
                   Row(
                     children: [
                       Expanded(
                         child: Text("Expected Delivery Date : ",
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),),
                       ),
                       Expanded(
                         child: Text(snapshot['deliveryTime'].toString(),
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),overflow: TextOverflow.ellipsis,),
                       ),
                     ],
                   ),
                   snapshot['status']=='Order Cancelled'?
                   SizedBox.shrink():
                   SizedBox(height: 8,),
                   snapshot['status']=='Order Cancelled'?
                       SizedBox.shrink():
                   Row(
                     children: [
                       Expanded(
                         child: Text("Status : ",
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),),
                       ),
                       Expanded(
                         child: Text(snapshot['status'],
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Colors.green
                           ),overflow: TextOverflow.ellipsis,),
                       ),
                     ],
                   ),
                   SizedBox(height: 8,),
                   Row(
                     children: [
                       Expanded(
                         child: Text("Order Value : ",
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),),
                       ),
                       Expanded(
                         child: Text('₹${snapshot['orderAmount']}',
                           style: GoogleFonts.inter(
                               fontWeight: FontWeight.w600,
                               fontSize: 12,
                               color: Color(0xff030303).withOpacity(0.7)
                           ),overflow: TextOverflow.ellipsis,),
                       ),
                     ],
                   ),
                 ],
               ),
             ),
              Divider(thickness: 2,),
              Padding(
                padding:  EdgeInsets.only(left:8.0,right: 8,bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    snapshot['status']=='Order Cancelled'?
                    Center(
                      child: Text('Order Cancelled',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.red
                        ),),
                    ):

                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetail(orderid: snapshot['orderId'],shopName:snapshotShop.data!.docs[0]['shopName'] , sku: skuList, quqntity: quantityList, shopContact: snapshotShop.data!.docs[0]['mobile'], orderStatus: snapshot['status'],
                          orderStatusDate: snapshot['txTime'],deliveryAddress: snapshot['deliveryAddress'],
                          deliveryTime: snapshot['deliveryTime'],orderTotal: snapshot['orderAmount'],
                        )));
                      },
                      child: Center(
                        child: Text('View Order Details',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green
                          ),),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}