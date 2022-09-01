import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/payment/widget/expandable_tile.dart';
import 'package:bhaapp/register/view/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../common/constants/colors.dart';
class ChangePayment extends StatefulWidget {
  const ChangePayment({Key? key}) : super(key: key);

  @override
  State<ChangePayment> createState() => _ChangePaymentState();
}

class _ChangePaymentState extends State<ChangePayment> {
String ? upiSelected;
String ? walletSelected;
String ? acceptGuideline;

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Payment Methods', [], true),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.05,
            vertical: screenHeight*0.02),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Select Payment Option',style:
                          GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              fontSize: 14
                          ),)
                        ],
                      ),
                      SizedBox(height:screenHeight*0.03),
                      expandableTile(screenWidth, screenHeight,
                          "upi-2085056-1747946 1", "UPI",38,
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 3,

                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("UPI $index"),
                                      Radio(value: "UPI $index", groupValue: upiSelected,
                                          onChanged: (v){setState(() {
                                            upiSelected=v.toString();
                                          });})
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                      ),
                      Padding(
                        padding:  EdgeInsets.all(screenHeight*0.02),
                        child: Divider(color: Colors.black.withOpacity(0.2),),
                      ),
                      expandableTile(screenWidth, screenHeight,
                          "60378 1", "Debit/ Credit Card",26,
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.02),
                            child: Column(
                              children: [
                                SizedBox(height:screenHeight*0.015),
                                textField('Card Number', TextInputType.number, (value){}),
                                SizedBox(height:screenHeight*0.015),
                                textField('Card Holder Name', TextInputType.name, (value){}),
                                SizedBox(height:screenHeight*0.015),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: screenWidth*0.38,
                                        child: textField('MM/YY', TextInputType.number, (value){})),
                                    Container(
                                        width: screenWidth*0.38,
                                        child: textField('CVV', TextInputType.number, (value){})),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(value: 'guideline', groupValue: acceptGuideline, onChanged:(v){
                                      setState(() {
                                        acceptGuideline=v.toString();
                                      });
                                    }),

                                    Text("Secure my card",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.4)
                                    ),),
                                    Text(" as per RBI Guidelines",
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: splashBlue
                                      ),)
                                  ],
                                ),
                                SizedBox(height:screenHeight*0.015),
                                Container(
                                  width: screenWidth*0.35,
                                    height: screenHeight*0.06,
                                  decoration: BoxDecoration(
                                    color: splashBlue.withOpacity(0.2),
                                    borderRadius: BorderRadius.all(Radius.circular(4))
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Save Card',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,fontWeight: FontWeight.w600,color: splashBlue
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height:screenHeight*0.035),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset('assets/home/mc_symbol.png', height: 19,),
                                    SizedBox(width: screenWidth*0.05,),
                                    Image.asset('assets/home/visa-logo-800x450 1.png', height: 34,),
                                    SizedBox(width: screenWidth*0.05,),
                                    Image.asset('assets/home/Maestro_2016 1.png', height: 20,),
                                    SizedBox(width: screenWidth*0.05,),
                                    Image.asset('assets/home/1200px-American_Express_logo_(2018) 1.png', height: 21,),
                                  ],
                                )
                              ],
                            ),
                          )
                      ),
                      Padding(
                        padding:  EdgeInsets.all(screenHeight*0.02),
                        child: Divider(color: Colors.black.withOpacity(0.2),),
                      ),
                      expandableTile(screenWidth, screenHeight,
                          "icone-de-portefeuille-d-argent-noir 1", "Wallets",26,
                          Container(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 3,

                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Wallet $index"),
                                      Radio(value: "Wallet $index", groupValue: walletSelected,
                                          onChanged: (v){setState(() {
                                            walletSelected=v.toString();
                                          });})
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                      ),
                    ],
                  ),
                )),
            blackButton('Change Payment', (){
              Navigator.of(context).pop();
            }, screenWidth, screenHeight*0.05)
          ],
        ),
      ),
    );
  }
}
