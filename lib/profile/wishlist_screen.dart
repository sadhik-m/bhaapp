import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:bhaapp/product/product_detail_screen.dart';
import 'package:bhaapp/profile/widget/wishlist_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product/model/cartModel.dart';

class WishListScreen extends StatefulWidget {

  const WishListScreen({Key? key}) : super(key: key);

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {

  List<String> favList=[];
  bool loaded=false;
  gatWishList()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      favList=preferences.getStringList('favList')??[];
      loaded=true;
    });
  }
  getCartList()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cartString = await prefs.getString('cartList')??'null';
    setState(() {
      if(cartString != 'null'){
        List<CartModel> cartList=CartModel.decode(cartString);
        DashBoardScreen.cartValueNotifier.updateNotifier(cartList.length);
        cartHomeList=CartModel.decode(cartString);
      }
    });
  }
  List<CartModel> cartHomeList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gatWishList();
    getCartList();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Wish List',
          [],true),
      body:loaded? Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(height: screenHeight*0.02,),
            Expanded(child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth*0.04,
                ),
                width: screenWidth,
                child:favList.isNotEmpty?
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.spaceBetween,
                  runSpacing: 20,
                  children: favList.map((data) {
                    return wishListTile(screenWidth,
                       screenHeight,
                        data,
                        ()async{
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          setState(() {
                            favList.remove(data);
                            preferences.setStringList('favList',favList );
                          });
                        },cartHomeList);

                  }).toList(),

                ):Padding(
                  padding:  EdgeInsets.only(top: screenHeight*0.35),
                  child: Center(child: Text('Nothing Found!')),
                ),
              ),
            ))
          ],
        ),
      ):Center(
        child: Text('Loading....'),
      ),
    );
  }
}
/**/