import 'dart:math';

import 'package:bhaapp/shop_search/view/widgets/shopTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../address/model/addressModel.dart';
import '../../common/constants/colors.dart';
import '../../dashboard/dash_board_screen.dart';
import '../../home/model/vendorShopModel.dart';
import '../../home/service/profilePicService.dart';
import '../../home/widget/main_banner.dart';
import '../../home/widget/small_banner.dart';
import '../../order/order_detail_screen.dart';
import '../../order/order_summary_screen.dart';
import '../../product/model/cartModel.dart';

class ShpSearchListScreen extends StatefulWidget {
  const ShpSearchListScreen({Key? key}) : super(key: key);

  @override
  _ShpSearchListScreenState createState() => _ShpSearchListScreenState();
}

class _ShpSearchListScreenState extends State<ShpSearchListScreen> {
  List<VendorShopModel> vendorInitialList = [];
  List<VendorShopModel> vendorSearchList = [];
  List<VendorShopModel> vendorTypeList = [];
  List<String> categoryList = [];
  bool loaded = false;
  String? selectedShopType;
  var searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeliveryAddress();
    loadInitialList();
  }

  Future<void> _pullRefresh() async {
    await Future.delayed(Duration(seconds: 3));
    vendorInitialList = [];
    vendorSearchList = [];
    vendorTypeList = [];
    categoryList = [];
    loaded = false;
    getDeliveryAddress();
    loadInitialList();
  }

  String userid = '';
  AddressModel? addressModel;
  getDeliveryAddress() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    userid = prefs.getString('uid') ?? '';
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

  bool recentloaded = false;
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/dashboard/BhaApp_logo_NoBG_1.png',
                width: screenWidth * 0.2,
              ),
              Text(
                'Find Shop',
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 20),
              ),
              InkWell(
                onTap: () {
                  vendorInitialList = [];
                  vendorSearchList = [];
                  vendorTypeList = [];
                  categoryList = [];
                  loaded = false;
                  getDeliveryAddress();
                  loadInitialList();
                },
                child: Text(
                  'Refresh',
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      fontSize: 14),
                ),
              ),
              /*FutureBuilder<String>(
              future: ProfPic().getProfPic(),
              builder:
                  (BuildContext context, AsyncSnapshot snapshot) {


                if (snapshot.hasData) {
                  return snapshot.data.toString()!=''?
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black,
                        image: DecorationImage(
                            image: NetworkImage(snapshot.data.toString()),fit: BoxFit.fill)
                    ),
                  ):
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Icon(Icons.person,color: Colors.white,),
                    ),
                  );
                }

                return Center(child:Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Icon(Icons.person,color: Colors.white,),
                  ),
                ));
              },
            )*/
            ],
          ),
        ),
        body: loaded == false
            ? const Center(
                child: Text("Loading..."),
              )
            : RefreshIndicator(
                onRefresh: _pullRefresh,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    // vertical: screenHeight*0.01
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        addressModel == null
                            ? SizedBox.shrink()
                            : InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                          context, '/change_address')
                                      .then((value) {
                                    setState(() {
                                      getDeliveryAddress();
                                    });
                                  });
                                },
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on_sharp,
                                      color: Colors.red,
                                      size: 29,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Selected Address',
                                              style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Icon(
                                              Icons.keyboard_arrow_down_sharp,
                                              color: Colors.black,
                                              size: 19,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: screenWidth * 0.65,
                                          child: Text(
                                            '${addressModel!.address},${addressModel!.country.toString().toUpperCase()},Ph : ${addressModel!.mobile}',
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,
                                                color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          height: screenHeight * 0.029,
                        ),
                        smallBanner(),
                        SizedBox(
                          height: screenHeight * 0.019,
                        ),
                        vendorInitialList.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: Text(
                                      "No shop available on your default address,change your address and try again!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                                context, '/change_address')
                                            .then((value) {
                                          setState(() {
                                            print("JUIOP");
                                            loaded = false;
                                            loadInitialList();
                                          });
                                        });
                                      },
                                      child: Text('Change Address'))
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Shops in Your Area',
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.019,
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.05,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                              padding: EdgeInsets.all(0),
                                              itemCount: categoryList.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, i) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                      left: screenWidth * 0.03),
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedShopType =
                                                            categoryList[i];
                                                        changeShopType(
                                                            selectedShopType!);
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  screenWidth *
                                                                      0.02),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      12)),
                                                          border: Border.all(
                                                              color: selectedShopType ==
                                                                      categoryList[
                                                                          i]
                                                                  ? Colors
                                                                      .transparent
                                                                  : Colors
                                                                      .grey),
                                                          color: selectedShopType ==
                                                                  categoryList[
                                                                      i]
                                                              ? splashBlue
                                                                  .withOpacity(
                                                                      0.2)
                                                              : Colors.white),
                                                      child: Center(
                                                        child: Text(
                                                          categoryList[i],
                                                          style: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 12,
                                                              color: selectedShopType ==
                                                                      categoryList[
                                                                          i]
                                                                  ? splashBlue
                                                                  : Colors
                                                                      .grey),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Container(
                                    width: screenWidth,
                                    height: screenHeight * 0.06,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4)),
                                        border: Border.all(
                                            color:
                                                border_grey.withOpacity(0.1)),
                                        color: fill_grey.withOpacity(0.1)),
                                    child: TextField(
                                      readOnly: false,
                                      controller: searchController,
                                      onChanged: searchOperation,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.only(
                                            top: screenHeight * 0.015),
                                        prefixIcon: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/home/search.png',
                                              height: screenHeight * 0.03,
                                            ),
                                          ],
                                        ),
                                        hintText:
                                            'Search by Vendor ID,Name Or Category',
                                        hintStyle: GoogleFonts.inter(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                      style: GoogleFonts.inter(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  Divider(
                                    thickness: 1,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.03,
                                  ),
                                  vendorSearchList.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: vendorSearchList.length,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.all(0),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () async {
                                                if (vendorSearchList[index]
                                                        .approved ==
                                                    false) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Shop is not approved!');
                                                } else {
                                                  bool isClosed =
                                                      await checkShopClosed(
                                                          vendorSearchList[
                                                                  index]
                                                              .vendorDocId);
                                                  if (isClosed) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Shop is closed now!');
                                                  } else {
                                                    if (DashBoardScreen
                                                            .cartValueNotifier
                                                            .cartValueNotifier
                                                            .value !=
                                                        0) {
                                                      showVendorDialog(
                                                          context,
                                                          vendorSearchList[
                                                                  index]
                                                              .vendorId,
                                                          vendorSearchList[
                                                                  index]
                                                              .vendorDocId,
                                                          vendorSearchList[
                                                                  index]
                                                              .shopType,
                                                          vendorSearchList[
                                                                  index]
                                                              .device_id);
                                                    } else {
                                                      saveVendorId(
                                                          vendorSearchList[
                                                                  index]
                                                              .vendorId,
                                                          context,
                                                          vendorSearchList[
                                                                  index]
                                                              .vendorDocId,
                                                          vendorSearchList[
                                                                  index]
                                                              .shopType,
                                                          vendorSearchList[
                                                                  index]
                                                              .device_id);
                                                    }
                                                  }
                                                }
                                              },
                                              child: ShopDataListTile(
                                                vendorTypeList:
                                                    vendorSearchList[index],
                                                screenHeight: screenHeight,
                                                screenWidth: screenWidth,
                                              ),
                                            );
                                          })
                                      : vendorSearchList.isEmpty &&
                                              searchController.text.isNotEmpty
                                          ? const Center(
                                              child: Text("Nothing Found!"),
                                            )
                                          : vendorTypeList.isEmpty
                                              ? const Center(
                                                  child: Text("Nothing Found!"),
                                                )
                                              : ListView.builder(
                                                  itemCount:
                                                      vendorTypeList.length,
                                                  shrinkWrap: true,
                                                  padding: EdgeInsets.all(0),
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index) {
                                                    return InkWell(
                                                      onTap: () async {
                                                        if (vendorTypeList[
                                                                    index]
                                                                .approved ==
                                                            false) {
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  'Shop is not approved!');
                                                        } else {
                                                          bool isClosed =
                                                              await checkShopClosed(
                                                                  vendorTypeList[
                                                                          index]
                                                                      .vendorDocId);
                                                          if (isClosed) {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Shop is closed now!');
                                                          } else {
                                                            if (DashBoardScreen
                                                                    .cartValueNotifier
                                                                    .cartValueNotifier
                                                                    .value !=
                                                                0) {
                                                              showVendorDialog(
                                                                  context,
                                                                  vendorTypeList[
                                                                          index]
                                                                      .vendorId,
                                                                  vendorTypeList[
                                                                          index]
                                                                      .vendorDocId,
                                                                  vendorTypeList[
                                                                          index]
                                                                      .shopType,
                                                                  vendorTypeList[
                                                                          index]
                                                                      .device_id);
                                                            } else {
                                                              saveVendorId(
                                                                  vendorTypeList[
                                                                          index]
                                                                      .vendorId,
                                                                  context,
                                                                  vendorTypeList[
                                                                          index]
                                                                      .vendorDocId,
                                                                  vendorTypeList[
                                                                          index]
                                                                      .shopType,
                                                                  vendorTypeList[
                                                                          index]
                                                                      .device_id);
                                                            }
                                                          }
                                                        }
                                                      },
                                                      child: ShopDataListTile(
                                                        vendorTypeList:
                                                            vendorTypeList[
                                                                index],
                                                        screenHeight:
                                                            screenHeight,
                                                        screenWidth:
                                                            screenWidth,
                                                      ),
                                                    );
                                                  }),
                                ],
                              ),
                        SizedBox(
                          height: screenHeight * 0.019,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('orders')
                              .where('userId', isEqualTo: userid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return SizedBox.shrink();
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: EdgeInsets.only(top: 0),
                                child: Center(child: Text('Loading...')),
                              );
                            }
                            if (snapshot.data!.docs.isEmpty) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome to BhaApp! Start ordering now!',
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                        fontSize: 15),
                                  ),
                                ],
                              );
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recent Ordered Shops',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 16),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.019,
                                ),
                                SingleChildScrollView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                        snapshot.data!.docs.length, (index) {
                                      Map<String, dynamic> items =
                                          snapshot.data!.docs[index]['items']
                                              as Map<String, dynamic>;
                                      List<String> skuList = [];
                                      List<String> quantityList = [];
                                      items.forEach((key, value) {
                                        skuList.add(key.toString());
                                        quantityList.add(value.toString());
                                      });
                                      return snapshot.data!.docs[index]
                                                  ['status'] ==
                                              'Order Cancelled'
                                          ? SizedBox.shrink()
                                          : StreamBuilder<QuerySnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection('vendors')
                                                  .where('vendorId',
                                                      isEqualTo: snapshot
                                                              .data!.docs[index]
                                                          ['vendorId'])
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<QuerySnapshot>
                                                      snapshotShop) {
                                                if (snapshotShop.hasError) {
                                                  return SizedBox.shrink();
                                                }

                                                if (snapshotShop
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return SizedBox.shrink();
                                                }
                                                if (snapshotShop
                                                    .data!.docs.isEmpty) {
                                                  return SizedBox.shrink();
                                                }
                                                return InkWell(
                                                  onTap: () {
                                                    if (snapshot.data!
                                                                .docs[index]
                                                            ['status'] ==
                                                        'order delivered') {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      OrderSummary(
                                                                        orderid: snapshot
                                                                            .data!
                                                                            .docs[index]['orderId'],
                                                                        sku:
                                                                            skuList,
                                                                        quqntity:
                                                                            quantityList,
                                                                        shopContact: snapshotShop
                                                                            .data!
                                                                            .docs[0]['mobile'],
                                                                        orderStatus: snapshot
                                                                            .data!
                                                                            .docs[index]['status'],
                                                                        orderStatusDate: snapshot
                                                                            .data!
                                                                            .docs[index]['txTime'],
                                                                        shopName: snapshotShop
                                                                            .data!
                                                                            .docs[0]['shopName'],
                                                                        shopAddress: snapshotShop
                                                                            .data!
                                                                            .docs[0]['address'],
                                                                      )));
                                                    } else {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      OrderDetail(
                                                                        orderid: snapshot
                                                                            .data!
                                                                            .docs[index]['orderId'],
                                                                        shopName: snapshotShop
                                                                            .data!
                                                                            .docs[0]['shopName'],
                                                                        sku:
                                                                            skuList,
                                                                        quqntity:
                                                                            quantityList,
                                                                        shopContact: snapshotShop
                                                                            .data!
                                                                            .docs[0]['mobile'],
                                                                        orderStatus: snapshot
                                                                            .data!
                                                                            .docs[index]['status'],
                                                                        orderStatusDate: snapshot
                                                                            .data!
                                                                            .docs[index]['txTime'],
                                                                        deliveryAddress: snapshot
                                                                            .data!
                                                                            .docs[index]['deliveryAddress'],
                                                                        deliveryTime: snapshot
                                                                            .data!
                                                                            .docs[index]['deliveryTime'],
                                                                        orderTotal: snapshot
                                                                            .data!
                                                                            .docs[index]['orderAmount'],
                                                                      )));
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 4),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(4),
                                                      width: (screenWidth -
                                                              (screenWidth *
                                                                  0.12)) /
                                                          3,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: Colors.grey,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshotShop.data!
                                                                    .docs[0]
                                                                ['shopName'],
                                                            style: GoogleFonts.inter(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                          SizedBox(
                                                            height: 4,
                                                          ),
                                                          SingleChildScrollView(
                                                            child: Row(
                                                              children:
                                                                  List.generate(
                                                                      min(
                                                                          3,
                                                                          skuList
                                                                              .length),
                                                                      (index) {
                                                                return StreamBuilder<
                                                                    QuerySnapshot>(
                                                                  stream: FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'products')
                                                                      .where(
                                                                          'sku',
                                                                          isEqualTo:
                                                                              skuList[index])
                                                                      .snapshots(),
                                                                  builder: (BuildContext
                                                                          context,
                                                                      AsyncSnapshot<
                                                                              QuerySnapshot>
                                                                          snapshot) {
                                                                    if (snapshot
                                                                        .hasError) {
                                                                      return SizedBox
                                                                          .shrink();
                                                                    }

                                                                    if (snapshot
                                                                            .connectionState ==
                                                                        ConnectionState
                                                                            .waiting) {
                                                                      return SizedBox
                                                                          .shrink();
                                                                    }
                                                                    if (snapshot
                                                                        .data!
                                                                        .docs
                                                                        .isEmpty) {
                                                                      return SizedBox
                                                                          .shrink();
                                                                    }
                                                                    return Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              5),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            20,
                                                                        width:
                                                                            20,
                                                                        decoration: BoxDecoration(
                                                                            border:
                                                                                Border.all(color: Colors.grey),
                                                                            shape: BoxShape.circle,
                                                                            image: DecorationImage(image: NetworkImage(snapshot.data!.docs[0]['productImageUrl']), fit: BoxFit.cover)),
                                                                      ),
                                                                    );
                                                                  },
                                                                );
                                                              }),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                    }),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        SizedBox(
                          height: screenHeight * 0.019,
                        ),
                      ],
                    ),
                  ),
                ),
              ));
  }

  bool isTimeBetween(
      DateTime currentTime, DateTime startTime, DateTime endTime) {
    return currentTime.isAfter(startTime) && currentTime.isBefore(endTime);
  }

  Future<bool> checkShopClosed(String vendorDocId) async {
    int openHour = 0;
    int openMinute = 0;
    int closeHour = 0;
    int closeMinute = 0;
    bool approved = false;
    String shopState = '';
    String offDay = '';
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
        isWeekend(DateTime.now(), offDay) == false) {
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

  bool isWeekend(DateTime date, String offDay) {
    DateTime tempDate =
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(date.toString());
    DateFormat dateFormat = DateFormat("EEE");
    String string = dateFormat.format(tempDate);
    print(string);
    if (string.toLowerCase() == offDay.toLowerCase()) return true;
    return false;
  }

  loadInitialList() async {
    categoryList.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? addressId;
    String? pinCode;
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
        pinCode = doc['pinCode'];
        print('PPPPPPPPPPP $pinCode');
      });
    });
    categoryList.add('All');
    await FirebaseFirestore.instance
        .collection('vendors')
        .where('${'deliveryDetails'}.${'deliveryAreas'}',
            arrayContains: pinCode)
        .where('approved', isEqualTo: true) //pinCode)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          setState(() {
            vendorInitialList.add(VendorShopModel(
              vendorId: doc['vendorId'],
              shopName: doc['shopName'],
              vendorDocId: doc.id.toString(),
              image: doc['shopImage'],
              address: doc['address'],
              closeTime:
                  "${doc['closeTime.${'hour'}']}:${doc['closeTime.${'minute'}']}",
              openTime:
                  "${doc['openTime.${'hour'}']}:${doc['openTime.${'minute'}']}",
              phone: doc['mobile'],
              email: doc['email'],
              shopType: doc['shopType'],
              device_id: doc['device_id'],
              approved: doc['approved'],
            ));
            if (categoryList.contains(doc['shopType'])) {
              print('Already Added');
            } else {
              categoryList.add(doc['shopType']);
            }
          });
        }
      });
    });
    setState(() {
      vendorTypeList = List.from(vendorInitialList);
      selectedShopType = categoryList[0];
      loaded = true;
    });
  }

  changeShopType(String type) async {
    setState(() {
      loaded = false;
      vendorSearchList.clear();
      searchController.clear();
      vendorTypeList.clear();
    });
    if (type == 'All') {
      setState(() {
        vendorTypeList = List.from(vendorInitialList);
      });
    } else {
      vendorInitialList.forEach((element) {
        if (element.shopType == type) {
          vendorTypeList.add(element);
        }
      });
    }
    setState(() {
      loaded = true;
    });
  }

  void searchOperation(String searchText) {
    setState(() {
      vendorSearchList.clear();

      if (searchText.isNotEmpty) {
        for (int i = 0; i < vendorInitialList.length; i++) {
          if (vendorInitialList[i]
                  .vendorId
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              vendorInitialList[i]
                  .shopName
                  .toLowerCase()
                  .contains(searchText.toLowerCase()) ||
              vendorInitialList[i]
                  .shopType
                  .toLowerCase()
                  .contains(searchText.toLowerCase())) {
            vendorSearchList.add(vendorInitialList[i]);
          }
        }
      }
      print("SEARCH   ${vendorSearchList.length}");
    });
  }

  saveVendorId(String vendorIds, BuildContext context, String vendorDocId,
      String cateType, String device_id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    vendorId = vendorIds;
    preferences.setString('vendorId', vendorIds);
    preferences.setString('vendorDocId', vendorDocId);
    preferences.setString('vendorDeviceId', device_id);
    preferences.setString('categoryType', cateType);
    preferences.remove('favList');
    preferences.setString('cartList', CartModel.encode([]));
    pageIndex = 0;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen()),
        (route) => false);
  }

  showVendorDialog(BuildContext context, String vendorIds, String vendorDocId,
      String cateType, String devid) {
    Widget okButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        Navigator.of(context).pop();
        saveVendorId(vendorIds, context, vendorDocId, cateType, devid);
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
          borderRadius: BorderRadius.all(Radius.circular(16))),
      title: Text(
          "Changing the shop will clear the cart, Do you want to proceed?"),
      actions: [cancelButton, okButton],
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
