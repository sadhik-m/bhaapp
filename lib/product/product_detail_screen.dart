import 'package:bhaapp/cart/my_cart_screen.dart';
import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/product/widget/benefit_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cart/service/cartLengthService.dart';
import 'model/cartModel.dart';

class ProductDetail extends StatefulWidget {
  String docId;
   ProductDetail({Key? key,required this.docId}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity=1;
   List<CartModel> cartList=[];
  CollectionReference prodDetail = FirebaseFirestore.instance.collection('products');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gatWishList();
    getCartList();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("Product Details",
          [Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:
                                      (context)=>MyCart(show_back: true,))).then((value) {
                                        setState(() {
                                          getCartList();
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
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth*0.06,
        ),
        child: FutureBuilder<DocumentSnapshot>(
            future: prodDetail.doc(widget.docId).get(),
            builder:
                (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.hasData) {
                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.network(data['productImageUrl'],
                          height: screenHeight*0.28),
                      SizedBox(height: screenHeight*0.01),
                      Text(data['productName'],
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 21
                        ),textAlign: TextAlign.center,),
                      SizedBox(height: screenHeight*0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('₹${data['salesPrice']}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                color: text_green,
                                fontSize: 20
                            ),textAlign: TextAlign.center,),
                          Text('/${data['priceUnit']}',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                color: text_green,
                                fontSize: 12
                            ),textAlign: TextAlign.center,),
                        ],
                      ),
                      SizedBox(height: screenHeight*0.01),
                      Text(data['productDescription'],
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.3),
                            fontSize: 12
                        ),textAlign: TextAlign.center,),
                    /*  SizedBox(height: screenHeight*0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RotatedBox(
                            quarterTurns: 5,
                            child: Container(
                              child: Text('Benefits',style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: splashBlue,
                                  fontSize: 12
                              ),),
                            ),
                          ),
                          SizedBox(width: screenWidth*0.05,),
                          Expanded(
                            child: ListView.builder(
                              itemCount: 4,
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return  benefitListTile(index+1);
                              },
                            ),
                          )
                        ],
                      ),*/
                      SizedBox(height: screenHeight*0.09),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         /* RotatedBox(
                            quarterTurns: 5,
                            child: Container(
                              child: Text('Quantity',style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: splashBlue,
                                  fontSize: 12
                              ),),
                            ),
                          ),
                          SizedBox(width: screenWidth*0.05,),*/
                          categoryType.toLowerCase().toString()=='services'?
                              SizedBox.shrink():
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  if(quantity!=1){
                                    setState(() {
                                      quantity-=1;
                                    });
                                  }
                                },
                                child: Container(
                                  height: screenWidth*0.11,
                                  width: screenWidth*0.11,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(4))
                                  ),
                                  child: Center(
                                    child: Text(
                                      '-',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth*0.03,),
                              Container(
                                height: screenWidth*0.11,
                                width: screenWidth*0.21,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(4))
                                ),
                                child: Center(
                                  child: Text(
                                    '${quantity.toString().padLeft(2,'0')}',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.black
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: screenWidth*0.03,),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    quantity+=1;
                                  });
                                },
                                child: Container(
                                  height: screenWidth*0.11,
                                  width: screenWidth*0.11,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(4))
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: screenWidth*0.08,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              toggleFavourites(widget.docId);
                            },
                            child: Container(
                              height: screenWidth*0.11,
                              width: screenWidth*0.09,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: Center(
                                child:favouriteList!.contains(widget.docId)?
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: screenWidth*0.055,
                                ):
                                Icon(
                                  Icons.favorite_border,
                                  color: Colors.black,
                                  size: screenWidth*0.055,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: screenWidth*0.03,),

                          InkWell(
                            onTap: (){
                              addToCart(snapshot.data!.id.toString(),quantity);
                              /*Navigator.push(context, MaterialPageRoute(builder:
                                  (context)=>MyCart(show_back: true,)));*/
                            },
                            child: Container(
                              height: screenWidth*0.11,
                              width: screenWidth*0.4,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Add to Cart ',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white
                                    ),
                                  ),
                                  Image.asset('assets/home/shopping-bag-2.png',
                                    color: Colors.white,
                                    height: screenWidth*0.04,)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: screenWidth*0.08,),
                    ],
                  ),
                );
              }

              return Center(child: Text("loading...."));
            },
          )
      ),
    );
  }

  getCartList()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cartString = await prefs.getString('cartList')??'null';
    setState(() {
      if(cartString != 'null'){
        cartList=CartModel.decode(cartString);
      }
    });
  }
  String categoryType='';
  gatWishList()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      favouriteList=preferences.getStringList('favList')??[];
      categoryType=preferences.getString('categoryType')??'';
    });
  }
  addToCart(String prodId,int prodQuantity)async{
    showLoadingIndicator(context);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData=CartModel.encode(cartList);
    if(encodedData.contains(prodId)){
      if(categoryType.toLowerCase().toString()=='services'){

      }else{
        int index = cartList.indexWhere((element) => element.productId == prodId);
        if (index != -1) {
          setState(() {
            cartList[index].productQuantity=cartList[index].productQuantity+prodQuantity;
          });
        }
      }

    }else{
      setState(() {
        cartList.add(CartModel(productId: prodId, productQuantity: prodQuantity));
      });
    }
    setState(() {
      DashBoardScreen.cartValueNotifier.updateNotifier(cartList.length);
    });
    prefs.setString('cartList',CartModel.encode(cartList) ).then((value){
      Navigator.of(context).pop();
      if(categoryType.toLowerCase().toString()=='services'){
        Fluttertoast.showToast(msg: 'service added to cart');
      }else{
        Fluttertoast.showToast(msg: 'item added to cart');
      }

    });
  }
  toggleFavourites(String productID)async{
    print("JKLOP");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> favList=preferences.getStringList('favList')??[];
 setState(() {
   if(favList.contains(productID)){
     favouriteList!.remove(productID);
     preferences.setStringList('favList',favouriteList! );
   }else{
     favouriteList!.add(productID);
     preferences.setStringList('favList',favouriteList! );
   }
 });


  }
}
