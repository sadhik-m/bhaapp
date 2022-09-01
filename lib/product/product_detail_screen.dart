import 'package:bhaapp/cart/my_cart_screen.dart';
import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/product/widget/benefit_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({Key? key}) : super(key: key);

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int quantity=1;
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar("Product Details",
          [Padding(
            padding: const EdgeInsets.only(right:18.0),
            child: Image.asset('assets/home/shopping-bag-2.png',color: Colors.black,
              height: 24,width: 24,),
          )],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth*0.06,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/home/image 4.png',
                height: screenHeight*0.28),
              SizedBox(height: screenHeight*0.01),
              Text('Royale Health\nShield',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 26
              ),textAlign: TextAlign.center,),
              SizedBox(height: screenHeight*0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('\$90',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: text_green,
                        fontSize: 20
                    ),textAlign: TextAlign.center,),
                  Text('/Litre',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: text_green,
                        fontSize: 12
                    ),textAlign: TextAlign.center,),
                ],
              ),
              SizedBox(height: screenHeight*0.03),
              Text("A revolutionary indoor Anti-Bacterial paint, Royale Health Shield Luxury Emulsion is equipped with Silver Ion Technology which kills 99%# of infection-causing bacteria on the painted surfaces and providing a more hygienic environment at home. This healthy paint also improves indoor air quality by reducing formaldehyde, a source of indoor air pollution. ",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w400,
                    color: Colors.black.withOpacity(0.3),
                    fontSize: 12
                ),textAlign: TextAlign.left,),
              SizedBox(height: screenHeight*0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RotatedBox(
                    quarterTurns: 5,
                    child: Container(
                      child: Text('Benefits',style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        color: splashBlue,
                        fontSize: 12
                      ),),
                    ),
                  ),
                  SizedBox(width: screenWidth*0.05,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 4,
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return  benefitListTile();
                      },
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight*0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RotatedBox(
                    quarterTurns: 5,
                    child: Container(
                      child: Text('Quantity',style: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          color: splashBlue,
                          fontSize: 12
                      ),),
                    ),
                  ),
                  SizedBox(width: screenWidth*0.05,),
                  Expanded(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            if(quantity!=1){
                              setState(() {
                                quantity-=1;
                              });
                            }
                          },
                          child: Container(
                            height: screenWidth*0.11,
                            width: screenWidth*0.11,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: Center(
                              child: Text(
                                '-',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth*0.03,),
                        Container(
                          height: screenWidth*0.11,
                          width: screenWidth*0.21,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(4))
                          ),
                          child: Center(
                            child: Text(
                              '${quantity.toString().padLeft(2,'0')}',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth*0.03,),
                        InkWell(
                          onTap: (){
                            setState(() {
                              quantity+=1;
                            });
                          },
                          child: Container(
                            height: screenWidth*0.11,
                            width: screenWidth*0.11,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(4))
                            ),
                            child: Center(
                              child: Text(
                                '+',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                ],
              ),
              SizedBox(height: screenWidth*0.08,),
              Row(
                children: [
                  Container(
                    height: screenWidth*0.11,
                    width: screenWidth*0.09,
                    decoration: BoxDecoration(
                       color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.black,
                        size: screenWidth*0.055,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth*0.03,),
                  Container(
                    height: screenWidth*0.11,
                    width: screenWidth*0.18,
                    decoration: BoxDecoration(
                        color: splashBlue.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(4))
                    ),
                    child: Center(
                      child: Text(
                        'Buy',
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: splashBlue
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth*0.03,),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder:
                      (context)=>MyCart(show_back: true,)));
                    },
                    child: Container(
                      height: screenWidth*0.11,
                      width: screenWidth*0.4,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(4))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Add to Cart ',
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.white
                            ),
                          ),
                          Image.asset('assets/home/shopping-bag-2.png',
                            color: Colors.white,
                            height: screenWidth*0.04,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: screenWidth*0.08,),
            ],
          ),
        ),
      ),
    );
  }
}
