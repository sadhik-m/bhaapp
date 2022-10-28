import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/colors.dart';
import '../../dashboard/dash_board_screen.dart';
import '../../product/model/cartModel.dart';
import '../my_cart_screen.dart';

FutureBuilder cartListTile(double width,double height,String prodId,int quantity,int index){
  CollectionReference prodDetail = FirebaseFirestore.instance.collection('products');
  int prodQua=quantity;
  return FutureBuilder<DocumentSnapshot>(
    future: prodDetail.doc(prodId).get(),
    builder:
        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

      if (snapshot.hasError) {
        return Text("Something went wrong");
      }


      if (snapshot.hasData) {
        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RotatedBox(
                  quarterTurns: 5,
                  child: Container(
                    child: Text('Item $index',style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: splashBlue,
                        fontSize: 12
                    ),),
                  ),
                ),
                SizedBox(width: width*0.05,),
                Image.network(data['productImageUrl'],
                  height: height*0.12,
                width: width*0.25,
                fit: BoxFit.fill,),
                SizedBox(width: width*0.05,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: height*0.015,),
                      Text(data['productName'],style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                      ),),
                   /*   SizedBox(height: height*0.004,),
                      Row(
                        children: [
                          Text('Product Code: ',style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.6)
                          ),),
                          Text(data['sku'],style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.8)
                          ),),
                        ],
                      ),*/
                      SizedBox(height: height*0.004,),
                      Row(
                        children: [
                          Text('$prodQua Kg',style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: splashBlue
                          ),),
                          Text(' - \$${quantity*double.parse(data['salesPrice'].toString())}',style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.8)
                          ),),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: (){

                            },
                            child: Center(
                              child: Text(
                                '-',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width*0.03,),
                          Center(
                            child: Text(
                              '${quantity.toString().padLeft(2,'0')}  ${data['priceUnit'].toString()}',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: Colors.black
                              ),
                            ),
                          ),
                          SizedBox(width: width*0.03,),
                          InkWell(
                            onTap: (){

                              prodQua+=1;

                            },
                            child: Center(
                              child: Text(
                                '+',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding:  EdgeInsets.only(bottom:8.0),
              child: Divider(color: Colors.black.withOpacity(0.2),),
            )
          ],
        );
      }

      return Center(child: Text(""));
    },
  );
}

class CartListTile extends StatefulWidget {
  double width;
  double height;
  String prodId;
  int quantity;
  int index;

   CartListTile({Key? key,
    required this.width,
    required this.height,
    required this.prodId,
    required this.quantity,
    required this.index,

  }) : super(key: key);

  @override
  _CartListTileState createState() => _CartListTileState();
}

class _CartListTileState extends State<CartListTile> {

  late Future<DocumentSnapshot> data;
  CollectionReference prodDetail = FirebaseFirestore.instance.collection('products');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data= prodDetail.doc(widget.prodId).get();
  }
  @override
  Widget build(BuildContext context) {
    return widget.quantity==0?SizedBox.shrink():
    FutureBuilder<DocumentSnapshot>(
      future: data,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }


        if (snapshot.hasData) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RotatedBox(
                    quarterTurns: 5,
                    child: Container(
                      child: Text('Item ${widget.index}',style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: splashBlue,
                          fontSize: 12
                      ),),
                    ),
                  ),
                  SizedBox(width: widget.width*0.05,),
                  Image.network(data['productImageUrl'],
                    height: widget.height*0.12,
                    width: widget.width*0.25,
                    fit: BoxFit.fill,),
                  SizedBox(width: widget.width*0.05,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(height: widget.height*0.015,),
                        Text(data['productName'],style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                        ),),
                        /*   SizedBox(height: height*0.004,),
                      Row(
                        children: [
                          Text('Product Code: ',style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.6)
                          ),),
                          Text(data['sku'],style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black.withOpacity(0.8)
                          ),),
                        ],
                      ),*/
                        SizedBox(height: widget.height*0.004,),
                        Row(
                          children: [
                            Text('${widget.quantity} Kg',style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: splashBlue
                            ),),
                            Text(' - \$${widget.quantity*double.parse(data['salesPrice'].toString())}',style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(0.8)
                            ),),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  widget.quantity-=1;
                                });
                                updateCart(widget.prodId, widget.quantity,'-');
                              },
                              child: Center(
                                child: Text(
                                  '-',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: widget.width*0.03,),
                            Center(
                              child: Text(
                                '${widget.quantity.toString().padLeft(2,'0')}  ${data['priceUnit'].toString()}',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(width: widget.width*0.03,),
                            InkWell(
                              onTap: (){

                                setState(() {
                                  widget.quantity+=1;
                                });
                                updateCart(widget.prodId, widget.quantity,'+');
                              },
                              child: Center(
                                child: Text(
                                  '+',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 22,
                                      color: Colors.black
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding:  EdgeInsets.only(bottom:8.0),
                child: Divider(color: Colors.black.withOpacity(0.2),),
              )
            ],
          );
        }

        return Center(child: Text(""));
      },
    );
  }

  updateCart(String prodId,int prodQuantity,String operation)async{
    double totalPrice=0;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //String encodedData=CartModel.encode(MyCart.cartList);

     int index = widget.index;
      if(prodQuantity==0){
        setState(() {
          MyCart.cartList.remove(MyCart.cartList[index]);
        });

        print("LLLLLLLL ${MyCart.cartList.length}");
      }else{

         if(operation=='+'){
           setState(() {
             setState(() {
               MyCart.cartList[index].productQuantity=MyCart.cartList[index].productQuantity+1;
             });
           });
         }else{
           setState(() {
             setState(() {
               MyCart.cartList[index].productQuantity=MyCart.cartList[index].productQuantity-1;
             });
           });
         }

      }

    setState(() {

      if(MyCart.cartList.isNotEmpty){
        MyCart.cartList.forEach((element) {
          setState(() {
            FirebaseFirestore.instance.collection('products').doc(element.productId).get().then((value) {
              setState(() {
                totalPrice += (double.parse(value['salesPrice'].toString())*element.productQuantity);
                DashBoardScreen.cartTotalNotifier.updateNotifier(totalPrice);
                //items.addAll({'${value['sku']}':element.productQuantity});
              });
            });
          });
        });

      }
      setState(() {

      });
      DashBoardScreen.cartValueNotifier.updateNotifier(MyCart.cartList.length);
    });
    prefs.setString('cartList',CartModel.encode(MyCart.cartList) ).then((value){

    });
  }
}
