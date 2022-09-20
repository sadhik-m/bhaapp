
import 'package:bhaapp/category/subCategoryScreen.dart';
import 'package:bhaapp/category/widget/category_list_tile.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class MainCategory extends StatefulWidget {
  String title;
   MainCategory({Key? key,required this.title}) : super(key: key);

  @override
  State<MainCategory> createState() => _MainCategoryState();
}

class _MainCategoryState extends State<MainCategory> {

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _mainCategoryStream = FirebaseFirestore.instance.collection('mainCategories').where('category',isEqualTo: widget.title).snapshots();
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(widget.title, [],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth*0.1,
        ),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
            stream: _mainCategoryStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return SizedBox.shrink();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding:  EdgeInsets.only(top: screenHeight*0.35),
                  child: Text('Loading...'),
                );
              }
              if (snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding:  EdgeInsets.only(top: screenHeight*0.35),
                  child: Text('Nothing Found!'),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return
                  categoryListTile(
                          (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>SubCategory(title:data['mainCategory'] ,)));
                      },
                    data['mainCategory']
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
