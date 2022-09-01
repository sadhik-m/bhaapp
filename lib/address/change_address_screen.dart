import 'package:bhaapp/address/widget/address_tile.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:bhaapp/common/widgets/black_button.dart';
import 'package:flutter/material.dart';

class ChangeAddress extends StatefulWidget {
  const ChangeAddress({Key? key}) : super(key: key);

  @override
  State<ChangeAddress> createState() => _ChangeAddressState();
}

class _ChangeAddressState extends State<ChangeAddress> {
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
            ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return addressTile(screenWidth, screenHeight, (){
                  setState(() {
                    selectedAddressIndex=index;
                  });
                },index);
              },
            )),
            blackButton('Add New Address', (){
              Navigator.pushNamed(context, '/Add_address');
            }, screenWidth, screenHeight*0.05)
          ],
        ),
      ),
    );
  }
}