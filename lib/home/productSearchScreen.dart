
import 'package:bhaapp/home/model/productModel.dart';
import 'package:bhaapp/home/widget/productListView.dart';
import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:bhaapp/product/product_detail_screen.dart';
import 'package:bhaapp/shop_search/model/vendorModel.dart';

import 'package:bhaapp/shop_search/view/widgets/shop_listview_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/colors.dart';
import '../dashboard/dash_board_screen.dart';
import '../product/model/cartModel.dart';

class ProductSearchScreen extends StatefulWidget {
String label;
  ProductSearchScreen({Key? key,required this.label}) : super(key: key);

  @override
  State<ProductSearchScreen> createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  List<ProductModel> searchList=[];
  List<ProductModel> initialList=[];
  bool loaded=false;
  getInitialList()async{
    await FirebaseFirestore.instance
        .collection('products').where('seller.${'vid'}',isEqualTo: vendorId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
           initialList.add(
               ProductModel(
                   prodDocId: doc.id.toString(),
                   image:  doc['productImageUrl'],
                   name: doc['productName'],
                   salePrice: doc['salesPrice'].toString(),
                   regularPrice: doc['regularPrice'].toString(),
                   priceUnit: doc['priceUnit'],
               subCategory: doc['subCategory'],
                 availableInStock: doc['availableInStock'],
               ));

        });
      });
    });
    setState(() {
      loaded=true;
    });
  }
  List<CartModel> cartHomeList=[];
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
getInitialList();
getCartList();
  }

  void searchOperation(String searchText) {
    setState(() {
      searchList.clear();

      for (int i = 0; i < initialList.length; i++) {
        if (searchText.isNotEmpty && initialList[i].name.toLowerCase().contains(searchText.toLowerCase())) {
          searchList.add(initialList[i]);
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          centerTitle: true,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Container(
            height: screenHeight*0.07,
            width: screenWidth,
            padding: EdgeInsets.only(
                top: screenHeight*0.01
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: screenWidth,
                  height: screenHeight*0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: border_grey.withOpacity(0.1)),
                      color: fill_grey.withOpacity(0.1)
                  ),
                  child: TextField(
                    autofocus: true,
                    onChanged: searchOperation,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top:screenHeight*0.015),
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/home/search.png',
                            height: screenHeight*0.03,
                          ),
                        ],
                      ),
                      hintText: 'Search ${widget.label}',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.5)
                      ),
                    ),
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                    ),
                  ),
                ),

              ],
            ),
          ),

        ),
        body:Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth*0.04,
              vertical: screenHeight*0.04
          ),
          child: Column(
            children: [
              searchList.length==0?
              Center(
                child: Text('Nothing Found!'),
              ):
              Expanded(child: prodList(
                screenWidth,
                screenHeight,
                searchList,
                context,
                cartHomeList
              ))
            ],
          ),
        )

    );
  }

}
