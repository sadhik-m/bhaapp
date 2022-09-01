import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/shop_search/view/widgets/shop_listview_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopResult extends StatelessWidget {
  const ShopResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Shop Search', [],true),
      body: Container(
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
            Text('Groceries and Vegetables',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black
            ),),
            SizedBox(height: screenHeight*0.025,),
            Expanded(child: ShopListView(screenWidth,screenHeight,
                (){
                  Navigator.pushNamed(context, '/dash');
                }))
          ],
        ),
      ),
    );
  }
}
