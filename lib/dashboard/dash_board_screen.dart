import 'package:bhaapp/cart/my_cart_screen.dart';
import 'package:bhaapp/dashboard/widget/bottombar_icon.dart';
import 'package:bhaapp/home/home_screen.dart';
import 'package:bhaapp/order/my_orders_screen.dart';
import 'package:bhaapp/profile/profile_screen.dart';
import 'package:bhaapp/shop_search/view/shop_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cart/service/cartLengthService.dart';
import '../common/constants/colors.dart';
import '../product/model/cartModel.dart';

String ? vendorId;
String ? userId;
List<String> ? favouriteList;
int pageIndex = 0;
class DashBoardScreen extends StatefulWidget {
static CartValueNotifier cartValueNotifier = CartValueNotifier();
const DashBoardScreen({Key? key}) : super(key: key);

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final pages = [
   const HomeScreen(),
    OrderScreen(show_back: false,),
    ProfileScreen(),
    MyCart(show_back: false,),
  ];
  DateTime ? currentBackPressTime;
  Future<bool> onWillPop() {
    /*DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: 'Press back again to exit');
      return Future.value(false);
    }
    return Future.value(true);*/
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
        (context)=>ShopSearchScreen(willPop: true,)), (route) => false);
    return Future.value(true);
  }
  getCartList()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cartString = await prefs.getString('cartList')??'null';
    setState(() {
      if(cartString != 'null'){
        List<CartModel> cartList=CartModel.decode(cartString);
        DashBoardScreen.cartValueNotifier.updateNotifier(cartList.length);
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkVendorId();
    getCartList();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
     appBar: PreferredSize(
       preferredSize: Size.fromHeight(0),
       child: AppBar(
         elevation: 0,
         backgroundColor: Colors.transparent,
         systemOverlayStyle: SystemUiOverlayStyle.dark,
       ),
     ),
      backgroundColor: Colors.white,
      body: WillPopScope(
          onWillPop: onWillPop,
          child: pages[pageIndex]),
      bottomNavigationBar: buildMyNavBar(context,screenHeight,screenWidth),
    );
  }
  Container buildMyNavBar(BuildContext context,double height,double width) {
    return Container(
      height: height*0.065,
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
            BottomIcon(
                    (){
                      setState(() {
                        pageIndex = 0;
                      });
                      }
                    ,0, 'home'),
            BottomIcon(
                    (){
                  setState(() {
                    pageIndex = 1;
                  });
                }
                ,1, 'package'),
            BottomIcon(
                    (){
                  setState(() {
                    pageIndex = 2;
                  });
                }
                ,2, 'user-check-2'),
            BottomIcon(
                    (){
                  setState(() {
                    pageIndex = 3;
                  });
                }
                ,3, 'shopping-bag'),

          ],
        ),
      ),
    );
  }
  checkVendorId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      vendorId = preferences.getString('vendorId')??'null';
      userId = preferences.getString('uid')??'null';
      favouriteList=preferences.getStringList('favList')??[];
    });
    if(vendorId=='null'){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
          (context)=>ShopSearchScreen(willPop: true,)), (route) => false);
    }
  }
}
