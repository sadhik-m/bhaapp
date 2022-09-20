
import 'package:bhaapp/category/widget/category_list_tile.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'mainCategoryScreen.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final Stream<QuerySnapshot> _categoryStream = FirebaseFirestore.instance.collection('categories').snapshots();
  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Categories', [],true),
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.1,
        ),
        child: SingleChildScrollView(
          child:
          StreamBuilder<QuerySnapshot>(
            stream: _categoryStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return SizedBox.shrink();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              }
              return ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                  return categoryListTile((){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MainCategory(title:data['catName'] ,)));
                  },
                      data['catName']);
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
