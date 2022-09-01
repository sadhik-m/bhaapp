import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/register/view/widget/country_picker.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:bhaapp/shop_search/view/widgets/shop_list_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopSearchScreen extends StatefulWidget {
  const ShopSearchScreen({Key? key}) : super(key: key);

  @override
  State<ShopSearchScreen> createState() => _ShopSearchScreenState();
}

class _ShopSearchScreenState extends State<ShopSearchScreen> {
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
                        dropdownvalue=v;
                      });
                    }
                ),
                Padding(
                  padding:  EdgeInsets.only(top:0.0),
                  child: Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            blackButton('View Shops', (){
              Navigator.pushNamed(context, '/shop_result');
            }, screenWidth, screenHeight*0.05
            )
          ],
        ),
      ),
    );
  }
}
