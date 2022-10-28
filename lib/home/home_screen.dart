import 'package:bhaapp/category/mainCategoryScreen.dart';
import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/home/model/productModel.dart';
import 'package:bhaapp/home/productSearchScreen.dart';
import 'package:bhaapp/home/widget/category_list.dart';
import 'package:bhaapp/home/widget/home_appbar.dart';
import 'package:bhaapp/home/widget/locaton_dropdown.dart';
import 'package:bhaapp/home/widget/main_banner.dart';
import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:bhaapp/home/widget/search_field.dart';
import 'package:bhaapp/home/widget/small_banner.dart';
import 'package:bhaapp/product/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cart/service/cartLengthService.dart';
import '../common/widgets/loading_indicator.dart';
import '../dashboard/dash_board_screen.dart';
import '../product/model/cartModel.dart';
import 'model/ratingModel.dart';
import 'newProductsViewAll.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Stream<QuerySnapshot> _categoryStream = FirebaseFirestore.instance.collection('categories').snapshots();
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('products').where('seller.${'vid'}',isEqualTo: vendorId).limit(10).snapshots();
  List<CartModel> cartHomeList=[];

  List<ProductModel> initialList=[];
  List<String> categorisHome=[];
  bool loaded=false;
  getInitialList()async{
    setState(() {
      initialList.clear();
      categorisHome.clear();
    });
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
                  subCategory:doc['subCategory']));
          if(categorisHome.contains(doc["subCategory"])){

          }else{
            categorisHome.add(doc["subCategory"]);
          }

        });
      });
    });
    setState(() {
      loaded=true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitialList();
    gatWishList();
    getCartList();
  }
  gatWishList()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      favouriteList=preferences.getStringList('favList')??[];
    });
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    getCartList();
    return Scaffold(

      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.04,
        ),
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            SizedBox(height: screenHeight*0.02,),
            homeAppBar(
                context,
              screenHeight,
                (){
                  setState(() {
                    pageIndex=2;
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
                        (context)=>DashBoardScreen()), (route) => false);
                  });
                }
            ),
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: screenHeight*0.02,),
                      mainBanner(),

                      SizedBox(height: screenHeight*0.024,),
                      smallBanner(),
                      SizedBox(height: screenHeight*0.02,),
                      searchField(screenHeight, screenWidth,(){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductSearchScreen())).then((value) {
                          getCartList();
                        });
                      }),
                     /* SizedBox(height: screenHeight*0.02,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Shop by Category',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black
                            ),),
                          InkWell(
                            onTap: (){
                              Navigator.pushNamed(context, '/category_list').then((value) {
                                getCartList();
                              });
                            },
                            child: Text('View All',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                  color: splashBlue
                              ),),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight*0.02,),
                      StreamBuilder<QuerySnapshot>(
                        stream: _categoryStream,
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return SizedBox.shrink();
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox.shrink();
                          }
                          return Container(
                            height: screenHeight*0.07,
                            alignment: Alignment.centerLeft,
                            child: ListView(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                return categoryList((){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MainCategory(title:data['catName'] ,))).then((value) {
                                    getCartList();
                                  });
                                  },
                                    data['catName']);
                              }).toList(),
                            ),
                          );
                        },
                      ),*/
                      loaded==false?
                      Padding(
                        padding:  EdgeInsets.only(top: screenHeight*0.35),
                        child: Text("Loading...."),
                      ):
                      initialList.isEmpty?
                      Padding(
                        padding:  EdgeInsets.only(top: screenHeight*0.35),
                        child: Text('Nothing Found!'),
                      ):
                      Column(
                        children: [
                          SizedBox(height: screenHeight*0.024,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Products',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19,
                                    color: Colors.black
                                ),),
                            ],
                          ),
                          //SizedBox(height: screenHeight*0.024,),
                        ],
                      ),
                      categorisHome.isEmpty?SizedBox.shrink():
                      ListView.builder(
                        shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: categorisHome.length,
                          itemBuilder: (context,i){
                           return Column(children: [
                             SizedBox(height: screenHeight*0.024,),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: [
                                 Text(categorisHome[i],
                                   style: GoogleFonts.inter(
                                       fontWeight: FontWeight.w600,
                                       fontSize: 16,
                                       color: Colors.black
                                   ),),
                                 InkWell(
                                   onTap: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context)=>NewProducts(catName: categorisHome[i],))).then((value) {
                                       getCartList();
                                     });
                                   },
                                   child: Text('View All',
                                     style: GoogleFonts.inter(
                                         fontWeight: FontWeight.w400,
                                         fontSize: 10,
                                         color: splashBlue
                                     ),),
                                 )
                               ],
                             ),
                             SizedBox(height: screenHeight*0.024,),
                             SizedBox(
                               width: screenWidth,
                               height:screenHeight*0.26,
                               child: Row(
                                 children: [
                                   Expanded(
                                     child: ListView.builder(
                                         scrollDirection: Axis.horizontal,
                                         physics: AlwaysScrollableScrollPhysics(),
                                         itemCount: initialList.length,
                                         itemBuilder: (context,ind){
                                       return
                                         initialList[ind].subCategory==categorisHome[i]?
                                         Padding(
                                           padding: const EdgeInsets.only(right:14.0),
                                           child: ProductTile(height:screenHeight,width:screenWidth,
                                             ontap: (){
                                               Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId: initialList[ind].prodDocId.toString())))..then((value) {
                                                 getCartList();
                                               });
                                             },
                                             image:initialList[ind].image,
                                             prodName:initialList[ind].name,
                                             salePrize:initialList[ind].salePrice.toString(),
                                             reguarPrize:initialList[ind].regularPrice.toString(),
                                             quantity:initialList[ind].priceUnit,
                                             prodId:initialList[ind].prodDocId.toString(),
                                             fav:favouriteList!.contains(initialList[ind].prodDocId.toString()),
                                             cartHomeList:cartHomeList
                                       ),
                                         ):SizedBox.shrink();
                                     }),
                                   ),
                                 ],
                               ),
                             )
                           ],);
                      }),


                     /* SizedBox(
                        width: screenWidth,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.spaceBetween,

                          children: List.generate(2, (index) => productTile(screenHeight,screenWidth,(){Navigator.pushNamed(context, '/product_detail');})),
                        ),
                      )*/

                     /* Column(
                        children: [

                          SizedBox(

                            width: screenWidth,
                            child: Wrap(
                              alignment: WrapAlignment.spaceBetween,
                              runAlignment: WrapAlignment.spaceBetween,
                              runSpacing: 20,
                              children: initialList.map((ProductModel document) {
                                //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                return
                                  ProductTile(height:screenHeight,width:screenWidth,
                                      ontap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId: document.prodDocId.toString())))..then((value) {
                                          getCartList();
                                        });
                                      },
                                      image:document.image,
                                      prodName:document.name,
                                      salePrize:document.salePrice.toString(),
                                      reguarPrize:document.regularPrice.toString(),
                                      quantity:document.priceUnit,
                                      prodId:document.prodDocId.toString(),
                                      fav:favouriteList!.contains(document.prodDocId.toString()),
                                      cartHomeList:cartHomeList
                                  );
                              }).toList(),

                            ),
                          ),
                        ],
                      ),*/
                  /*StreamBuilder<QuerySnapshot>(
                    stream: _productStream,
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
                      return SizedBox(

                        width: screenWidth,
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runAlignment: WrapAlignment.spaceBetween,
                          runSpacing: 20,
                          children: snapshot.data!.docs.map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                            return
                              ProductTile(height:screenHeight,width:screenWidth,
                                   ontap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId: document.id.toString())))..then((value) {
                                    getCartList();
                                  });
                                },
                                image:data['productImageUrl'],
                                prodName:data['productName'],
                                salePrize:data['salesPrice'].toString(),
                                reguarPrize:data['regularPrice'].toString(),
                                quantity:data['priceUnit'],
                                  prodId:document.id.toString(),
                                  fav:favouriteList!.contains(document.id.toString()),
                                  cartHomeList:cartHomeList
                              );
                          }).toList(),

                        ),
                      );


                    },
                  ),*/
              ],
            ),
                ))
          ],
        ),
      ),
    );
  }
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

}
