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
  bool? show_back;
   MyCart({ this.show_back});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
   bool isGst=false;
   bool showOption=false;
   String delivery='deliver now';
   bool loaded=false;
   int totalItems=0;
   double totalPrice=0;
   double deliveryCharge=6;
   AddressModel ? addressModel;

   List<CartModel> cartList=[];
    Map<String, int> items={};

   @override
   void initState() {
     // TODO: implement initState
     super.initState();
     getCartList();
     getDeliveryAddress();
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
                        Text('$totalItems Items',style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: splashBlue
                        ),),
                      ],
                    ),
                    SizedBox(width: screenWidth*0.15,),
                    Text('\$ $totalPrice',style: GoogleFonts.inter(
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
                                        Radio(value: 'deliver now', groupValue: delivery,
                                            onChanged: (value){
                                          setState(() {
                                            delivery=value.toString();
                                            deliveryCharge=6;
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
                                                    Text('Deliver Later | \$25',style: GoogleFonts.inter(
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
                                                    deliveryCharge=25;
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
                                                deliveryCharge=0;
                                              });
                                            })
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ):SizedBox.shrink(),
                    addressModel==null?
                    SizedBox.shrink():
                    Column(
                      children: [
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
                                Text(addressModel!.name,style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.black
                                ),),
                                SizedBox(height: screenHeight*0.005,),
                                Container(
                                  width: screenWidth*0.45,
                                  child: Text('${addressModel!.address},${addressModel!.country}\nph : ${addressModel!.mobile}',style: GoogleFonts.inter(
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

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Cart total',style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black
                        ),),
                        Text('\$ $totalPrice',
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
                        Text('Tax (9%)',style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black
                        ),),
                        Text('\$ ${((9/totalPrice)*100).toStringAsFixed(2)}',
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
                        Text('Delivery charge',style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Colors.black
                        ),),
                        Text('\$ $deliveryCharge',
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
                        Text('Total',style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black
                        ),),
                        Text((totalPrice+deliveryCharge+((9/totalPrice)*100)).toStringAsFixed(2),
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
                          PaymentService().checkOut(context,
                              '${addressModel!.name},${addressModel!.address},${addressModel!.country}\nph : ${addressModel!.mobile}',
                          "$delivery,requested delivery date : ${DateFormat('d MMM y').format(selectedDate)},${selectedTime.hourOfPeriod} : ${selectedTime.minute} ${selectedTime.period.name}",(totalPrice+deliveryCharge+((9/totalPrice)*100)).toStringAsFixed(2),items);
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
   getCartList()async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     final String cartString = await prefs.getString('cartList')??'null';
     setState(() {
       if(cartString != 'null'){
         cartList=CartModel.decode(cartString);
         totalItems=cartList.length;
         DashBoardScreen.cartValueNotifier.updateNotifier(cartList.length);
       }
     });
     cartList.forEach((element) {
       setState(() {
         FirebaseFirestore.instance.collection('products').doc(element.productId).get().then((value) {
           setState(() {
             totalPrice += (double.parse(value['salesPrice'].toString())*element.productQuantity);
             items.addAll({'${value['sku']}':element.productQuantity});
           });
         });
       });
     });
    getShopTiming();
   }
   String offDay='';
   String openTime='';
   String closeTime='';
   getShopTiming()async{
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
             if(DateTime.now().hour < int.parse(closeTime) && DateTime.now().hour > int.parse(openTime)){
               setState(() {
                 selectedDate=DateTime.now();
                 selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: 00);
               });
             }else if(DateTime.now().hour < int.parse(closeTime) && DateTime.now().hour < int.parse(openTime)){
               selectedDate=DateTime.now();
               selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
             }else if(DateTime.now().hour > int.parse(closeTime)){
               selectedDate=DateTime.now().add(const Duration(days: 1));
               selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
             }

           }else{
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
       loaded=true;
     });
   }



   clearCart()async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     setState(() {
       cartList.clear();
       DashBoardScreen.cartValueNotifier.updateNotifier(0);
     });
     prefs.setString('cartList',CartModel.encode(cartList));
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
         addressModel=AddressModel(name: doc['name'], mobile: doc['mobile'], email: doc['email'], country: doc['country'], address: doc['address'], type: doc['type'],id: doc.id.toString(),pinCode: doc['pinCode']);
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
