import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

InkWell productTile(double height,double width,VoidCallback ontap,String image,
    String prodName,String salePrize,String reguarPrize,String quantity){
  return InkWell(
    onTap:ontap ,
    child: Container(
      height: height*0.26,
      width: width*0.435,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  border: Border.all(color: list_blue)
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ((double.parse(reguarPrize)-double.parse(salePrize))/double.parse(reguarPrize))*100 > 0 ?
                        Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: splashBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.all(Radius.circular(2))
                            ),
                            child: Text('${(((double.parse(reguarPrize)-double.parse(salePrize))/double.parse(reguarPrize))*100).toString().substring(0,4)}% OFF',
                            style: GoogleFonts.inter(
                              fontSize: 10,fontWeight: FontWeight.w700,color: splashBlue
                            ),)):Container(),
                        Image.asset('assets/home/Vector-3.png',
                        height: 17.5,)
                      ],
                    ),
                    Image.network(image,
                      height: height*0.12,),
                    SizedBox(height: height*0.065,),
                  ],
                ),

              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width*0.37,
                  height: height*0.09,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: width*0.37,
                          height: height*0.075,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Card(
                            elevation: 5,
                            margin: EdgeInsets.all(0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(6))
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: height*0.01,),
                                Text(prodName,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 9,
                                  color: Colors.black
                                ),
                                textAlign: TextAlign.center,),
                                SizedBox(height: height*0.0005,),
                                Text('\$${salePrize}/$quantity',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 11,
                                      color: Colors.black
                                  ),),
                              ],
                            ),

                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: width*0.065,
                            width: width*0.065,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: splashBlue
                            ),
                            child: Center(
                              child: Icon(Icons.add,
                              color: Colors.white,size: 14,),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}