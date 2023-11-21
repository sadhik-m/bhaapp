import 'dart:async';

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
import '../shop_search/view/shop_search_screen.dart';

class MyCart extends StatefulWidget {
  static List<CartModel> cartList = [];

  bool? show_back;
  MyCart({this.show_back});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  bool isGst = false;
  // bool showOption = false;
  String selectedOption = '';
  String delivery = 'deliver now';
  String service = 'service now';
  bool loaded = false;
  bool deliverToAddress = false;
  bool deliverToPickup = false;

  double deliveryCharge = 0;
  String deliveringService = '';
  double deliveryChargeSelected = 0;
  double bhaAppCharges = 0;
  double amountToBhaApp = 0;
  double amountToVendor = 0;
  double minOrderValue = 0;
  AddressModel? addressModel;

  int totalItems = 0;
  double totalPrice = 0;
  Map<String, int> items = {};

  bool pickupPointSelected = false;
  List<String> pickupPoints = [];
  String selectedPickupPoint = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCartList();
    getDeliveryCharge();
    getDeliveryAddress();
    getPickupPoints();
    startTimer();
  }

  Timer? timer;

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      onUpDate();
    });
  }

  cancelTimer() {
    timer!.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
          "My Cart",
          [
            InkWell(
              onTap: () {
                clearCart();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Center(
                  child: Text(
                    'Clear Cart',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: splashBlue,
                        fontSize: 12),
                  ),
                ),
              ),
            )
          ],
          widget.show_back!),
      body: loaded
          ? Container(
              height: screenHeight,
              width: screenWidth,
              child: MyCart.cartList.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.005),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  shopName,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                            ),
                            child: ListView.builder(
                              itemCount: MyCart.cartList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return CartListTile(
                                  width: screenWidth,
                                  height: screenHeight,
                                  prodId: MyCart.cartList[index].productId,
                                  quantity:
                                      MyCart.cartList[index].productQuantity,
                                  index: index,
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Container(
                            width: screenWidth,
                            height: screenHeight * 0.07,
                            decoration: BoxDecoration(
                                color: splashBlue.withOpacity(0.1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: DashBoardScreen
                                      .cartValueNotifier.cartValueNotifier,
                                  builder: (context, value, child) {
                                    return value.toString() != '0'
                                        ? Row(
                                            children: [
                                              Text(
                                                'Total - ',
                                                style: GoogleFonts.inter(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black
                                                        .withOpacity(0.8)),
                                              ),
                                              Text(
                                                '${value.toString()} Item(s)',
                                                style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: splashBlue),
                                              ),
                                            ],
                                          )
                                        : Container();
                                  },
                                ),
                                SizedBox(
                                  width: screenWidth * 0.15,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: DashBoardScreen
                                      .cartTotalNotifier.cartValueNotifier,
                                  builder: (context, value, child) {
                                    return value.toString() != '0'
                                        ? Text(
                                            '₹ ${(double.parse(value.toString())).toStringAsFixed(2)}',
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Colors.black),
                                          )
                                        : Container();
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Choose Delivery Option',
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black.withOpacity(0.8)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                deliverToAddress
                                    ? Card(
                                        elevation: 5,
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    'Delivering to an address',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                ),
                                                Radio(
                                                    value: 'address',
                                                    groupValue: selectedOption,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedOption =
                                                            value.toString();
                                                        pickupPointSelected =
                                                            false;
                                                      });
                                                    })
                                              ],
                                            ),
                                            selectedOption == 'address'
                                                ? Column(
                                                    children: [
                                                      Container(
                                                          width: screenWidth,
                                                          child: Card(
                                                            elevation: 5,
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4))),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      15.0),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Image
                                                                              .asset(
                                                                            'assets/home/Group 78.png',
                                                                            width:
                                                                                screenWidth * 0.1,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                screenWidth * 0.03,
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                'Deliver Now',
                                                                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                                                              ),
                                                                              Text(
                                                                                'Get in next 60-90 mins',
                                                                                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: splashBlue),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Radio(
                                                                          value:
                                                                              'deliver now',
                                                                          groupValue:
                                                                              delivery,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              delivery = value.toString();
                                                                              deliveryChargeSelected = deliveryCharge;
                                                                              selectedDate = DateTime.now();
                                                                              selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: 00);
                                                                            });
                                                                          })
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        screenHeight *
                                                                            0.02,
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        //crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Image.asset(
                                                                                'assets/home/delivery-icon-21.png',
                                                                                width: screenWidth * 0.09,
                                                                              ),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.03,
                                                                              ),
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    'Deliver Later',
                                                                                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Radio(
                                                                              value: 'deliver later',
                                                                              groupValue: delivery,
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  delivery = value.toString();
                                                                                  deliveryChargeSelected = deliveryCharge;
                                                                                  // deliveryCharge=25;
                                                                                });
                                                                              })
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height: screenHeight *
                                                                            0.01,
                                                                      ),
                                                                      Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  height: screenHeight * 0.035,
                                                                                  //width: screenWidth*0.25,
                                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "${DateFormat('d MMM y').format(selectedDate)}",
                                                                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.02,
                                                                              ),
                                                                              InkWell(
                                                                                  onTap: () {
                                                                                    _selectDate(context);
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.date_range,
                                                                                    color: Colors.black,
                                                                                  )),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.02,
                                                                              ),
                                                                              Text(
                                                                                "(Weekly off day : $offDay)",
                                                                                style: TextStyle(fontSize: 11, color: Colors.grey),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                screenHeight * 0.01,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Expanded(
                                                                                child: Container(
                                                                                  height: screenHeight * 0.035,
                                                                                  // width: screenWidth*0.25,
                                                                                  decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      "${selectedTime.hourOfPeriod.toString().padLeft(2, '0')} : ${selectedTime.minute.toString().padLeft(2, '0')} ${selectedTime.period.name}",
                                                                                      style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 11, color: Colors.black),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.02,
                                                                              ),
                                                                              InkWell(
                                                                                  onTap: () {
                                                                                    _selectTime(context);
                                                                                  },
                                                                                  child: Icon(
                                                                                    Icons.access_time,
                                                                                    color: Colors.black,
                                                                                  )),
                                                                              SizedBox(
                                                                                width: screenWidth * 0.02,
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Text(
                                                                                    "(Open:${openTime.toString().padLeft(2, '0')}:00",
                                                                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                                                                  ),
                                                                                  Text(
                                                                                    int.parse(openTime) < 12 || int.parse(openTime) > 23 ? 'am' : 'pm',
                                                                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                                                                  ),
                                                                                  Text(
                                                                                    ",Close:${closeTime.toString().padLeft(2, '0')}:00",
                                                                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                                                                  ),
                                                                                  Text(
                                                                                    int.parse(closeTime) < 12 || int.parse(closeTime) > 23 ? 'am)' : 'pm)',
                                                                                    style: TextStyle(fontSize: 11, color: Colors.grey),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      )
                                                                    ],
                                                                  ),
                                                                  /*
                                                                  // Store pick section
                                                                  SizedBox(
                                                                    height:
                                                                        screenHeight *
                                                                            0.02,
                                                                  ),
                                                                  storePickupInfo(screenWidth),
                                                                   */
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                /*
                                pickupPoints.isNotEmpty &&
                                    deliveringService == "BhaApp"
                                 */
                                pickupPoints.isNotEmpty
                                    ? Card(
                                        elevation: 5,
                                        margin: EdgeInsets.zero,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    'Delivering to a pickup point',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                ),
                                                Radio(
                                                    value: 'pickup point',
                                                    groupValue: selectedOption,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedOption =
                                                            value.toString();
                                                        delivery =
                                                            value.toString();
                                                        pickupPointSelected =
                                                            true;
                                                      });
                                                    })
                                              ],
                                            ),
                                            if (selectedOption ==
                                                'pickup point')
                                              pickupPointSelection(),
                                            if (selectedOption ==
                                                'pickup point')
                                              SizedBox(
                                                height: screenHeight * 0.01,
                                              ),
                                            if (selectedOption ==
                                                'pickup point')
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          "Select Date: ",
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8))),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: screenHeight *
                                                            0.035,
                                                        //width: screenWidth*0.25,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                        child: Center(
                                                          child: Text(
                                                            "${DateFormat('d MMM y').format(selectedDate)}",
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.02,
                                                    ),
                                                    InkWell(
                                                        onTap: () {
                                                          _selectDate(context);
                                                        },
                                                        child: Icon(
                                                          Icons.date_range,
                                                          color: Colors.black,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                            if (selectedOption ==
                                                'pickup point')
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                          "Select Time: ",
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8))),
                                                    ),
                                                    Expanded(
                                                      child: DropdownButton<
                                                          String>(
                                                        value: selectedTimeSlot,
                                                        onChanged:
                                                            (String? newValue) {
                                                          setState(() {
                                                            selectedTimeSlot =
                                                                newValue!;
                                                          });
                                                        },
                                                        items: timeSlots
                                                            .map((String item) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: item,
                                                            child: Text(item),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                // pickup point support is only for BhaApp delivery

                                addressModel == null
                                    ? SizedBox.shrink()
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: screenHeight * 0.04,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Delivery Address',
                                                style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                    color: Colors.black
                                                        .withOpacity(0.8)),
                                              ),
                                            ],
                                          ),
                                          (pickupPointSelected == false)
                                              ? SizedBox(
                                                  height: screenHeight * 0.03,
                                                )
                                              : SizedBox(
                                                  height: screenHeight * 0.01,
                                                ),
                                          (pickupPointSelected == false)
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          color: splashBlue
                                                              .withOpacity(0.2),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        6),
                                                            child: Text(
                                                              'Default',
                                                              style: GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 9,
                                                                  color:
                                                                      splashBlue),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: screenHeight *
                                                              0.02,
                                                        ),
                                                        Text(
                                                          addressModel!.name,
                                                          style:
                                                              GoogleFonts.inter(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        SizedBox(
                                                          height: screenHeight *
                                                              0.005,
                                                        ),
                                                        Container(
                                                          width: screenWidth *
                                                              0.45,
                                                          child: Text(
                                                            '${addressModel!.address},${addressModel!.country.toString().toUpperCase()}\nPh : ${addressModel!.mobile}\nPincode : ${addressModel!.pinCode}',
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.6)),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                                context,
                                                                '/change_address')
                                                            .then((value) {
                                                          setState(() {
                                                            getDeliveryAddress();
                                                          });
                                                        });
                                                      },
                                                      child: Container(
                                                        height: screenHeight *
                                                            0.055,
                                                        width:
                                                            screenWidth * 0.25,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .black)),
                                                        child: Center(
                                                          child: Text(
                                                            'Change',
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Text(
                                                      selectedPickupPoint,
                                                      style: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ],
                                                ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: screenHeight * 0.02),
                                            child: Divider(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                            ),
                                          ),
                                        ],
                                      ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                ValueListenableBuilder(
                                  valueListenable: DashBoardScreen
                                      .cartTotalNotifier.cartValueNotifier,
                                  builder: (context, value, child) {
                                    return value.toString() != '0'
                                        ? Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Cart Total',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    '₹ ${(double.parse(value.toString())).toStringAsFixed(2)}',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.01,
                                              ),
                                              Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'GST',
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          /*
                                                          Text(
                                                            '₹ 0.00',
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                           */
                                                          Text(
                                                            'Included in item price',
                                                            style: GoogleFonts
                                                                .inter(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: screenHeight * 0.01,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        'Delivery Charges',
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                      Text(
                                                        '₹ 0.00',
                                                        style:
                                                            GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Total',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    '₹ ${(double.parse(value.toString())).toStringAsFixed(2)}',
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: screenHeight * 0.08,
                                              ),
                                              blackButton('Checkout', () async {
                                                if (selectedOption.isEmpty) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Please select a delivery option!');
                                                } else if (double.parse(
                                                        value.toString()) >=
                                                    minOrderValue) {
                                                  bool shopClosedNow =
                                                      await checkShopClosed();
                                                  if (shopClosedNow) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Shop is closed now,try again later!');
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ShopSearchScreen(
                                                                          willPop:
                                                                              true,
                                                                        )),
                                                            (route) => false);
                                                    //print(object)
                                                  } else {
                                                    setState(() {
                                                      amountToVendor = ((double
                                                              .parse(value
                                                                  .toString())) -
                                                          (deliveryChargeSelected +
                                                              getBhaAppCharges(
                                                                  (double.parse(
                                                                      value
                                                                          .toString())))));
                                                      amountToBhaApp =
                                                          deliveryChargeSelected +
                                                              getBhaAppCharges(
                                                                  (double.parse(
                                                                      value
                                                                          .toString())));
                                                    });
                                                    await onUpDate();
                                                    bool isAllAvailable =
                                                        await availabiltyCheck();
                                                    if (isAllAvailable) {
                                                      setState(() {
                                                        if(delivery=='deliver later'){
                                                          selectedDate=DateTime(selectedDate.year,selectedDate.month,selectedDate.day,selectedTime.hour,selectedTime.minute);
                                                        }else if(pickupPointSelected){
                                                          int sHour=selectedTimeSlot.split(' ')[1].toLowerCase()=='pm'&&selectedTimeSlot.split(' ')[0]!='12'?
                                                          int.parse(selectedTimeSlot.split(' ')[0])+12
                                                              :int.parse(selectedTimeSlot.split(' ')[0]);
                                                          selectedDate=DateTime(selectedDate.year,selectedDate.month,selectedDate.day,sHour);
                                                        }
                                                      });
                                                      PaymentService().checkOut(
                                                          context,
                                                          '${addressModel!.name},${addressModel!.address},${addressModel!.country.toString().toUpperCase()}\nPH : ${addressModel!.mobile}\nPincode : ${addressModel!.pinCode}',
                                                          "$delivery",
                                                          //(double.parse(value.toString())).toStringAsFixed(2),
                                                          (double.parse(value
                                                                  .toString()))
                                                              .toStringAsFixed(
                                                                  2),
                                                          items,
                                                          selectedDate,
                                                          '${addressModel!.mobile}',
                                                          'Delivery',
                                                          amountToVendor,
                                                          amountToBhaApp,
                                                          addressModel!.pinCode,
                                                          deliveringService,
                                                          pickupPointSelected
                                                              ? selectedPickupPoint
                                                              : '',
                                                          selectedTimeSlot);
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Items not in stock! ');
                                                    }
                                                  }
                                                } else {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'You need to purchase for a mininimum of ₹ $minOrderValue to place the order ');
                                                }
                                              }, screenWidth,
                                                  screenHeight * 0.05),
                                            ],
                                          )
                                        : Container();
                                  },
                                ),
                                SizedBox(
                                  height: screenHeight * 0.04,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Center(
                      child: Text("No Items!"),
                    ),
            )
          : Center(
              child: Text("Loading..."),
            ),
    );
  }

  Row storePickupInfo(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_grocery_store_outlined,
              size: screenWidth * 0.08,
            ),
            SizedBox(
              width: screenWidth * 0.03,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store Pickup',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        Radio(
            value: 'store pickup',
            groupValue: delivery,
            onChanged: (value) {
              setState(() {
                delivery = value.toString();
                deliveryChargeSelected = 0;
              });
            })
      ],
    );
  }

  List<String> timeSlots = [];
  String selectedTimeSlot = '';

  RenderObjectWidget pickupPointSelection() {
    return (pickupPoints.isNotEmpty)
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Select a Pickup Point: ',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.8))),
                    DropdownButton<String>(
                      value: selectedPickupPoint,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedPickupPoint = newValue!;
                        });
                      },
                      items: pickupPoints.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                    ),
                  ],
                )
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  bool isTimeBetween(
      DateTime currentTime, DateTime startTime, DateTime endTime) {
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  Future<bool> checkShopClosed() async {
    int openHour = 0;
    int openMinute = 0;
    int closeHour = 0;
    int closeMinute = 0;
    bool approved = false;
    String shopState = '';
    String offDay = '';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String vendorDocId = preferences.getString('vendorDocId') ?? '';
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorDocId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          openHour = documentSnapshot['openTime.${'hour'}'];
          openMinute = documentSnapshot['openTime.${'minute'}'];
          closeHour = documentSnapshot['closeTime.${'hour'}'];
          closeMinute = documentSnapshot['closeTime.${'minute'}'];
          approved = documentSnapshot['approved'];
          shopState = documentSnapshot['shopState'];
          offDay = documentSnapshot['weeklyOffDay'].toString();
        });
      } else {
        print('Document does not exist on the database');
        //closeee
      }
    });
    bool result = true;
    DateTime currentTime = DateTime.now();
    DateTime openTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, openHour, openMinute);
    DateTime closeTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, closeHour, closeMinute);

    bool isCurrentTimeBetween = isTimeBetween(currentTime, openTime, closeTime);
    if (isCurrentTimeBetween == true &&
        shopState.toString().toLowerCase() == 'open' &&
        isWeekendnn(DateTime.now(), offDay) == false &&
        isWeekendnn(selectedDate, offDay) == false) {
      if (approved) {
        setState(() {
          result = false;
        });
      } else {
        Fluttertoast.showToast(msg: 'Shop is not approved!');
        setState(() {
          result = true;
        });
      }
    } else {
      setState(() {
        result = true;
      });
    }
    return result;
  }

  bool isWeekendnn(DateTime date, String offDay) {
    DateTime tempDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(date.toString());
    DateFormat dateFormat = DateFormat("EEE");
    String string = dateFormat.format(tempDate);
    print(string);
    if (string.toLowerCase() == offDay.toLowerCase()) return true;
    return false;
  }

  Future<bool> availabiltyCheck() async {
    bool result = true;
    for (var element in MyCart.cartList) {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(element.productId)
          .get()
          .then((value) {
        if (value.exists) {
          setState(() {
            if (value['availableInStock'] == false) {
              setState(() {
                result = false;
              });
              print("fgggf ${value['availableInStock']}  $result");
            }
          });
        } else {
          /* Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
                  (context)=>ShopSearchScreen(willPop: true,)), (route) => false);*/
          //closeee
        }
      });
    }
    print('rrreeess  ' + result.toString());
    return result;
  }

  getCartList() async {
    double totalAmount = 0;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cartString = await prefs.getString('cartList') ?? 'null';
    setState(() {
      if (cartString != 'null') {
        MyCart.cartList = CartModel.decode(cartString);
        totalItems = MyCart.cartList.length;
        DashBoardScreen.cartValueNotifier
            .updateNotifier(MyCart.cartList.length);
      }
    });
    if (MyCart.cartList.isNotEmpty) {
      MyCart.cartList.forEach((element) {
        setState(() {
          FirebaseFirestore.instance
              .collection('products')
              .doc(element.productId)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                totalAmount += (double.parse(value['salesPrice'].toString()) *
                    element.productQuantity);
                items.addAll({'${value['sku']}': element.productQuantity});
                DashBoardScreen.cartTotalNotifier.updateNotifier(totalAmount);
              });
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopSearchScreen(
                            willPop: true,
                          )),
                  (route) => false);
              //closeee
            }
          });
        });
      });
    }

    getShopTiming();
  }

  String offDay = '';
  String openTime = '';
  String closeTime = '';
  String shopName = '';
  getShopTiming() async {
    print('hhhh000000');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String vendorDocId = preferences.getString('vendorDocId') ?? '';
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorDocId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          offDay = documentSnapshot['weeklyOffDay'].toString();
          shopName = documentSnapshot['shopName'].toString();
          openTime = documentSnapshot['openTime.${'hour'}'].toString();
          closeTime = documentSnapshot['closeTime.${'hour'}'].toString();
          if (isWeekend(DateTime.now()) == false) {
            print('FGGGG');
            if (DateTime.now().hour < int.parse(closeTime) &&
                DateTime.now().hour > int.parse(openTime)) {
              print('object1');
              setState(() {
                selectedDate = DateTime.now();
                selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: 00);
              });
            } else if (DateTime.now().hour < int.parse(closeTime) &&
                DateTime.now().hour < int.parse(openTime)) {
              print('object2');
              setState(() {
                selectedDate = DateTime.now();
                selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
              });
            } else if (DateTime.now().hour > int.parse(closeTime)) {
              print('object3');
              setState(() {
                selectedDate = DateTime.now().add(const Duration(days: 1));
                selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
              });
            } else {
              print('object4');
              setState(() {
                selectedDate = DateTime.now().add(const Duration(days: 1));
                selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
              });
            }
          } else {
            print('yGGGG');
            setState(() {
              selectedDate = DateTime.now().add(const Duration(days: 1));
              selectedTime = TimeOfDay(hour: int.parse(openTime), minute: 00);
            });
          }
        });
      } else {
        print('Document does not exist on the database');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ShopSearchScreen(
                      willPop: true,
                    )),
            (route) => false);
        //closeee
      }
    });
    setState(() {
      getSlotList();
      loaded = true;
    });
  }

  getDeliveryCharge() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String vendorDocId = preferences.getString('vendorDocId') ?? '';
    FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorDocId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          deliverToAddress =
              documentSnapshot['deliveryDetails.${'deliveryToAddress'}'];
          selectedOption = 'address';

          deliveryCharge = double.parse(
              documentSnapshot['deliveryDetails.${'deliveryCharges'}']
                  .toString());

          deliveringService =
              documentSnapshot['deliveryDetails.${'deliveryBy'}'].toString();
          deliveryChargeSelected = deliveryCharge;
          bhaAppCharges =
              double.parse(documentSnapshot['BhaAppCharges'].toString());
          minOrderValue =
              double.parse(documentSnapshot['minOrderValue'].toString());
          print('MMINN OORDDERRRR value   $minOrderValue');
        });
      } else {
        //closeee
        print('Document does not exist on the database');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ShopSearchScreen(
                      willPop: true,
                    )),
            (route) => false);
      }
    });
  }

  double getBhaAppCharges(double cartAmount) {
    if (cartAmount <= 500) {
      return 12.0;
    } else {
      // Calculate 2.5% of the amount and round it to 2 decimal places
      double fee = (cartAmount * 0.025).roundToDouble();
      print('cartAmount: $cartAmount fee is $fee');
      return fee;
    }
  }

  clearCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      MyCart.cartList.clear();
      DashBoardScreen.cartValueNotifier.updateNotifier(0);
      prefs.remove('cartList');
    });
    // prefs.setString('cartList',CartModel.encode(MyCart.cartList));
  }

  getDeliveryAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? addressId;
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        addressId = value['defualtAddressId'].toString();
      });
    });
    await FirebaseFirestore.instance
        .collection('customers')
        .doc(uid)
        .collection('customerAddresses')
        .doc(addressId)
        .get()
        .then((DocumentSnapshot doc) {
      setState(() {
        addressModel = AddressModel(
            name: doc['name'],
            mobile: doc['mobile'],
            email: doc['email'],
            country: doc['country'],
            address: doc['address'],
            type: doc['type'],
            id: doc.id.toString(),
            pinCode: doc['pinCode'],
            latitude: doc['latitude'],
            longitude: doc['longitude']);
      });
    });
  }

  getPickupPoints() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String vendorDocId = preferences.getString('vendorDocId') ?? '';
    await FirebaseFirestore.instance
        .collection('vendors')
        .doc(vendorDocId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          pickupPoints = documentSnapshot['deliveryDetails.${'pickupPoints'}']
              .cast<String>();
          selectedPickupPoint = pickupPoints[0];
        });
      } else {
        print('Document does not exist on the database');
        //closeee
      }
      print('SIVA: Pickup points: $pickupPoints');
    });
  }

  getSlotList() {
    int hour = DateTime.now().hour;
    if (DateFormat('d MMM y').format(selectedDate) ==
        DateFormat('d MMM y').format(DateTime.now())) {
      if (hour <= 7) {
        setState(() {
          timeSlots = ['8 AM to 11 AM', '12 PM to 3 PM', '7 PM to 10 PM'];
          selectedTimeSlot = timeSlots[0];
        });
      } else if (hour <= 11) {
        setState(() {
          timeSlots = ['12 PM to 3 PM', '7 PM to 10 PM'];
          selectedTimeSlot = timeSlots[0];
        });
      } else if (hour <= 18) {
        setState(() {
          timeSlots = ['7 PM to 10 PM'];
          selectedTimeSlot = timeSlots[0];
        });
      } else {
        timeSlots = [''];
        selectedTimeSlot = timeSlots[0];
      }
    } else {
      setState(() {
        timeSlots = ['8 AM to 11 AM', '12 PM to 3 PM', '7 PM to 10 PM'];
        selectedTimeSlot = timeSlots[0];
      });
    }
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
      if (isWeekend(picked)) {
        Fluttertoast.showToast(
            msg:
                'Shop is closed on the selected day,please choose another date');
      } else {
        setState(() {
          selectedDate = picked;
          getSlotList();
        });
      }
    }
  }

  bool isWeekend(DateTime date) {
    DateTime tempDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(date.toString());
    DateFormat dateFormat = DateFormat("EEE");
    String string = dateFormat.format(tempDate);
    print(string);
    if (string.toLowerCase() == offDay.toLowerCase()) return true;
    return false;
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dialOnly);
    if (picked != null) {
      if (picked.hour > int.parse(closeTime) ||
          picked.hour < int.parse(openTime)) {
        Fluttertoast.showToast(
            msg:
                'Shop is closed on the selected time,please choose another time');
      } else {
        setState(() {
          selectedTime = picked;
        });
      }
    }
  }

  onUpDate() async {
    double totalAmount = 0;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String cartString = await prefs.getString('cartList') ?? 'null';
    setState(() {
      if (cartString != 'null') {
        MyCart.cartList = CartModel.decode(cartString);
        totalItems = MyCart.cartList.length;
        DashBoardScreen.cartValueNotifier
            .updateNotifier(MyCart.cartList.length);
      }
    });
    if (MyCart.cartList.isNotEmpty) {
      MyCart.cartList.forEach((element) {
        setState(() {
          FirebaseFirestore.instance
              .collection('products')
              .doc(element.productId)
              .get()
              .then((value) {
            if (value.exists) {
              setState(() {
                totalAmount += (double.parse(value['salesPrice'].toString()) *
                    element.productQuantity);
                items.addAll({'${value['sku']}': element.productQuantity});
                DashBoardScreen.cartTotalNotifier.updateNotifier(totalAmount);
              });
            } else {
              //closeee
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShopSearchScreen(
                            willPop: true,
                          )),
                  (route) => false);
            }
          });
        });
      });
    }
  }
}
