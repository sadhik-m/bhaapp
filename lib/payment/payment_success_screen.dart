import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/order/my_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar('', [], true),
        body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth*0.05,
            vertical: screenHeight*0.01

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Image.asset('assets/home/Frame.png',
              height: screenHeight*0.3,),
              Column(
                children: [
                  Text("Payment\nSuccessful",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 26,
                    color: Colors.black
                  ),),
                  SizedBox(height: 8,),
                  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas viverra sollicitudin nibh vel vestibulum. Aenean magna purus, dignissim consectetur ullamcorper nec, consectetur scelerisque eros.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black.withOpacity(0.3)
                    ),)
                ],
              ),
              Container(),

              blackButton("View my Orders", (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderScreen(show_back: true,)));
              }, screenWidth, screenHeight*0.05),
            ],
          ),
        )
    );
  }
}
