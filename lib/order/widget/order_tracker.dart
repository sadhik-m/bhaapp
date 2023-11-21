import 'dart:convert';

import 'package:bhaapp/common/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../model/orderStatusModel.dart';
class OrderTracker extends StatelessWidget {

  String orderId;
  String orderStatus;
  String orderStatusDate;
  List<OrderStatusModel> statusList;
  List<OrderStatusModel> reportedStatusList;
  OrderTracker({Key? key,required this.orderStatus,required this.orderStatusDate,
    required this.statusList,required this.orderId,required this.reportedStatusList}) : super(key: key);
  //List<OrderStatusModel> newList=[];
  List<OrderStatusModel> reportStatusListNEW=[];
  @override
  Widget build(BuildContext context) {


    return orderStatus=='Issue Reported'?
    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reportedIssues').where('orderId',isEqualTo: orderId).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return SizedBox.shrink();
        }

        if (snapshot.hasData) {
          //newList.clear();
          reportStatusListNEW.clear();
              String repStsList =
              snapshot.data!.docs[0]['reportStatusList'].toString();
              var convert = json.decode(repStsList);
              for (var item in convert) {
                reportStatusListNEW.add(OrderStatusModel(
                    name: item['name'],
                    status: item['status'],
                    date: item['date'],
                    image: item['image']));
              }

          List<OrderStatusModel>   newList =  statusList+reportStatusListNEW;


          print("RREE ${reportStatusListNEW.length} ${newList.length}");


          return  FixedTimeline.tileBuilder(
            theme: TimelineThemeData(
              nodePosition: 0,
              color: Color(0xff989898),
              indicatorTheme: IndicatorThemeData(
                position: 0,
                size: 34.0,
              ),
              connectorTheme: ConnectorThemeData(
                thickness: 1.5,
              ),
            ),
            builder: TimelineTileBuilder.connected(
              connectionDirection: ConnectionDirection.before,
              itemCount:  newList.length,
              contentsBuilder: (_, index) {

                return Padding(
                  padding: EdgeInsets.only(left: 8.0,bottom: 40,top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          newList[index].name,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: newList[index].status==true?
                              Colors.black.withOpacity(0.8):Colors.grey
                          )
                      ),
                      newList[index].date!=''?
                      Text(
                          DateFormat('d MMM y, hh:mm a').format(DateTime.parse( newList[index].date)),
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.6)
                          )
                      ):SizedBox.shrink(),
                      SizedBox(height: 8,),
                      newList[index].image!=''?
                      InkWell(
                        onTap: (){
                          showAlertDialog(context, newList[index].image);
                        },
                        child: Image.network( newList[index].image,
                          height: 70,),
                      ) :SizedBox.shrink(),
                    ],
                  ),
                );
              },
              indicatorBuilder: (_, index) {

                return ContainerIndicator(
                  child: Container(
                    width: 34.0,
                    height: 34.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: newList[index].status==true?
                        splashBlue.withOpacity(0.2):Colors.grey.withOpacity(0.2)
                    ),
                    child: Center(
                      child: Image.asset('assets/dashboard/package.png',
                        height: 24,width: 24,color:  newList[index].status==true?
                        splashBlue:Colors.grey,),
                    ),
                  ),
                );

              },
              connectorBuilder: (_, index, ___) => Padding(
                padding: EdgeInsets.all(5),
                child: SolidLineConnector(
                  color: newList[index].status==true?
                  splashBlue:Colors.grey,

                ),
              ),
            ),
          );
        }

        return Padding(
          padding:  EdgeInsets.only(top: 0),
          child: Center(child: Text('Loading...')),
        );

      },
    ):
      FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        color: Color(0xff989898),
        indicatorTheme: IndicatorThemeData(
          position: 0,
          size: 34.0,
        ),
        connectorTheme: ConnectorThemeData(
          thickness: 1.5,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount:  statusList.length,
        contentsBuilder: (_, index) {

          return Padding(
            padding: EdgeInsets.only(left: 8.0,bottom: 40,top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    statusList[index].name,
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: statusList[index].status==true?
                        Colors.black.withOpacity(0.8):Colors.grey
                    )
                ),
                statusList[index].date!=''?
                Text(
                    DateFormat('d MMM y, hh:mm a').format(DateTime.parse( statusList[index].date)),
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Colors.black.withOpacity(0.6)
                    )
                ):SizedBox.shrink(),
                SizedBox(height: 8,),
                statusList[index].image!=''?
                InkWell(
                  onTap: (){
                    showAlertDialog(context, statusList[index].image);
                  },
                  child: Image.network( statusList[index].image,
                    height: 70,),
                ) :SizedBox.shrink(),
              ],
            ),
          );
        },
        indicatorBuilder: (_, index) {

          return ContainerIndicator(
            child: Container(
              width: 34.0,
              height: 34.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusList[index].status==true?
                  splashBlue.withOpacity(0.2):Colors.grey.withOpacity(0.2)
              ),
              child: Center(
                child: Image.asset('assets/dashboard/package.png',
                  height: 24,width: 24,color:  statusList[index].status==true?
                  splashBlue:Colors.grey,),
              ),
            ),
          );

        },
        connectorBuilder: (_, index, ___) => Padding(
          padding: EdgeInsets.all(5),
          child: SolidLineConnector(
            color: statusList[index].status==true?
            splashBlue:Colors.grey,

          ),
        ),
      ),
    );



  }
  showAlertDialog(BuildContext context,String image) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      content: InteractiveViewer(
        child: Image.network(image),
        panEnabled: false, // Set it to false to prevent panning.
        boundaryMargin: EdgeInsets.all(80),
        minScale: 0.5,
        maxScale: 4,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            child: Icon(Icons.close,color: Colors.black,),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),

    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
List<String> deliverySteps=[
  'Order Placed',
  'Order Packed',
  'Shipped',
  'Out For Delivery',
  'Delivered'
];
