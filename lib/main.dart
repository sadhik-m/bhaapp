import 'package:bhaapp/address/add_new_address_screen.dart';
import 'package:bhaapp/address/change_address_screen.dart';
import 'package:bhaapp/cart/my_cart_screen.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/home/home_screen.dart';
import 'package:bhaapp/login/view/login_screen.dart';
import 'package:bhaapp/order/my_orders_screen.dart';
import 'package:bhaapp/order/order_detail_screen.dart';
import 'package:bhaapp/order/order_summary_screen.dart';
import 'package:bhaapp/otp/view/otp_screen.dart';
import 'package:bhaapp/payment/change_payment_screen.dart';
import 'package:bhaapp/product/product_detail_screen.dart';
import 'package:bhaapp/profile/profile_screen.dart';
import 'package:bhaapp/register/view/register_screen.dart';
import 'package:bhaapp/shop_search/view/shop_result_screen.dart';
import 'package:bhaapp/shop_search/view/shop_search_screen.dart';
import 'package:bhaapp/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';

import 'category/category_detail_screen.dart';
import 'category/category_list_screen.dart';
import 'payment/payment_success_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/splash':(BuildContext context) => const SplashScreen(),
        '/login':(BuildContext context) => const LoginScreen(),
        '/register':(BuildContext context) => const RegisterScreen(),
        '/otp':(BuildContext context) =>  OtpScreen(verificationId: '',),
        //'/shop_search':(BuildContext context) => const ShopSearchScreen(),
        '/shop_result':(BuildContext context) =>  ShopResult(vendorList: [],),
        '/dash':(BuildContext context) => const DashBoardScreen(),
        '/home':(BuildContext context) => const HomeScreen(),
        '/category_list':(BuildContext context) => const CategoryList(),
        '/category_detail':(BuildContext context) =>  CategoryDetail(title: '',),
        '/product_detail':(BuildContext context) =>  ProductDetail(docId: '',),
        '/cart':(BuildContext context) =>  MyCart(),
        '/payment_success':(BuildContext context) => const PaymentSuccess(),
        '/Add_address':(BuildContext context) => const AddAddress(),
        '/change_address':(BuildContext context) => const ChangeAddress(),
        '/change_payment':(BuildContext context) => const ChangePayment(),
        '/profile':(BuildContext context) => const ProfileScreen(),
        '/order':(BuildContext context) =>  OrderScreen(),
        //'/order_detail':(BuildContext context) => const OrderDetail(),
        //'/order_summary':(BuildContext context) => const OrderSummary(),
      },
    );
  }
}


