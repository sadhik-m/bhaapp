import 'package:bhaapp/cart/service/cartLengthService.dart';
import 'package:bhaapp/cart/service/paymentService.dart';
import 'package:bhaapp/cart/widget/cart_list_tile.dart';
import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/product/widget/benefit_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../address/model/addressModel.dart';
import '../dashboard/dash_board_screen.dart';
import '../product/model/cartModel.dart';

class MyCart extends StatefulWidget {
  static List<CartModel> cartList=[];


  bool? show_back;
   MyCart({ this.show_back});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
   bool isGst=false;
   bool showOption=false;
   String delivery='deliver now';
   String service='service now';
   bool loaded=false;

   double deliveryCharge=0;
   double deliveryChargeSelected=0;
   double bhaAppCharges=0;
   double amountToBhaApp=0;
   double amountToVendor=0;
   double minOrderValue=0;
   AddressModel ? addressModel;

   int totalItems=0;
   double totalPrice=0;
   Map<String, int> items={};

   String categoryType='';
   getCategoryType()async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     setState(() {
       categoryType=preferences.getString('categoryType')??'';
     });
   }
   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     getCartList();
     getDeliveryCharge();
     getDeliveryAddress();
     getCategoryType();
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

        child: MyCart.cartList.isNotEmpty?
        SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: screenHeight*0.01),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth*0.06,
                ),
                child: ListView.builder(
                  itemCount: MyCart.cartList.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return CartListTile(
                        width:screenWidth,
                        height:screenHeight,
                        prodId:MyCart.cartList[index].productId,
                        quantity:MyCart.cartList[index].productQuantity,
                        index:index,
                      categoryType: categoryType,
                    );
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
                    ValueListenableBuilder(
                      valueListenable: DashBoardScreen.cartValueNotifier.cartValueNotifier,
                      builder: (context, value, child) {
                        return value.toString()!='0'?
                        Row(
                          children: [
                            Text('Total - ',style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black.withOpacity(0.8)
                            ),),
                            Text('${value.toString()} Item(s)',style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: splashBlue
                            ),),
                          ],
                        ):Container();
                      },
                    ),
                    SizedBox(width: screenWidth*0.15,),
                    ValueListenableBuilder(
                      valueListenable: DashBoardScreen.cartTotalNotifier.cartValueNotifier,
                      builder: (context, value, child) {
                        return value.toString()!='0'?
                        Text('₹ ${(double.parse(value.toString())).toStringAsFixed(2)}',style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black
                        ),):Container();
                      },
                    ),


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
                   /* Row(
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
                    ),*/
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
                          Text(categoryType.toString().toLowerCase()=='services'?
                          'Choose Service Option':'Choose Delivery Option',
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
                    categoryType.toString().toLowerCase()=='services'?
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
                                child: Column(
                                  children: [
                                    Row(
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
                                                Text('Service Now',style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                ),),
                                                Text('Within 24 hours',style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: splashBlue
                                                ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Radio(value: 'service now', groupValue: service,
                                            onChanged: (value){
                                              setState(() {
                                                service=value.toString();
                                                //deliveryCharge=6;
                                              });
                                            })
                                      ],
                                    ),
                                    SizedBox(height: screenHeight*0.02,),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset('assets/home/Group 78.png',
                                                  width: screenWidth*0.1,),
                                                SizedBox(width: screenWidth*0.03,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Service Later',style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black
                                                    ),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Radio(value: 'service later', groupValue: service,
                                                onChanged: (value){
                                                  setState(() {
                                                    service=value.toString();
                                                   // deliveryCharge=25;
                                                  });
                                                })
                                          ],
                                        ),
                                        SizedBox(height: screenHeight*0.01,),
                                        Column(

                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: screenHeight*0.035,
                                                    //width: screenWidth*0.25,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black)
                                                    ),
                                                    child: Center(
                                                      child: Text("${DateFormat('d MMM y').format(selectedDate)}",
                                                        style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11,
                                                            color: Colors.black
                                                        ),),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: screenWidth*0.02,),
                                                InkWell(
                                                    onTap: (){
                                                      _selectDate(context);
                                                    },
                                                    child: Icon(Icons.date_range,color: Colors.black,)),
                                                SizedBox(width: screenWidth*0.02,),
                                                Text("(Weekly off day : $offDay)",
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.grey
                                                  ),)
                                              ],
                                            ),
                                            SizedBox(height: screenHeight*0.01,),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: screenHeight*0.035,
                                                    // width: screenWidth*0.25,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black)
                                                    ),
                                                    child: Center(
                                                      child: Text("${selectedTime.hourOfPeriod} : ${selectedTime.minute} ${selectedTime.period.name}",
                                                        style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11,
                                                            color: Colors.black
                                                        ),),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: screenWidth*0.02,),
                                                InkWell(
                                                    onTap: (){
                                                      _selectTime(context);
                                                    },
                                                    child: Icon(Icons.access_time,color: Colors.black,)),
                                                SizedBox(width: screenWidth*0.02,),
                                                Row(
                                                  children: [
                                                    Text("(Open:$openTime",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey
                                                      ),),
                                                    Text(int.parse(openTime)<12 || int.parse(openTime)>23?
                                                    'am':'pm',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey
                                                      ),),
                                                    Text(",Close:$closeTime",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey
                                                      ),),
                                                    Text(int.parse(closeTime)<12 || int.parse(closeTime)>23?
                                                    'am)':'pm)',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey
                                                      ),),
                                                  ],
                                                )
                                              ],
                                            )

                                          ],
                                        )

                                      ],
                                    ),

                                  ],
                                ),
                              ),
                            )),
                      ],
                    ):
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
                                child: Column(
                                  children: [
                                    Row(
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
                                                Text('Deliver Now',style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black
                                                ),),
                                                Text('Get in next 60-90 mins',style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: splashBlue
                                                ),),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Radio(value: 'deliver now', groupValue: delivery,
                                            onChanged: (value){
                                          setState(() {
                                            delivery=value.toString();
                                            deliveryChargeSelected=deliveryCharge;
                                          });
                                            })
                                      ],
                                    ),
                                    SizedBox(height: screenHeight*0.02,),
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset('assets/home/delivery-icon-21.png',
                                                  width: screenWidth*0.09,),
                                                SizedBox(width: screenWidth*0.03,),
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Deliver Later',style: GoogleFonts.inter(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.black
                                                    ),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Radio(value: 'deliver later', groupValue: delivery,
                                                onChanged: (value){
                                                  setState(() {
                                                    delivery=value.toString();
                                                    deliveryChargeSelected=deliveryCharge;
                                                   // deliveryCharge=25;
                                                  });
                                                })
                                          ],
                                        ),
                                        SizedBox(height: screenHeight*0.01,),
                                        Column(

                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: screenHeight*0.035,
                                                    //width: screenWidth*0.25,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black)
                                                    ),
                                                    child: Center(
                                                      child: Text("${DateFormat('d MMM y').format(selectedDate)}",
                                                        style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11,
                                                            color: Colors.black
                                                        ),),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: screenWidth*0.02,),
                                                InkWell(
                                                    onTap: (){
                                                      _selectDate(context);
                                                    },
                                                    child: Icon(Icons.date_range,color: Colors.black,)),
                                                SizedBox(width: screenWidth*0.02,),
                                                Text("(Weekly off day : $offDay)",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey
                                                ),)
                                              ],
                                            ),
                                            SizedBox(height: screenHeight*0.01,),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: screenHeight*0.035,
                                                   // width: screenWidth*0.25,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(color: Colors.black)
                                                    ),
                                                    child: Center(
                                                      child: Text("${selectedTime.hourOfPeriod} : ${selectedTime.minute} ${selectedTime.period.name}",
                                                        style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w500,
                                                            fontSize: 11,
                                                            color: Colors.black
                                                        ),),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: screenWidth*0.02,),
                                                InkWell(
                                                    onTap: (){
                                                      _selectTime(context);
                                                    },
                                                    child: Icon(Icons.access_time,color: Colors.black,)),
                                                SizedBox(width: screenWidth*0.02,),
                                                Row(
                                                  children: [
                                                    Text("(Open:$openTime",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey
                                                      ),),
                                                    Text(int.parse(openTime)<12 || int.parse(openTime)>23?
                                                      'am':'pm',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey
                                                      ),),
                                                    Text(",Close:$closeTime",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey
                                                      ),),
                                                    Text(int.parse(closeTime)<12 || int.parse(closeTime)>23?
                                                    'am)':'pm)',
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey
                                                      ),),
                                                  ],
                                                )
                                              ],
                                            )

                                          ],
                                        )

                                      ],
                                    ),
                                    SizedBox(height: screenHeight*0.02,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.local_grocery_store_outlined,size: screenWidth*0.08,),
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
                                        Radio(value: 'store pickup', groupValue: delivery,
                                            onChanged: (value){
                                              setState(() {
                                                delivery=value.toString();
                                                deliveryChargeSelected=0;
                                              });
                                            })
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ):
                    SizedBox.shrink(),
                    addressModel==null?
                    SizedBox.shrink():
                    Column(
                      children: [
                        SizedBox(height: screenHeight*0.04,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(categoryType.toString().toLowerCase()=='services'?'Service Address':'Delivery Address',
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
                                Text(addressModel!.name,style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black
                                ),),
                                SizedBox(height: screenHeight*0.005,),
                                Container(
                                  width: screenWidth*0.45,
                                  child: Text('${addressModel!.address},${addressModel!.country.toString().toUpperCase()}\nPh : ${addressModel!.mobile}',style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.6)
                                  ),),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.pushNamed(context, '/change_address').then((value) {
                                  setState(() {
                                    getDeliveryAddress();
                                  });
                                });
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
                      ],
                    ),
                    SizedBox(height: screenHeight*0.01,),
                    ValueListenableBuilder(
                      valueListenable: DashBoardScreen.cartTotalNotifier.cartValueNotifier,
                      builder: (context, value, child) {
                        return value.toString()!='0'?
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Cart Total',style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black
                                ),),
                                Text('₹ ${(double.parse(value.toString())).toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Colors.black
                                  ),),
                              ],
                            ),
                            SizedBox(height: screenHeight*0.01,),
                            categoryType.toString().toLowerCase()=='services'?
                                Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('SGST (9%)',style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.black
                                      ),),
                                      Text('₹ ${((9/100)*double.parse(value.toString())).toStringAsFixed(2)}',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: Colors.black
                                        ),),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight*0.01,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('IGST (9%)',style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.black
                                      ),),
                                      Text('₹ ${((9/100)*double.parse(value.toString())).toStringAsFixed(2)}',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: Colors.black
                                        ),),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight*0.01,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Delivery Charges',style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: Colors.black
                                      ),),
                                      Text('₹ ${double.parse(deliveryChargeSelected.toString()).toStringAsFixed(2)}',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: Colors.black
                                        ),),
                                    ],
                                  ),
                                ],):
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('GST (0%)',style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.black
                                        ),),
                                        Text('₹ 0.00',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: Colors.black
                                          ),),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight*0.01,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('Delivery Charges',style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.black
                                        ),),
                                        Text('₹ 0.00',
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: Colors.black
                                          ),),
                                      ],
                                    ),
                                  ],
                                ),
                            SizedBox(height: screenHeight*0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total',style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.black
                                ),),
                                categoryType.toString().toLowerCase()=='services'?
                                Text('₹ ${((double.parse(value.toString()))+((9/100)*double.parse(value.toString()))+((9/100)*double.parse(value.toString()))+deliveryChargeSelected).toStringAsFixed(2)}',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black
                                  ),):
                                Text('₹ '+(double.parse(value.toString())).toStringAsFixed(2),
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black
                                  ),),
                              ],
                            ),
                            SizedBox(height: screenHeight*0.08,),
                            blackButton('Checkout',
                                    (){
                              if(double.parse(value.toString())>=minOrderValue){
                                if(categoryType.toString().toLowerCase()=='services'){
                                  setState(() {
                                    amountToVendor=(((double.parse(value.toString()))+((9/100)*double.parse(value.toString()))+((9/100)*double.parse(value.toString()))+deliveryChargeSelected)-(deliveryChargeSelected+bhaAppCharges+((9/100)*double.parse(value.toString()))+((9/100)*double.parse(value.toString()))));
                                    amountToBhaApp=deliveryChargeSelected+bhaAppCharges+((9/100)*double.parse(value.toString()))+((9/100)*double.parse(value.toString()));
                                  });
                                  PaymentService().checkOut(
                                      context,
                                      '${addressModel!.name},${addressModel!.address},${addressModel!.country.toString().toUpperCase()}\nPH : ${addressModel!.mobile}',
                                      categoryType.toString().toLowerCase()=='services'?'$service':"$delivery",
                                      ((double.parse(value.toString()))+((9/100)*double.parse(value.toString()))+((9/100)*double.parse(value.toString()))+deliveryChargeSelected).toStringAsFixed(2),
                                      items,
                                      "${DateFormat('d MMM y').format(selectedDate)},${selectedTime.hourOfPeriod} : ${selectedTime.minute} ${selectedTime.period.name}",
                                      '${addressModel!.mobile}',categoryType.toString().toLowerCase(),
                                      amountToVendor,amountToBhaApp
                                  );
                                }
                                else{
                                  setState(() {
                                    amountToVendor=((double.parse(value.toString()))-(deliveryChargeSelected+bhaAppCharges));
                                    amountToBhaApp=deliveryChargeSelected+bhaAppCharges;
                                  });
                                  PaymentService().checkOut(
                                      context,
                                      '${addressModel!.name},${addressModel!.address},${addressModel!.country.toString().toUpperCase()}\nPH : ${addressModel!.mobile}',
                                      categoryType.toString().toLowerCase()=='services'?'$service':"$delivery",
                                      (double.parse(value.toString())).toStringAsFixed(2),
                                      items,
                                      "${DateFormat('d MMM y').format(selectedDate)},${selectedTime.hourOfPeriod} : ${selectedTime.minute} ${selectedTime.period.name}",
                                      '${addressModel!.mobile}',categoryType.toString().toLowerCase(),
                                      amountToVendor,amountToBhaApp
                                  );
                                }
                              }else{
                                Fluttertoast.showToast(msg: 'You need to purchase for a mininimum of ₹ $minOrderValue to place the order ');
                              }


                                }, screenWidth, screenHeight*0.05),
                          ],
                        ):Container();
                      },
                    ),


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

   getCartList()async{

     double totalAmount=0;


     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final String cartString = await prefs.getString('cartList')??'null';
     setState(() {
       if(cartString != 'null'){
         MyCart.cartList=CartModel.decode(cartString);
         totalItems=MyCart.cartList.length;
         DashBoardScreen.cartValueNotifier.updateNotifier(MyCart.cartList.length);
       }
     });
     if(MyCart.cartList.isNotEmpty){
       MyCart.cartList.forEach((element) {
         setState(() {
           FirebaseFirestore.instance.collection('products').doc(element.productId).get().then((value) {
             setState(() {
               totalAmount += (double.parse(value['salesPrice'].toString())*element.productQuantity);
               items.addAll({'${value['sku']}':element.productQuantity});
               DashBoardScreen.cartTotalNotifier.updateNotifier(totalAmount);
               print("TTTTTTTTTTTTT $totalAmount");
             });
           });
         });
       });
       //print("TTTTTTTTTTTTT $totalAmount");

     }

    getShopTiming();
   }
   String offDay='';
   String openTime='';
   String closeTime='';
   getShopTiming()async{
     print('hhhh000000');
     SharedPreferences preferences=await SharedPreferences.getInstance();
     String vendorDocId=preferences.getString('vendorDocId')??'';
     await FirebaseFirestore.instance
         .collection('vendors')
         .doc(vendorDocId)
         .get()
         .then((DocumentSnapshot documentSnapshot) {
       if (documentSnapshot.exists) {
         setState(() {
           offDay=documentSnapshot['weeklyOffDay'].toString();
           openTime=documentSnapshot['openTime.${'hour'}'].toString();
           closeTime=documentSnapshot['closeTime.${'hour'}'].toString();
           if(isWeekend(DateTime.now())==false){
             print('FGGGG');
             if(DateTime.now().hour < int.parse(closeTime) && DateTime.now().hour > int.parse(openTime)){
               print('object1');
               setState(() {
                 selectedDate=DateTime.now();
                 selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: 00);
               });
             }else if(DateTime.now().hour < int.parse(closeTime) && DateTime.now().hour < int.parse(openTime)){
               print('object2');
               setState(() {
                 selectedDate=DateTime.now();
                 selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
               });
             }else if(DateTime.now().hour > int.parse(closeTime)){
               print('object3');
               setState(() {
                 selectedDate=DateTime.now().add(const Duration(days: 1));
                 selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
               });
             }else{
               print('object4');
               setState(() {
                 selectedDate=DateTime.now().add(const Duration(days: 1));
                 selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
               });
             }

           }else{
             print('yGGGG');
             setState(() {
               selectedDate=DateTime.now().add(const Duration(days: 1));
               selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
             });
           }


         });
       } else {
         print('Document does not exist on the database');
       }
     });
     setState(() {
       print("IIIITTTTT $offDay");
       print("IIIITTTTT $selectedTime");
       print("IIIITTTTT $selectedDate");
       loaded=true;
     });
   }

   getDeliveryCharge()async{
     SharedPreferences preferences=await SharedPreferences.getInstance();
     String vendorDocId=preferences.getString('vendorDocId')??'';
     FirebaseFirestore.instance
         .collection('vendors')
         .doc(vendorDocId)
         .get()
         .then((DocumentSnapshot documentSnapshot) {
       if (documentSnapshot.exists) {
         setState(() {
           deliveryCharge=double.parse(documentSnapshot['deliveryDetails.${'deliveryCharges'}'].toString());
           deliveryChargeSelected=deliveryCharge;
           bhaAppCharges=double.parse(documentSnapshot['BhaAppCharges'].toString());
           minOrderValue=double.parse(documentSnapshot['minOrderValue'].toString());
           print('MMINN OORDDERRRR value   $minOrderValue');
         });
       } else {
         print('Document does not exist on the database');
       }
     });
   }

   clearCart()async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       MyCart.cartList.clear();
       DashBoardScreen.cartValueNotifier.updateNotifier(0);
       prefs.remove('cartList');
     });
    // prefs.setString('cartList',CartModel.encode(MyCart.cartList));

   }
   getDeliveryAddress()async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     String ? uid=prefs.getString('uid');
     String ? addressId;
     await FirebaseFirestore.instance.collection('customers').doc(uid).get().then((value) {
       setState(() {
         addressId=value['defualtAddressId'].toString();
       });
     });
     await FirebaseFirestore.instance.collection('customers').doc(uid).collection('customerAddresses').doc(addressId).get()
         .then((DocumentSnapshot doc) {

       setState(() {
         addressModel=AddressModel(name: doc['name'], mobile: doc['mobile'], email: doc['email'], country: doc['country'], address: doc['address'], type: doc['type'],id: doc.id.toString(),
             pinCode: doc['pinCode'],latitude: doc['latitude'],longitude: doc['longitude']);
       });

     });
   }
   late DateTime selectedDate;
   late TimeOfDay selectedTime;
   Future<void> _selectDate(BuildContext context) async {
     final DateTime? picked = await showDatePicker(
         context: context,
         initialDate: selectedDate,
         firstDate: DateTime.now(),
         lastDate: DateTime(2101));
     if (picked != null && picked != selectedDate) {
       if(isWeekend(picked)){
         Fluttertoast.showToast(msg: 'Shop is closed on the selected day,please choose another date');
       }else{
         setState(() {
           selectedDate = picked;
         });
       }

     }
   }

   bool isWeekend(DateTime date) {
     DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(date.toString());
     DateFormat dateFormat = DateFormat("EEE");
     String string = dateFormat.format(tempDate);
     print(string);
   if (string.toLowerCase() == offDay.toLowerCase()) return true;
   return false;
   }



   Future<void> _selectTime(BuildContext context) async {
     final TimeOfDay ? picked = await showTimePicker(
       context: context,
       initialTime: selectedTime,
       initialEntryMode: TimePickerEntryMode.dialOnly
     );
     if (picked != null) {
       if(picked.hour > int.parse(closeTime) || picked.hour < int.parse(openTime)){
         Fluttertoast.showToast(msg: 'Shop is closed on the selected time,please choose another time');
       }else{
         setState(() {
           selectedTime = picked;
         });
       }
     }
   }
}
