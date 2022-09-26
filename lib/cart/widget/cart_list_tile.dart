import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

FutureBuilder cartListTile(double width,double height,String prodId,int quantity,int index){
  CollectionReference prodDetail = FirebaseFirestore.instance.collection('products');
  return FutureBuilder<DocumentSnapshot>(
    future: prodDetail.doc(prodId).get(),
    builder:
        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

      if (snapshot.hasError) {
        return Text("Something went wrong");
      }


      if (snapshot.hasData) {
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RotatedBox(
                  quarterTurns: 5,
                  child: Container(
                    child: Text('Item $index',style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: splashBlue,
                        fontSize: 12
                    ),),
                  ),
                ),
                SizedBox(width: width*0.05,),
                Image.network(data['productImageUrl'],
                  height: height*0.12,
                width: width*0.25,
                fit: BoxFit.fill,),
                SizedBox(width: width*0.05,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: height*0.015,),
                      Text(data['productName'],style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),),
                      SizedBox(height: height*0.004,),
                      Row(
                        children: [
                          Text('Product Code: ',style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.6)
                          ),),
                          Text(data['sku'],style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.8)
                          ),),
                        ],
                      ),
                      SizedBox(height: height*0.004,),
                      Row(
                        children: [
                          Text('$quantity Kg',style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: splashBlue
                          ),),
                          Text(' - \$${quantity*double.parse(data['salesPrice'].toString())}',style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.8)
                          ),),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding:  EdgeInsets.only(bottom:8.0),
              child: Divider(color: Colors.black.withOpacity(0.2),),
            )
          ],
        );
      }

      return Center(child: Text(""));
    },
  );
}