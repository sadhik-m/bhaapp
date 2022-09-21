import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:bhaapp/shop_search/model/vendorModel.dart';
import 'package:bhaapp/shop_search/view/shop_result_screen.dart';
import 'package:bhaapp/shop_search/view/widgets/shop_list_dropdown.dart';
import 'package:bhaapp/shop_search/view/widgets/shop_listview_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/constants/colors.dart';

class ShopSearchVendorId extends StatefulWidget {
  List<VendorModel> vendorList=[];
   ShopSearchVendorId({Key? key,required this.vendorList}) : super(key: key);

  @override
  State<ShopSearchVendorId> createState() => _ShopSearchVendorIdState();
}

class _ShopSearchVendorIdState extends State<ShopSearchVendorId> {

  List<VendorModel> searchList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void searchOperation(String searchText) {
    setState(() {
      searchList.clear();

      for (int i = 0; i < widget.vendorList.length; i++) {
        if (widget.vendorList[i].vendorId.toLowerCase().contains(searchText.toLowerCase())) {
          searchList.add(widget.vendorList[i]);
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Container(
          height: screenHeight*0.07,
          width: screenWidth,
          padding: EdgeInsets.only(
              top: screenHeight*0.01
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: screenWidth,
                height: screenHeight*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(color: border_grey.withOpacity(0.1)),
                    color: fill_grey.withOpacity(0.1)
                ),
                child: TextField(
                  autofocus: true,
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
        ),

      ),
      body:Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
            vertical: screenHeight*0.04
        ),
        child: Column(
          children: [
            searchList.isEmpty?
            Center(
              child: Text('Nothing Found!'),
            ):
            Expanded(child: ShopListView(screenWidth,screenHeight,
                context,searchList))
          ],
        ),
      )

    );
  }

}
