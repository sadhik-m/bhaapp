import 'package:bhaapp/common/constants/colors.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/dashboard/dash_board_screen.dart';
import 'package:bhaapp/home/widget/product_tile.dart';
import 'package:bhaapp/product/product_detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NewProducts extends StatelessWidget {

 const NewProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('products').where('seller.${'vid'}',isEqualTo: vendorId).snapshots();
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Products',
          [],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
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
                        return ProductTile(height: screenHeight,
                            width: screenWidth,
                            ontap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetail(docId: document.id.toString())));
                            },
                            image: data['productImageUrl'],
                            prodName: data['productName'],
                            salePrize: data['salesPrice'].toString(),
                            reguarPrize: data['regularPrice'].toString(),
                            quantity: data['priceUnit'],
                            prodId: document.id.toString(),
                            fav: favouriteList!.contains(document.id.toString()),
                          cartHomeList: [],);
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
