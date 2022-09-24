import 'package:bhaapp/cart/widget/cart_list_tile.dart';
import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/product/widget/benefit_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../product/model/cartModel.dart';

class MyCart extends StatefulWidget {
  bool? show_back;
   MyCart({ this.show_back});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
   bool isGst=false;
   bool showOption=true;
   String? delivery;
   bool loaded=false;


   List<CartModel> cartList=[];

   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     getCartList();
   }
   getCartList()async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final String cartString = await prefs.getString('cartList')??'null';
     setState(() {
       if(cartString != 'null'){
         cartList=CartModel.decode(cartString);
         loaded=true;
       }
     });
   }
   clearCart()async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       cartList.clear();
     });
     prefs.setString('cartList',CartModel.encode(cartList));
   }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("My Cart",
          [InkWell(
            onTap: (){
              clearCart();
            },
            child: Padding(
              padding: const EdgeInsets.only(right:18.0),
              child: Center(
                child: Text('Clear Cart',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: splashBlue,
                  fontSize: 12
                ),),
              ),
            ),
          )],widget.show_back!),
      body:loaded? Container(
        height: screenHeight,
        width: screenWidth,

        child: cartList.isNotEmpty?
        SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: screenHeight*0.01),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth*0.06,
                ),
                child: ListView.builder(
                  itemCount: cartList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return cartListTile(screenWidth, screenHeight,cartList[index].productId,cartList[index].productQuantity,index+1);
                  },
                ),
              ),

              SizedBox(height: screenHeight*0.02,),
              Container(
                width: screenWidth,
                height: screenHeight*0.07,
                decoration: BoxDecoration(
                    color: splashBlue.withOpacity(0.1)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('Total - ',style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black.withOpacity(0.8)
                        ),),
                        Text('2 Items',style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: splashBlue
                        ),),
                      ],
                    ),
                    SizedBox(width: screenWidth*0.15,),
                    Text('\$ 1.100.000',style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black
                    ),),

                  ],
                ),
              ),
              SizedBox(height: screenHeight*0.02,),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth*0.06,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Checkbox(
                            value: isGst,
                            onChanged: (val){
                              setState(() {
                                isGst=val!;
                              });
                            }),
                        Text("GSTIN ",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 14
                        ),),
                        Text("(Optional)",
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14
                          ),)
                      ],
                    ),
                    Divider(
                      color: Colors.black.withOpacity(0.2),
                    ),
                    SizedBox(height: screenHeight*0.02,),
                    InkWell(
                      onTap: (){
                        setState(() {
                          showOption=!showOption;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Choose Delivery Option',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.8)
                            ),),
                          Icon(
                              showOption?
                                  Icons.keyboard_arrow_up:
                                  Icons.keyboard_arrow_down,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                    showOption?
                    Column(
                      children: [
                        SizedBox(height: screenHeight*0.02,),
                        Container(
                            width: screenWidth,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/home/Group 78.png',
                                        width: screenWidth*0.1,),
                                        SizedBox(width: screenWidth*0.03,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Deliver Now | \$6',style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),),
                                            Text('Get in next 30-35 mins',style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: splashBlue
                                            ),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Radio(value: 'now', groupValue: delivery,
                                        onChanged: (value){
                                      setState(() {
                                        delivery=value.toString();
                                      });
                                        })
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(height: screenHeight*0.02,),
                        Container(
                            width: screenWidth,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset('assets/home/Group 78.png',
                                              width: screenWidth*0.1,),
                                            SizedBox(width: screenWidth*0.03,),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Deliver Later | \$25',style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                ),),
                                                SizedBox(height: 4,),
                                                Text('Earliest slot: 10:00 AM - 11:00\nTomorrow',style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black.withOpacity(0.4)
                                                ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Radio(value: 'later', groupValue: delivery,
                                            onChanged: (value){
                                              setState(() {
                                                delivery=value.toString();
                                              });
                                            })
                                      ],
                                    ),
                                    SizedBox(height: screenHeight*0.03,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: screenHeight*0.055,
                                          width: screenWidth*0.35,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.black)
                                          ),
                                          child: Center(
                                            child: Text('11:00AM-12:00 PM',
                                            style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11,
                                              color: Colors.black
                                            ),),
                                          ),
                                        ),
                                        Container(
                                          height: screenHeight*0.055,
                                          width: screenWidth*0.35,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black)
                                          ),
                                          child: Center(
                                            child: Text('02:00PM-03:00 PM',
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 11,
                                                  color: Colors.black
                                              ),),
                                          ),
                                        )
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            )),
                        SizedBox(height: screenHeight*0.02,),
                        Container(
                            width: screenWidth,
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(4))
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset('assets/home/Group 78.png',
                                          width: screenWidth*0.1,),
                                        SizedBox(width: screenWidth*0.03,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Store Pickup',style: GoogleFonts.inter(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black
                                            ),),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Radio(value: 'store', groupValue: delivery,
                                        onChanged: (value){
                                          setState(() {
                                            delivery=value.toString();
                                          });
                                        })
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ):SizedBox.shrink(),
                    SizedBox(height: screenHeight*0.04,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Delivery Address',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.8)
                          ),),
                      ],
                    ),
                    SizedBox(height: screenHeight*0.03,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: splashBlue.withOpacity(0.2),
                              child: Padding(
                                padding:  EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                                child: Text('Default',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 9,
                                  color: splashBlue
                                ),),
                              ),
                            ),
                            SizedBox(height: screenHeight*0.02,),
                            Text('John Thomas',style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Colors.black
                            ),),
                            SizedBox(height: screenHeight*0.005,),
                            Container(
                              width: screenWidth*0.45,
                              child: Text('Jalan Haji Juanda No 1Paledang, Kecamatan Bogor Tengah, Kota Bogor,',style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.6)
                              ),),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, '/change_address');
                          },
                          child: Container(
                            height: screenHeight*0.055,
                            width: screenWidth*0.25,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: Center(
                              child: Text('Change',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black
                                ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: screenHeight*0.02),
                      child: Divider(color: Colors.black.withOpacity(0.3),),
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment Method',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.8)
                          ),),
                      ],
                    ),
                    SizedBox(height: screenHeight*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Image.asset('assets/home/mc_symbol.png',
                            height: screenWidth*0.08,),
                            SizedBox(width: screenWidth*0.02,),
                            Container(
                              child: Text('**** **** **** 3602',style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black.withOpacity(0.3)
                              ),),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, '/change_payment');
                          },
                          child: Container(
                            height: screenHeight*0.055,
                            width: screenWidth*0.25,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black)
                            ),
                            child: Center(
                              child: Text('Change',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black
                                ),),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight*0.08,),
                    blackButton('Checkout',
                        (){
                      Navigator.pushNamed(context, '/payment_success');
                        }, screenWidth, screenHeight*0.05),
                    SizedBox(height: screenHeight*0.04,),
                  ],
                ),
              )
            ],
          ),
        ):
        Center(child: Text("No Items!"),),
      ):
      Center(child: Text("Loading..."),),
    );
  }
}
