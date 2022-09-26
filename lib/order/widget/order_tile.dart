import 'package:bhaapp/order/widget/product_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'orderProductTile.dart';

Container orderTile(double width,double height,VoidCallback ontap,DocumentSnapshot snapshot){

  print("HHHHHHHHHHHHH   ${snapshot['items']as Map<String, dynamic>}");
  Map<String, dynamic> items=snapshot['items']as Map<String, dynamic>;
  List<String> skuList=[];
  List<String> quantityList=[];
  items.forEach((key, value) {
    skuList.add(key.toString());
    quantityList.add(value.toString());
  });
  DateTime date= DateTime.parse(snapshot['txTime'].toString());
  String convertedDateTime = "${date.year.toString()}-${date.month.toString().padLeft(2,'0')}-${date.day.toString().padLeft(2,'0')} ${date.hour.toString().padLeft(2,'0')}-${date.minute.toString().padLeft(2,'0')}";
  print("HHHHHHHHHHHHH   ${skuList[0]},,,${quantityList[0]}");

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
            padding:  EdgeInsets.only(top: height*0.35),
            child: Center(child: Text('Loading...')),
          );
        }
        if (snapshotShop.data!.docs.isEmpty) {
          return Padding(
            padding:  EdgeInsets.only(top: height*0.35),
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
                        Text(convertedDateTime,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Color(0xff030303)
                          ),),
                        Text('\$${snapshot['orderAmount']}',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Color(0xff030303)
                          ),)
                      ],
                    ),
                    InkWell(
                      onTap: ontap,
                      child: Container(
                        height: 24,width: 85,
                        color: Color(0xff005DFF),
                        child: Center(
                          child: Text('VIEW DETAILS',
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                            ),),
                        ),
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