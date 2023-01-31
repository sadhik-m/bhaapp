
import 'package:bhaapp/shop_search/view/shop_search_list_screen.dart';
import 'package:bhaapp/shop_search/view/widgets/shopTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/colors.dart';
import '../../dashboard/dash_board_screen.dart';
import '../../dashboard/widget/bottombar_icon.dart';
import '../../home/model/vendorShopModel.dart';
import '../../order/my_orders_screen.dart';
import '../../product/model/cartModel.dart';
import '../../profile/profile_screen.dart';

class ShopSearchScreen extends StatefulWidget {
  bool willPop;
   ShopSearchScreen({Key? key,required this.willPop}) : super(key: key);

  @override
  State<ShopSearchScreen> createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {

  final pages = [
    ShpSearchListScreen(),
    OrderScreen(show_back: false,),
    ProfileScreen(),

  ];
  int pageNumber=0;
  DateTime ? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if(widget.willPop){
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Press back again to exit');
        return Future.value(false);
      }
    }
    return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body:WillPopScope(
        onWillPop: onWillPop,
        child:pages[pageNumber]
      ),
        bottomNavigationBar: buildMyNavBar(context,screenHeight,screenWidth),
    );
  }


  Container buildMyNavBar(BuildContext context,double height,double width) {
    return Container(
      height: height*0.075,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        bottom: true,
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                enableFeedback: false,
                onPressed:(){
                  setState(() {
                    pageNumber = 0;
                  });
                },
                icon:  Image.asset(
                  'assets/home/search.png',
                  color:pageNumber == 0 ?  Colors.white:bottom_grey,
                  height: height*0.035,
                  width: height*0.035,
                )
            ),
            IconButton(
                enableFeedback: false,
                onPressed:(){
                  setState(() {
                    pageNumber = 1;
                  });
                },
                icon:  Image.asset(
                  'assets/dashboard/package.png',
                  color:pageNumber == 1 ?  Colors.white:bottom_grey,
                  height: height*0.035,
                  width: height*0.035,
                )
            ),
            IconButton(
                enableFeedback: false,
                onPressed:(){
                  setState(() {
                    pageNumber = 2;
                  });
                },
                icon:  Image.asset(
                  'assets/dashboard/user-check-2.png',
                  color:pageNumber == 2 ?  Colors.white:bottom_grey,
                  height: height*0.035,
                  width: height*0.035,
                )
            ),



          ],
        ),
      ),
    );
  }
}
