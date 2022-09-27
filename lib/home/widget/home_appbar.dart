import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/home/widget/locaton_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shop_search/view/shop_search_screen.dart';

Container homeAppBar(Function(dynamic)? location_onchanged,BuildContext context,VoidCallback ontap){
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:8.0),
                  child: Image.asset('assets/home/map-pin.png',
                    height: 18.3,
                    width: 15,),
                ),
                SizedBox(width: 7,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    locationDropDown(
                      location_onchanged,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 4, bottom: 4, left: 5),
                      decoration: BoxDecoration(
                          color: splashBlue.withOpacity(0.1)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopSearchScreen(willPop: false,)));
                            },
                            child: Text(vendorId!,
                              //'Change Shop Type /Vendor',
                              style:GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.black
                              ) ,),
                          ),
                          SizedBox(width: 4,),
                          Padding(
                            padding: const EdgeInsets.only(right:2.0),
                            child: Image.asset('assets/home/arrow-up-right-2.png',height: 16,width: 16,),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
            InkWell(
              onTap:ontap,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: Center(
                  child: Icon(Icons.person,color: Colors.white,),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14,),
        Container(
          height: 2,
          color: Colors.black.withOpacity(0.1),
        )
      ],
    ),
  );
}