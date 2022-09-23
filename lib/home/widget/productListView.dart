import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../product/product_detail_screen.dart';
import '../model/productModel.dart';

SingleChildScrollView prodList(double screenWidth,double screenHeight, List<ProductModel> searchList,BuildContext context){
  return SingleChildScrollView(
    child: Container(
      width: screenWidth,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.spaceBetween,
        runSpacing: 20,
        children: searchList.map((data) {
          return
            productTile(screenHeight,screenWidth,
                  (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId: data.prodDocId.toString())));
              },
              data.image,
              data.name,
              data.salePrice.toString(),
              data.regularPrice.toString(),
              data.priceUnit,


            );
        }).toList(),

      ),
    ),
  );
}