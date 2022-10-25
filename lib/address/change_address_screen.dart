import 'package:bhaapp/address/add_new_address_screen.dart';
import 'package:bhaapp/address/model/addressModel.dart';
import 'package:bhaapp/address/services/addNewAddress.dart';
import 'package:bhaapp/address/services/getAddressList.dart';
import 'package:bhaapp/address/widget/address_tile.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:bhaapp/common/widgets/loading_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shop_search/view/shop_search_screen.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress({Key? key}) : super(key: key);

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
  final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('customers').snapshots();
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Change Address', [], true),
      body: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth*0.05,
              vertical: screenHeight*0.02),
        child: Column(
          children: [
            Expanded(child:
            FutureBuilder<List<AddressModel>>(
              future: GetAddress().getAddress(),
              builder: (
                  BuildContext context,
                   snapshot,
                  ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return addressTile(screenWidth, screenHeight, (){

                            selectedAddressIndex=index;
                          showLoadingIndicator(context);
                            AddNewAddress().makeDefualt(snapshot.data![index].id).then((value){
                              Navigator.of(context).pop();
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:
                                  (context)=>ShopSearchScreen(willPop: true,)), (route) => false);
                            });


                        },index,
                        snapshot.data![index].name,
                        snapshot.data![index].address,
                        snapshot.data![index].country,
                        snapshot.data![index].mobile,
                        snapshot.data![index].pinCode,
                        );
                      },
                    );
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
            ),
            blackButton('Add New Address', (){
              Navigator.pushNamed(context, '/Add_address').then((value) {
                setState(() {

                });
              });
            }, screenWidth, screenHeight*0.05)
          ],
        ),
      ),
    );
  }

}