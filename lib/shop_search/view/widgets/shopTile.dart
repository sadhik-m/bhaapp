import 'package:bhaapp/home/model/vendorShopModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopDataListTile extends StatefulWidget {
  VendorShopModel vendorTypeList;
  double screenWidth;
  double screenHeight;
   ShopDataListTile({Key? key,required this.vendorTypeList,required this.screenWidth,required this.screenHeight}) : super(key: key);

  @override
  _ShopDataListTileState createState() => _ShopDataListTileState();
}

class _ShopDataListTileState extends State<ShopDataListTile> {

  int ratingCount=0;
  double ratingSum=0;
  double ratingSummary=0;

  getRatingData()async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    await FirebaseFirestore.instance.collection('vendors').doc(widget.vendorTypeList.vendorDocId).collection('rating').get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        setState(() {
          ratingCount=querySnapshot.docs.length;
          print("count $ratingCount");
        });
      });
      querySnapshot.docs.forEach((doc) {
        setState(() {
          ratingSum+=double.parse(doc['rating']);
        });
      });
    });
    setState(() {
      ratingSummary=ratingSum/ratingCount;
    });


  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRatingData();
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
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
                  widget.vendorTypeList.image ,
                ),

              ),

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: widget.screenWidth*0.04,vertical: widget.screenHeight*0.01),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.vendorTypeList.shopName,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 18
                        ),),
                      SizedBox(height: widget.screenHeight*0.003,),
                      Text(widget.vendorTypeList.address,
                        style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 12
                        ),),
                      SizedBox(height: widget.screenHeight*0.01,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/home/clock.png',
                                width: 14,height: 14,),
                              SizedBox(width: widget.screenWidth*0.013,),
                              Text('${widget.vendorTypeList.openTime} AM - ${widget.vendorTypeList.closeTime} PM',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10
                                ),)
                            ],
                          ),

                        ],
                      ),
                      SizedBox(height: widget.screenHeight*0.01,),
                      IgnorePointer(
                        child: RatingBar.builder(
                          initialRating: ratingSummary,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: widget.screenHeight*0.028,
                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {

                            print(rating);
                          },
                        ),
                      ),
                      SizedBox(height: widget.screenHeight*0.01,),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
