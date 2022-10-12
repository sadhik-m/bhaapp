import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/home/widget/locaton_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shop_search/view/shop_search_screen.dart';
import '../service/profilePicService.dart';

Container homeAppBar(BuildContext context,double screenHeight,VoidCallback ontap){
  return Container(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Image.asset('assets/authentication/app_logo_old(1) 1-2.png',
              height: screenHeight*0.025,),
            FutureBuilder<String>(
              future: ProfPic().getProfPic(),
              builder:
                  (BuildContext context, AsyncSnapshot snapshot) {


                if (snapshot.hasData) {
                  return InkWell(
                    onTap:ontap,
                    child: snapshot.data.toString()!=''?
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                          image: DecorationImage(
                              image: NetworkImage(snapshot.data.toString()),fit: BoxFit.fill)
                      ),
                    ):
                    Container(
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
                  );
                }

                return Center(child:InkWell(
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
                ));
              },
            )

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