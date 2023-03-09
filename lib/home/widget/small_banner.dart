import 'package:bhaapp/common/constants/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class smallBanner extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<smallBanner> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('ads').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SizedBox.shrink();
        }

      /*  if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding:  EdgeInsets.only(top: 0),
            child: Center(child: Text('Loading...')),
          );
        }*/
        if(snapshot.hasData){
          if (snapshot.data!.docs.isEmpty) {
            return SizedBox.shrink();
          }
          return  Column(
            children: [
              Container(
                  height: screenHeight*0.14,
                  width: screenWidth,
                  child: CarouselSlider(
                    options: CarouselOptions(
                        aspectRatio: 2.0,
                        viewportFraction: 1,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }
                    ),
                    items: snapshot.data!.docs
                        .map((item) => Container(
                      child: Container(
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(6.0)),
                            child: Container(
                              width: 1000.0,
                              decoration: BoxDecoration(
                                image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                    item['image'],
                                  ),

                                ),

                              ),

                            )),
                      ),
                    ))
                        .toList(),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: snapshot.data!.docs.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 6.0,
                      height: 6.0,
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:splashBlue.withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }
        return SizedBox.shrink();
      },
    );


  }
}



