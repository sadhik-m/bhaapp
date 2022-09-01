
import 'package:bhaapp/category/widget/category_list_tile.dart';
import 'package:bhaapp/common/widgets/appBar.dart';
import 'package:flutter/material.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
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
          child: ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),

            itemBuilder: (context, index) {
              return categoryListTile(
                  (){
                    Navigator.pushNamed(context, '/category_detail');
                  }
              );
            },
          ),
        ),
      ),
    );
  }
}
