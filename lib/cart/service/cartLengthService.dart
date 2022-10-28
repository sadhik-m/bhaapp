import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../product/model/cartModel.dart';

/*Stream<int> getCartValue()async*{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String cartString = await prefs.getString('cartList')??'null';

    if(cartString != 'null'){
      List<CartModel> cartList=CartModel.decode(cartString);
      yield cartList.length;
    }else{
      yield 0;
    }
}*/
class CartValueNotifier{
  ValueNotifier<int> cartValueNotifier = ValueNotifier<int>(0);
  void updateNotifier(int val) {
    cartValueNotifier.value=val;
  }
}
class CartTotalNotifier{
  ValueNotifier<double> cartValueNotifier = ValueNotifier<double>(0);
  void updateNotifier(double val) {
    cartValueNotifier.value=val;
  }
}