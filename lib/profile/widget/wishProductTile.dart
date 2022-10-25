import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/colors.dart';
import '../../common/widgets/loading_indicator.dart';
import '../../dashboard/dash_board_screen.dart';
import '../../product/model/cartModel.dart';


class WishProductTile extends StatefulWidget {
  double height;
  double width;
  VoidCallback ontap;
  String image;
  String prodName;
  String salePrize;
  String reguarPrize;
  String quantity;
  String prodId;
  bool fav;
  VoidCallback onFavTap;
  List<CartModel>cartHomeList;
  WishProductTile({
    Key? key,
    required this.height,
    required this.width,
    required this.ontap,
    required this.image,
    required this.prodName,
    required this.salePrize,
    required this.reguarPrize,
    required this.quantity,
    required this.prodId,
    required this.fav,
    required this.onFavTap,required this.cartHomeList
  }) : super(key: key);

  @override
  _WishProductTileState createState() => _WishProductTileState();
}

class _WishProductTileState extends State<WishProductTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:widget.ontap ,
      child: Container(
        height: widget.height*0.26,
        width: widget.width*0.435,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      border: Border.all(color: list_blue)
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ((double.parse(widget.reguarPrize)-double.parse(widget.salePrize))/double.parse(widget.reguarPrize))*100 > 0 ?
                          Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: splashBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.all(Radius.circular(2))
                              ),
                              child: Text('${(((double.parse(widget.reguarPrize)-double.parse(widget.salePrize))/double.parse(widget.reguarPrize))*100).toString().substring(0,4)}% OFF',
                                style: GoogleFonts.inter(
                                    fontSize: 10,fontWeight: FontWeight.w700,color: splashBlue
                                ),)):Container(),
                          widget.fav?
                          InkWell(
                            onTap: widget.onFavTap,
                            child: Icon(Icons.favorite,
                              size: 20.5,color: red,
                            ),
                          ):
                          InkWell(
                            onTap:widget.onFavTap ,
                            child: Icon(Icons.favorite_outline_outlined,
                              size: 20.5,color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      Image.network(widget.image,
                        height: widget.height*0.12,),
                      SizedBox(height: widget.height*0.065,),
                    ],
                  ),

                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: widget.width*0.37,
                      height: widget.height*0.09,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: widget.width*0.37,
                                height: widget.height*0.075,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(6)),
                                ),
                                child: Card(
                                  elevation: 5,
                                  margin: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(6))
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(height: widget.height*0.01,),
                                      Text(widget.prodName,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 9,
                                            color: Colors.black
                                        ),
                                        textAlign: TextAlign.center,),
                                      SizedBox(height: widget.height*0.0005,),
                                      Text('\$${widget.salePrize}/${widget.quantity}',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 11,
                                            color: Colors.black
                                        ),),
                                    ],
                                  ),

                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: (){
                                    addToCart(widget.prodId,1,widget.cartHomeList);
                                  },
                                  child: Container(
                                    height: widget.width*0.065,
                                    width: widget.width*0.065,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: splashBlue
                                    ),
                                    child: Center(
                                      child: Icon(Icons.add,
                                        color: Colors.white,size: 14,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  addToCart(String prodId,int prodQuantity,List<CartModel>cartHomeList)async{
    //showLoadingIndicator(context);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData=CartModel.encode(cartHomeList);
    if(encodedData.contains(prodId)){
      int index = cartHomeList.indexWhere((element) => element.productId == prodId);
      if (index != -1) {
        setState(() {
          cartHomeList[index].productQuantity=cartHomeList[index].productQuantity+prodQuantity;
        });
        Fluttertoast.showToast(msg: 'item quantity in cart changed to ${cartHomeList[index].productQuantity+prodQuantity}');
      }
    }else{
      setState(() {
        cartHomeList.add(CartModel(productId: prodId, productQuantity: prodQuantity));
        Fluttertoast.showToast(msg: "item added to cart");
      });
    }
    setState(() {
      DashBoardScreen.cartValueNotifier.updateNotifier(cartHomeList.length);
    });
    prefs.setString('cartList',CartModel.encode(cartHomeList) ).then((value){

    });
  }
}




