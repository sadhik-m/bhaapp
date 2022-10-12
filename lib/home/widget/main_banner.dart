import 'package:bhaapp/home/model/vendorShopModel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class mainBanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<mainBanner> {
List<VendorShopModel> shopData=[];

getVendorShopData()async{
  SharedPreferences preferences=await SharedPreferences.getInstance();
  String vendorDocId=preferences.getString('vendorDocId')??'';
  FirebaseFirestore.instance
      .collection('vendors')
      .doc(vendorDocId)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      setState(() {
        shopData.add(
          VendorShopModel(
              vendorId: documentSnapshot['vendorId'],
              shopName: documentSnapshot['shopName'],
              vendorDocId: documentSnapshot.id.toString(),
              image: documentSnapshot['shopImage'],
              address: documentSnapshot['address'],
              closeTime: "${documentSnapshot['closeTime.${'hour'}']}:${documentSnapshot['closeTime.${'minute'}']}",
              openTime: "${documentSnapshot['openTime.${'hour'}']}:${documentSnapshot['openTime.${'minute'}']}",
              phone: documentSnapshot['mobile'],
              email: documentSnapshot['email'])
        );
      });
    } else {
      print('Document does not exist on the database');
    }
  });
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVendorShopData();
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight*0.18,
        width: screenWidth,
        child: shopData.isEmpty?
        Center(child: CircularProgressIndicator(),):
        Container(
          child: Container(
            // margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(6.0)),
                child: Container(
                  width: 1000.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: new DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter:
                      ColorFilter.mode(Colors.black.withOpacity(0.5),
                          BlendMode.dstATop),
                      image: new NetworkImage(
                       shopData[0].image ,
                      ),

                    ),

                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(shopData[0].vendorId,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 12
                              ),),
                          ],
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(shopData[0].shopName,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 18
                              ),),
                            SizedBox(height: screenHeight*0.003,),
                            Text(shopData[0].address,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 12
                              ),),
                            SizedBox(height: screenHeight*0.01,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset('assets/home/clock.png',
                                      width: 14,height: 14,),
                                    SizedBox(width: screenWidth*0.013,),
                                    Text('${shopData[0].openTime} AM - ${shopData[0].closeTime} PM',
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10
                                      ),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        launchUrl(Uri(
                                          scheme: 'tel',
                                          path: shopData[0].phone,
                                        ));
                                      },
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Image.asset('assets/home/Vector.png',
                                            width: 13.4,height: 13.4,),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth*0.015,),
                                    InkWell(
                                      onTap: (){
                                        launchUrl(Uri(
                                            scheme: 'mailto',
                                            path: shopData[0].email,
                                            query: 'Hello',
                                            ),
                                        );
                                      },
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Image.asset('assets/home/Group 44.png',
                                            width: 14,height: 10.2,),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: screenHeight*0.01,),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ));
  }
}



/*Container(
      height: screenHeight*0.24,
        width: screenWidth,
        child: CarouselSlider(
          options: CarouselOptions(
            aspectRatio: 2.0,
            viewportFraction: 1,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }
          ),
          items: imgList
              .map((item) => Container(
            child: Container(
             // margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  child: Container(
                    width: 1000.0,
                   decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter:
                        ColorFilter.mode(Colors.black.withOpacity(0.5),
                            BlendMode.dstATop),
                        image: new AssetImage(
                          item,
                        ),

                      ),

                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: screenWidth*0.04),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Premier Supermarket',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 18
                                ),),
                              SizedBox(height: screenHeight*0.003,),
                              Text('Zakaria Bazar Junction, opposite Akshaya\nCentre, Alappuzha, Kerala 688012',
                                style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontSize: 12
                                ),),
                              SizedBox(height: screenHeight*0.01,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/home/clock.png',
                                        width: 14,height: 14,),
                                      SizedBox(width: screenWidth*0.013,),
                                      Text('08:00 AM - 08:00PM',
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10
                                        ),)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Image.asset('assets/home/Vector.png',
                                            width: 13.4,height: 13.4,),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth*0.015,),
                                      Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        child: Center(
                                          child: Image.asset('assets/home/Group 44.png',
                                            width: 14,height: 10.2,),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: imgList.asMap().entries.map((entry) {
                                  return GestureDetector(
                                    onTap: () => _controller.animateToPage(entry.key),
                                    child: Container(
                                      width: 6.0,
                                      height: 6.0,
                                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:Colors.white.withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          )
          )
              .toList(),
        ));*/