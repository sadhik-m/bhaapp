import 'package:bhaapp/profile/widget/wishProductTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';
import '../../dashboard/dash_board_screen.dart';
import '../../home/widget/product_tile.dart';
import '../../product/model/cartModel.dart';
import '../../product/product_detail_screen.dart';

FutureBuilder wishListTile(double screenWidth,double screenHeight,String prodId,VoidCallback onFavTap,List<CartModel> cartlist){
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
        return WishProductTile(height: screenHeight,
            width: screenWidth,
            ontap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId: snapshot.data!.id.toString())));
            },
            image: data['productImageUrl'],
            prodName: data['productName'],
            salePrize: data['salesPrice'].toString(),
            reguarPrize: data['regularPrice'].toString(),
            quantity: data['priceUnit'],
            prodId: snapshot.data!.id.toString(),
            fav: favouriteList!.contains(snapshot.data!.id.toString()),
        onFavTap: onFavTap,cartHomeList: cartlist,);
      }

      return Center(child: Text(""));
    },
  );
}