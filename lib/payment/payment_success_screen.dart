import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/order/my_orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dashboard/dash_board_screen.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({Key? key}) : super(key: key);

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBar('', [], false),
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

                ],
              ),
              Container(),

              blackButton("View my Orders", (){
                setState(() {
                  pageIndex=1;
                });
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()), (route) => false);
              }, screenWidth, screenHeight*0.05),
            ],
          ),
        )
    );
  }
}
