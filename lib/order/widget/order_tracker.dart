import 'package:bhaapp/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../model/orderStatusModel.dart';
class OrderTracker extends StatefulWidget {


  String orderStatus;
  String orderStatusDate;
  List<OrderStatusModel> statusList;
  OrderTracker({Key? key,required this.orderStatus,required this.orderStatusDate,required this.statusList}) : super(key: key);
  @override
  OrderTrackerState createState() => OrderTrackerState();
}

class OrderTrackerState extends State<OrderTracker> {

  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
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
        itemCount: widget.statusList.length,
        contentsBuilder: (_, index) {

          return Padding(
            padding: EdgeInsets.only(left: 8.0,bottom: 40,top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    widget.statusList[index].name,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color:widget.statusList[index].status==true?
                    Colors.black.withOpacity(0.8):Colors.grey
                  )
                ),
                widget.statusList[index].date!=''?
                Text(
                    DateFormat('d MMM y, hh:mm a').format(DateTime.parse(widget.statusList[index].date)),
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Colors.black.withOpacity(0.6)
                    )
                ):SizedBox.shrink(),
                widget.statusList[index].image!=''?
                Image.network(widget.statusList[index].image,
                height: 70,) :SizedBox.shrink(),
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
                  color:widget.statusList[index].status==true?
                  splashBlue.withOpacity(0.2):Colors.grey.withOpacity(0.2)
                ),
                child: Center(
                  child: Image.asset('assets/dashboard/package.png',
                  height: 24,width: 24,color: widget.statusList[index].status==true?
                    splashBlue:Colors.grey,),
                ),
              ),
            );

        },
        connectorBuilder: (_, index, ___) => Padding(
          padding: EdgeInsets.all(5),
          child: SolidLineConnector(
            color:widget.statusList[index].status==true?
            splashBlue:Colors.grey,
            
          ),
        ),
      ),
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