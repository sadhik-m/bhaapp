import 'package:bhaapp/shop_search/view/widgets/shop_list_tile.dart';
import 'package:flutter/material.dart';
ListView ShopListView(double width,double height,VoidCallback ontap){
  return ListView.builder(
    itemCount: 10,
    padding: EdgeInsets.all(0),
    shrinkWrap: true,
    physics: AlwaysScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return Padding(
        padding:  EdgeInsets.only(
          bottom: height*0.015
        ),
        child: ShopListTile(
          'Premier Supermarket',
          'Zakaria Bazar Junction, opposite Akshaya Centre, Alappuzha, Kerala 688012',
          width,
          height,
          ontap
        ),
      );
    },
  );
}