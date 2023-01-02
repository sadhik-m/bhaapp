import 'dart:convert';

import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/order/model/orderStatusModel.dart';
import 'package:bhaapp/order/widget/order_detail_product_tile.dart';
import 'package:bhaapp/order/widget/order_tracker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../common/widgets/appBar.dart';

class OrderDetail extends StatefulWidget {
  String orderid;
  List<String>sku=[];
  List<String>quqntity=[];
  String shopContact;
  String orderStatus;
  String orderStatusDate;
   OrderDetail({Key? key,required this.orderid,required this.sku,required this.quqntity,required this.shopContact,required this.orderStatus,required this.orderStatusDate}) : super(key: key);

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  bool loaded=false;
  List<OrderStatusModel> satatusList=[];
  getStatusList()async{
    String stsList=  await FirebaseFirestore.instance.collection('orders').doc(widget.orderid).get().then((value) {
      return value['DeliveryStatus'].toString();
    });
    setState(() {
      var convert=json.decode(stsList);
      print(convert);
      print(convert[0]['name']);
      for(var i=0;i<convert.length;i++){
        satatusList.add(OrderStatusModel(name: convert[i]['name'], status: convert[i]['status'], date: convert[i]['date']));
      }
    });

   /* await FirebaseFirestore.instance.collection('orders').doc(widget.orderid).collection('DeliveryStatus').get().then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {
        setState(() {
          satatusList.add(OrderStatusModel(name: doc['name'], status: doc['status'], date: doc['date']));
        });
      });
    });*/
    setState(() {
      loaded=true;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatusList();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("Order Details",
          [/*Padding(
            padding: const EdgeInsets.only(right:18.0),
            child: Row(
              children: [

                Image.asset('assets/home/search.png',
                  height: 24,color: Colors.black,),
              ],
            ),
          )*/],true),
      body: loaded?
      Container(
        height: screenHeight,
        width: screenWidth,

        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight*0.065,
                      color: splashBlue.withOpacity(0.1),
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Order ID:',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black
                          ),) ,
                          Expanded(
                            child: Text(widget.orderid,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: splashBlue
                            ),),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight*0.03,),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth*0.07,

                      ),
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: widget.sku.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return orderDetailProductListTile(screenWidth, screenHeight,widget.sku[index],widget.quqntity[index]);
                            },
                          ),
                          Row(
                            children: [
                              Text('Tracking Details',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.8)
                              ),)
                            ],
                          ),
                          SizedBox(height: 10,),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Row(
                               children: [
                                 Text('Estimated Delivery: ',style: GoogleFonts.inter(
                                     fontSize: 10,
                                     fontWeight: FontWeight.w400,
                                     color: Colors.black.withOpacity(0.6)
                                 ),),
                                 Text('30 Sept 2022',style: GoogleFonts.inter(
                                     fontSize: 12,
                                     fontWeight: FontWeight.w600,
                                     color: Colors.black.withOpacity(0.8)
                                 ),),
                               ],
                             ),
                             /*Image.asset('assets/home/356674 1.png',
                             height: 25,width: 74,)*/
                           ],
                         ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              InkWell(
                                onTap: (){
                                  launchUrl(Uri(
                                    scheme: 'tel',
                                    path: widget.shopContact,
                                  ));
                                },
                                child: Container(
                                  width: 56,
                                    height: 19.6,
                                  color: Color(0xff28B446).withOpacity(0.2),
                                  child: Center(
                                    child: Text('Call',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                      color: Color(0xff28B446)
                                    ),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),
                          widget.orderStatus.toLowerCase()=='order cancelled'?
                              Text("Order Cancelled",style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.red
                              ),):
                          OrderTracker(orderStatus: widget.orderStatus,orderStatusDate: widget.orderStatusDate,statusList: satatusList,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            satatusList[1].status==false?
            Padding(
               padding: EdgeInsets.symmetric(
                 horizontal: screenWidth*0.07,
                 vertical: screenHeight*0.01
               ),
              child: blackButton("Cancel Order", (){
                showCancelDialog(context);
              }, screenWidth, screenHeight*0.05),
            ):SizedBox.shrink()

          ],
        ),
      ):Center(child: Text("Loading..."),),
    );
  }
  cancelOrder()async{
    await FirebaseFirestore.instance.collection('orders').doc(widget.orderid).set({
      'status':'Order Cancelled'
    },
      SetOptions(merge: true),
    ).then((value) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: 'Order cancelled successfully');
    });
  }
  showCancelDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {

        Navigator.of(context).pop();
        cancelOrder();

      },
    );
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {

        Navigator.of(context).pop();

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      title: Text("Are you sure,you want to cancell this order?"),

      actions: [
        cancelButton,
        okButton
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
