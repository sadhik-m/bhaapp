import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

StreamBuilder productListTile(double width,double height,String sku,String quantity){
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('products').where('sku',isEqualTo: sku).snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return SizedBox.shrink();
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Padding(
          padding:  EdgeInsets.only(top: height*0.35),
          child: Center(child: Text('Loading...')),
        );
      }
      if (snapshot.data!.docs.isEmpty) {
        return Padding(
          padding:  EdgeInsets.only(top: height*0.35),
          child: Center(child: Text('Nothing Found!')),
        );
      }
      return Column(
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: width*0.07),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(snapshot.data!.docs[0]['productImageUrl'],
                  height: height*0.12,width: width*0.25),
                SizedBox(width: width*0.05,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: height*0.015,),
                      Text(snapshot.data!.docs[0]['productName'],style: GoogleFonts.inter(
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
                          Container(
                            width: width*0.2,
                            child: Text(snapshot.data!.docs[0]['sku'],style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(0.8)
                            ),overflow: TextOverflow.ellipsis,),)
                        ],
                      ),
                      SizedBox(height: height*0.004,),
                      Row(
                        children: [
                          Text('$quantity ${snapshot.data!.docs[0]['priceUnit']}',style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: splashBlue
                          ),),
                          Text(' - \$${double.parse(snapshot.data!.docs[0]['salesPrice'].toString())*int.parse(quantity)}',style: GoogleFonts.inter(
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
          ),
          Padding(
            padding:  EdgeInsets.only(bottom:4.0),
            child: Divider(color: Colors.black.withOpacity(0.2),),
          )
        ],
      );
    },
  ) ;
}