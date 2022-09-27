import 'package:bhaapp/order/widget/product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../order_summary_screen.dart';
import 'orderProductTile.dart';

Container orderHistoryTile(double width,double height,DocumentSnapshot snapshot,BuildContext context){
  Map<String, dynamic> items=snapshot['items']as Map<String, dynamic>;
  List<String> skuList=[];
  List<String> quantityList=[];
  items.forEach((key, value) {
    skuList.add(key.toString());
    quantityList.add(value.toString());
  });
  DateTime date= DateTime.parse(snapshot['txTime'].toString());
  return Container(
    decoration:BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
        )
    ),
    child:StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('vendors').where('vendorId',isEqualTo: snapshot['vendorId']).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshotShop) {
        if (snapshotShop.hasError) {
          return SizedBox.shrink();
        }

        if (snapshotShop.connectionState == ConnectionState.waiting) {
          return Padding(
            padding:  EdgeInsets.only(top: 0),
            child: Center(child: Text('Loading...')),
          );
        }
        if (snapshotShop.data!.docs.isEmpty) {
          return Padding(
            padding:  EdgeInsets.only(top: 0),
            child: Center(child: Text('Nothing Found!')),
          );
        }
        return  ExpandablePanel(
          header: Padding(
            padding: EdgeInsets.only(top: 21,left: 14,right: 10,bottom: 11),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshotShop.data!.docs[0]['shopName'],
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Color(0xff030303)
                  ),),
                SizedBox(height: 8,),
                Text(snapshotShop.data!.docs[0]['address'],
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Color(0xff030303)
                  ),),
              ],
            ),
          ),
          collapsed: SizedBox.shrink(),
          expanded: Column(
            children: [
              SizedBox(height: height*0.01,),
              ListView.builder(
                itemCount: skuList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return orderProductTile(width,height,skuList[index],int.parse(quantityList[index]));
                },
              ),
              Padding(
                padding:  EdgeInsets.only(left:8.0,right: 8,bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(DateFormat('d MMM y, hh:mm a').format(date),
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xff030303)
                          ),),

                      ],
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderSummary(orderid: snapshot['orderId'], sku: skuList, quqntity: quantityList, shopContact: snapshotShop.data!.docs[0]['mobile'], orderStatus: snapshot['status'],orderStatusDate: snapshot['txTime'],shopName: snapshotShop.data!.docs[0]['shopName'],shopAddress: snapshotShop.data!.docs[0]['address'],)));

                      },
                      child: Row(
                        children: [
                          Text('\$${snapshot['orderAmount']}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: Color(0xff030303)
                            ),),
                          SizedBox(width: 8,),
                          Icon(Icons.arrow_forward_ios,color: Colors.black,size: 14,)
                        ],
                      ),
                    )
                  ],
                ),
              )

            ],
          ),
          theme: ExpandableThemeData(
              iconColor: Colors.black,
              iconPadding: EdgeInsets.only(left: 20,top: 20,right: 10)),
        );
      },
    )
  );
}