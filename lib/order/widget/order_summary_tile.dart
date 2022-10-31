import 'package:bhaapp/order/widget/product_tile.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container orderSummaryTile(double width,double height,List<String>sku,List<String>quqntity,String shopname,String shopaddress,String total){
  return Container(
    decoration:BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
        )
    ),
    child: ExpandablePanel(

      header: Padding(
        padding: EdgeInsets.only(top: 21,left: 14,right: 10,bottom: 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(shopname,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff030303)
              ),),
            SizedBox(height: 8,),
            Text(shopaddress,
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
            itemCount: sku.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return productListTile(width,height,sku[index],quqntity[index]);
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
                    Text('Grand Total',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xff030303)
                      ),),
                    Text('₹$total',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Color(0xff030303)
                      ),)
                  ],
                ),
                InkWell(
                  onTap: (){},
                  child: Container(
                    height: 24,width: 122,
                    color: Color(0xff005DFF),
                    child: Center(
                      child: Text('DOWNLOAD INVOICE',
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
    ),
  );
}