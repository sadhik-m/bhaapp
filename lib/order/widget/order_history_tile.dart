import 'package:bhaapp/order/widget/product_tile.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Container orderHistoryTile(double width,double height,VoidCallback ontap){
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
            Text('Premier Supermarket',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff030303)
              ),),
            SizedBox(height: 8,),
            Text('Zakaria Bazar Junction, opposite Akshaya Centre, Alappuzha, Kerala 688012',
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
            itemCount: 2,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return productListTile(width,height);
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
                    Text('07 Aug 2022 at 6:25PM',
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xff030303)
                      ),),

                  ],
                ),
                InkWell(
                  onTap: ontap,
                  child: Row(
                    children: [
                      Text('\$110',
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
    ),
  );
}