import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:bhaapp/product/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryDetail extends StatelessWidget {
   String title;
   CategoryDetail({Key? key,required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('products').where('subCategory',isEqualTo: title.toString()).snapshots();
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(title,
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
              child: StreamBuilder<QuerySnapshot>(
                stream: _productStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return SizedBox.shrink();
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding:  EdgeInsets.only(top: screenHeight*0.35),
                      child: Text("Loading...."),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding:  EdgeInsets.only(top: screenHeight*0.35),
                      child: Text('Nothing Found!'),
                    );
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth*0.04,
                    ),
                    width: screenWidth,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      runAlignment: WrapAlignment.spaceBetween,
                      runSpacing: 20,
                      children: snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return
                        productTile(screenHeight,screenWidth,
                              (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId: document.id.toString())));
                          },
                          data['productImageUrl'],
                          data['productName'],
                          data['salesPrice'].toString(),
                          data['regularPrice'].toString(),
                          data['priceUnit'],


                        );
                      }).toList(),

                    ),
                  );


                },
              ),
            ))
          ],
        ),
      ),
    );
  }
}
