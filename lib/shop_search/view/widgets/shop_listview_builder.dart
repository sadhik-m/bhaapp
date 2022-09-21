import 'package:bhaapp/shop_search/view/widgets/shop_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../dashboard/dash_board_screen.dart';
import '../../model/vendorModel.dart';
ListView ShopListView(double width,double height,BuildContext context,List<VendorModel> data){
  return ListView.builder(
    itemCount: data.length,
    padding: EdgeInsets.all(0),
    shrinkWrap: true,
    physics: AlwaysScrollableScrollPhysics(),
    itemBuilder: (context, index) {
      return Padding(
        padding:  EdgeInsets.only(
          bottom: height*0.015
        ),
        child: ShopListTile(
          data[index].shopName,
          data[index].address,
          width,
          height,
            (){
              saveVendorId(data[index].vendorId,context);
            }
        ),
      );
    },
  );

}
saveVendorId(String vendorId,BuildContext context)async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('vendorId', vendorId);
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
      (context)=>DashBoardScreen()), (route) => false);
}