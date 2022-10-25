import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:bhaapp/product/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cart/my_cart_screen.dart';
import '../product/model/cartModel.dart';

class NewProducts extends StatefulWidget {
 String catName;
  NewProducts({Key? key,required this.catName}) : super(key: key);

  @override
  State<NewProducts> createState() => _NewProductsState();
}

class _NewProductsState extends State<NewProducts> {
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
    getCartList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('products').where('seller.${'vid'}',isEqualTo: vendorId).snapshots();
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(widget.catName==''?'Products':widget.catName,
          [Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context)=>MyCart(show_back: true,))).then((value) {
                    setState(() {
                      //getCartList();
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right:18.0),
                  child: Image.asset('assets/home/shopping-bag-2.png',color: Colors.black,
                    height: 24,width: 24,),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: DashBoardScreen.cartValueNotifier.cartValueNotifier,
                builder: (context, value, child) {
                  return Positioned(
                    top: 8,
                    //bottom: 0,
                    right: 8,
                    child:value.toString()!='0'?
                    Container(
                      height: 14,width: 14,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: splashBlue
                      ),
                      child: Center(
                        child: Text(
                          value.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 8
                          ),
                        ),
                      ),
                    ):Container(),
                  );
                },
              )
            ],
          )],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(height: screenHeight*0.02,),
            Expanded(child: SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.catName==''?FirebaseFirestore.instance.collection('products').where('seller.${'vid'}',isEqualTo: vendorId).snapshots():
                FirebaseFirestore.instance.collection('products').where('seller.${'vid'}',isEqualTo: vendorId).where('subCategory',isEqualTo: widget.catName).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return SizedBox.shrink();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding:  EdgeInsets.only(top: screenHeight*0.35),
                      child: Text("Loading...."),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding:  EdgeInsets.only(top: screenHeight*0.35),
                      child: Text('Nothing Found!'),
                    );
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth*0.04,
                    ),
                    width: screenWidth,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.spaceBetween,
                      runSpacing: 20,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return ProductTile(height: screenHeight,
                            width: screenWidth,
                            ontap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId: document.id.toString())));
                            },
                            image: data['productImageUrl'],
                            prodName: data['productName'],
                            salePrize: data['salesPrice'].toString(),
                            reguarPrize: data['regularPrice'].toString(),
                            quantity: data['priceUnit'],
                            prodId: document.id.toString(),
                            fav: favouriteList!.contains(document.id.toString()),
                          cartHomeList: cartHomeList,);
                      }).toList(),

                    ),
                  );


                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
