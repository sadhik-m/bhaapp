import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDetail extends StatelessWidget {
  const CategoryDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("Fruits & Vegetables",
          [Padding(
            padding: const EdgeInsets.only(right:18.0),
            child: Image.asset('assets/home/search.png',color: Colors.black,
            height: 24,width: 24,),
          )],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight*0.08,
              decoration: BoxDecoration(
                color: splashBlue.withOpacity(0.1)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/home/Vector-2.png',
                  color: Colors.black,height: screenHeight*0.025,),
                  SizedBox(width: screenWidth*0.02,),
                  Text('Sort by',style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black
                  ),),
                  SizedBox(width: screenWidth*0.08,),
                  Container(
                    height: screenHeight*0.03,
                    width: screenWidth*0.005,
                    color: splashBlue,
                  ),
                  SizedBox(width: screenWidth*0.09,),
                  Image.asset('assets/home/Group 60.png',
                    color: Colors.black,height: screenHeight*0.025,),
                  SizedBox(width: screenWidth*0.02,),
                  Text('Filter',style: GoogleFonts.inter(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: Colors.black
                  ),),
                ],
              ),
            ),
            SizedBox(height: screenHeight*0.02,),
            Expanded(child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth*0.04,
                ),
                width: screenWidth,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.spaceBetween,
                  runSpacing: 20,

                  children: List.generate(10, (index) => productTile(screenHeight,screenWidth,
                      (){Navigator.pushNamed(context, '/product_detail');})),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
