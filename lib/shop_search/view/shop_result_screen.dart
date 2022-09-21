import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/shop_search/view/widgets/shop_list_dropdown.dart';
import 'package:bhaapp/shop_search/view/widgets/shop_listview_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/vendorModel.dart';

class ShopResult extends StatefulWidget {
  List<VendorModel> vendorList=[];
   ShopResult({Key? key,required this.vendorList}) : super(key: key);

  @override
  State<ShopResult> createState() => _ShopResultState();
}

class _ShopResultState extends State<ShopResult> {
  List<VendorModel> resultList=[];
  bool loaded=false;
  getResultList()async{
    widget.vendorList.forEach((element) {
      if(element.category==selectedCategory){
        setState(() {
          resultList.add(element);
        });
      }
    });
    setState(() {
      loaded=true;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResultList();
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
      ):  Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.only(
          top: screenHeight*0.03,
          left: screenWidth*0.08,
          right: screenWidth*0.08
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedCategory!,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black
            ),),
            SizedBox(height: screenHeight*0.025,),
            resultList.isEmpty?
            Center(
              child: Padding(
                padding:  EdgeInsets.only(top:screenHeight*0.3),
                child: Text("Nothing Found!"),
              ),
            ):
            Expanded(child: ShopListView(screenWidth,screenHeight,
                context,resultList))
          ],
        ),
      ),
    );
  }
}
