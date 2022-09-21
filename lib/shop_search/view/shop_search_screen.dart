import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:bhaapp/shop_search/model/vendorModel.dart';
import 'package:bhaapp/shop_search/view/shopSerachVendorId.dart';
import 'package:bhaapp/shop_search/view/shop_result_screen.dart';
import 'package:bhaapp/shop_search/view/widgets/shop_list_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

class ShopSearchScreen extends StatefulWidget {
  const ShopSearchScreen({Key? key}) : super(key: key);

  @override
  State<ShopSearchScreen> createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {

  List<VendorModel> vendorList=[];
  List<String> categoryList=[];
  bool loaded=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadVendorList();
  }


  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Shop Search', [],true),
      body: loaded==false?
          Center(
            child: Text("Loading..."),
          ): Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.04
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text('Facility to open a specific shop by\ngiving “Vendor ID or Category”',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.8)
                ),
                textAlign: TextAlign.center,),
                SizedBox(height: screenHeight*0.06,),
                shopDropDown(
                    (v){
                      setState(() {
                        selectedCategory=v;
                      });
                    },categoryList
                ),
                Padding(
                  padding:  EdgeInsets.only(top:0.0),
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: screenHeight*0.03,),
                Text("OR"),
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
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopSearchVendorId(vendorList: vendorList,)));
                    },
                    readOnly: true,
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
                      hintText: 'Search by Vendor ID',
                      hintStyle: GoogleFonts.inter(
                          fontSize: 14,
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

              ],
            ),
            blackButton('View Shops', (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ShopResult(vendorList: vendorList)));
            }, screenWidth, screenHeight*0.05
            )
          ],
        ),
      ),
    );
  }

  loadVendorList()async{
    await FirebaseFirestore.instance
        .collection('vendors')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
          setState(() {
            vendorList.add(
                VendorModel(vendorId: doc['vendorId'], shopName: doc['shopName'],
                    category: doc['loadProductType'],address: doc['address'])
            );
          });
      });
    });
    await FirebaseFirestore.instance
        .collection('subCategories')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          categoryList.add(
              doc['subCatName']
          );
        });
      });
    });
    setState(() {
      selectedCategory=categoryList[0];
      loaded=true;
    });
  }
}
