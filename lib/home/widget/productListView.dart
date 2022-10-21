import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dashboard/dash_board_screen.dart';
import '../../product/model/cartModel.dart';
import '../../product/product_detail_screen.dart';
import '../model/productModel.dart';

SingleChildScrollView prodList(double screenWidth,double screenHeight, List<ProductModel> searchList,BuildContext context,List<CartModel> cartlist){
  return SingleChildScrollView(
    child: Container(
      width: screenWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.spaceBetween,
        runSpacing: 20,
        children: searchList.map((data) {
          return ProductTile(height: screenHeight,
              width: screenWidth,
              ontap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId:data.prodDocId.toString())));
              },
              image: data.image,
              prodName: data.name,
              salePrize: data.salePrice.toString(),
              reguarPrize: data.regularPrice.toString(),
              quantity: data.priceUnit,
              prodId: data.prodDocId.toString(),
              fav: favouriteList!.contains(data.prodDocId.toString()),
            cartHomeList: cartlist,);
        }).toList(),

      ),
    ),
  );
}