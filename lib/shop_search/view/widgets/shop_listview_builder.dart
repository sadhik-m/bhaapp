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
              saveVendorId(data[index].vendorId,context,data[index].vendorDocId,data[index].razorpayId);
            }
        ),
      );
    },
  );

}
saveVendorId(String vendorIds,BuildContext context,String vendorDocId,String razorpayId)async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  vendorId=vendorIds;
  preferences.setString('vendorId', vendorIds);
  preferences.setString('razorpayId', razorpayId);
  preferences.setString('vendorDocId', vendorDocId);
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
      (context)=>DashBoardScreen()), (route) => false);
}