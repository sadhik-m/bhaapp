import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:bhaapp/shop_search/model/vendorModel.dart';
import 'package:bhaapp/shop_search/view/shopSerachVendorId.dart';
import 'package:bhaapp/shop_search/view/shop_result_screen.dart';
import 'package:bhaapp/shop_search/view/widgets/shopTile.dart';
import 'package:bhaapp/shop_search/view/widgets/shop_list_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/constants/colors.dart';
import '../../dashboard/dash_board_screen.dart';
import '../../home/model/vendorShopModel.dart';
import '../../product/model/cartModel.dart';

class ShopSearchScreen extends StatefulWidget {
  bool willPop;
   ShopSearchScreen({Key? key,required this.willPop}) : super(key: key);

  @override
  State<ShopSearchScreen> createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {

  List<VendorShopModel> vendorInitialList=[];
  List<VendorShopModel> vendorSearchList=[];
  List<VendorShopModel> vendorTypeList=[];
  List<String> categoryList=[];
  bool loaded=false;
  String ? selectedShopType;
  var searchController=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitialList();
  }

  DateTime ? currentBackPressTime;
  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if(widget.willPop){
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Press back again to exit');
        return Future.value(false);
      }
    }
    return Future.value(true);
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
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
            Image.asset('assets/authentication/app_logo_old(1) 1-2.png',
              width: screenWidth*0.2,
            ),
            Text('Find Shop',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20
              ),),
            Container(
              width: screenWidth*0.2,
            )

          ],
        ),
      ),
      body:WillPopScope(
        onWillPop: onWillPop,
        child:loaded==false?
        const Center(
          child: Text("Loading..."),
        ): Container(
          height: screenHeight,
          width: screenWidth,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth*0.04,
             // vertical: screenHeight*0.01
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight*0.01,),
                SizedBox(
                  height: screenHeight*0.05,
                  child: Row(
                    children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(0),
                          itemCount: categoryList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context,i){
                        return Padding(
                          padding:  EdgeInsets.only(left: screenWidth*0.03),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                selectedShopType=categoryList[i];
                                changeShopType(selectedShopType!);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth*0.02),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                                  border: Border.all(color:selectedShopType==categoryList[i]?Colors.transparent: Colors.grey),
                                  color: selectedShopType==categoryList[i]?splashBlue.withOpacity(0.2):Colors.white
                              ),
                              child: Center(
                                child: Text(categoryList[i],
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                      color:selectedShopType==categoryList[i]?splashBlue: Colors.grey
                                  ),),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight*0.03,),
                Container(
                  width: screenWidth,
                  height: screenHeight*0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      border: Border.all(color: border_grey.withOpacity(0.1)),
                      color: fill_grey.withOpacity(0.1)
                  ),
                  child: TextField(
                    readOnly: false,
                    controller: searchController,
                    onChanged: searchOperation,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(top:screenHeight*0.015),
                      prefixIcon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/home/search.png',
                            height: screenHeight*0.03,
                          ),
                        ],
                      ),
                      hintText: 'Search by ID,Name Or Category',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.5)
                      ),
                    ),
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.03,),
                Divider(thickness: 1,color: Colors.black.withOpacity(0.7),),
                SizedBox(height: screenHeight*0.03,),
                vendorSearchList.isNotEmpty?
                ListView.builder(
                    itemCount: vendorSearchList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                      return InkWell(
                        onTap: (){
                          saveVendorId(vendorSearchList[index].vendorId,context,vendorSearchList[index].vendorDocId);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(6.0)),
                              child: Container(
                                width: 1000.0,
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image:  DecorationImage(
                                    fit: BoxFit.cover,
                                    colorFilter:
                                    ColorFilter.mode(Colors.black.withOpacity(0.5),
                                        BlendMode.dstATop),
                                    image:  NetworkImage(
                                      vendorSearchList[index].image ,
                                    ),

                                  ),

                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.04,vertical: screenHeight*0.01),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(vendorSearchList[index].shopName,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white,
                                                fontSize: 18
                                            ),),
                                          SizedBox(height: screenHeight*0.003,),
                                          Text(vendorSearchList[index].address,
                                            style: GoogleFonts.inter(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                                fontSize: 12
                                            ),),
                                          SizedBox(height: screenHeight*0.01,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset('assets/home/clock.png',
                                                    width: 14,height: 14,),
                                                  SizedBox(width: screenWidth*0.013,),
                                                  Text('${vendorSearchList[index].openTime} AM - ${vendorSearchList[index].closeTime} PM',
                                                    style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w400,
                                                        fontSize: 10
                                                    ),)
                                                ],
                                              ),

                                            ],
                                          ),
                                          SizedBox(height: screenHeight*0.01,),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      );
                    }):
                vendorSearchList.isEmpty && searchController.text.isNotEmpty?
                const Center(
                  child: Text("Nothing Found!"),
                ):
                vendorTypeList.isEmpty?
                const Center(
                  child: Text("Nothing Found!"),
                ):
                ListView.builder(
                  itemCount: vendorTypeList.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){
                  return InkWell(
                    onTap: (){
                      saveVendorId(vendorTypeList[index].vendorId,context,vendorTypeList[index].vendorDocId);
                    },
                    child: ShopDataListTile(
                      vendorTypeList: vendorTypeList[index],
                      screenHeight: screenHeight,
                      screenWidth: screenWidth,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      )
    );
  }

  loadInitialList()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String ? uid=prefs.getString('uid');
    String ? addressId;
    String ? pinCode;
    await FirebaseFirestore.instance.collection('customers').doc(uid).get().then((value) {
      setState(() {
        addressId=value['defualtAddressId'].toString();
      });
    });
    await FirebaseFirestore.instance.collection('customers').doc(uid).collection('customerAddresses').doc(addressId).get()
        .then((DocumentSnapshot doc) {

      setState(() {
        pinCode=doc['pinCode'];
      });

    });
    categoryList.add('All');
    await FirebaseFirestore.instance
        .collection('vendors').where('deliveryAreas',arrayContains: '560064')//pinCode)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
          setState(() {
            vendorInitialList.add(
                VendorShopModel(
                    vendorId: doc['vendorId'],
                    shopName: doc['shopName'],
                    vendorDocId: doc.id.toString(),
                    image: doc['shopImage'],
                    address: doc['address'],
                    closeTime: "${doc['closeTime.${'hour'}']}:${doc['closeTime.${'minute'}']}",
                    openTime: "${doc['openTime.${'hour'}']}:${doc['openTime.${'minute'}']}",
                    phone: doc['mobile'],
                    email: doc['email'],
                shopType: doc['shopType'])
            );
            if(categoryList.contains(doc['shopType'])){
              print('Already Added');
            }else{
              categoryList.add(doc['shopType']);
            }
          });
      });
    });
    setState(() {
      vendorTypeList=List.from(vendorInitialList);
      selectedShopType=categoryList[0];
      loaded=true;
    });
  }
  changeShopType(String type)async{
    setState(() {
      loaded=false;
      vendorSearchList.clear();
      searchController.clear();
      vendorTypeList.clear();
    });
   if(type=='All'){
     setState(() {
       vendorTypeList=List.from(vendorInitialList);
     });
   }else{
     vendorInitialList.forEach((element) {
       if(element.shopType==type){
         vendorTypeList.add(element);
       }
     });
   }
    setState(() {
      loaded=true;
    });
  }
  void searchOperation(String searchText) {
    setState(() {
      vendorSearchList.clear();

      if(searchText.isNotEmpty){
        for (int i = 0; i < vendorInitialList.length; i++) {
          if (vendorInitialList[i].vendorId.toLowerCase().contains(searchText.toLowerCase()) ||
              vendorInitialList[i].shopName.toLowerCase().contains(searchText.toLowerCase()) ||
              vendorInitialList[i].shopType.toLowerCase().contains(searchText.toLowerCase())) {
            vendorSearchList.add(vendorInitialList[i]);
          }
        }
      }
      print("SEARCH   ${vendorSearchList.length}");
    });

  }

  saveVendorId(String vendorIds,BuildContext context,String vendorDocId)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    vendorId=vendorIds;
    preferences.setString('vendorId', vendorIds);
    preferences.setString('vendorDocId', vendorDocId);
    preferences.setString('cartList',CartModel.encode([]));
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
        (context)=>DashBoardScreen()), (route) => false);
  }
}
