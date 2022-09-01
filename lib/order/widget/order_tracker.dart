import 'package:bhaapp/common/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timelines/timelines.dart';
class OrderTracker extends StatefulWidget {


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
        itemCount: deliverySteps.length,
        contentsBuilder: (_, index) {

          return Padding(
            padding: EdgeInsets.only(left: 8.0,bottom: 40,top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  deliverySteps[index],
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.8)
                  )
                ),
                Text(
                    'Wed, 17th Aug 2022',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        fontSize: 10,
                        color: Colors.black.withOpacity(0.6)
                    )
                ),
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
                  color: splashBlue.withOpacity(0.2)
                ),
                child: Center(
                  child: Image.asset('assets/dashboard/package.png',
                  height: 24,width: 24,color: splashBlue,),
                ),
              ),
            );

        },
        connectorBuilder: (_, index, ___) => Padding(
          padding: EdgeInsets.all(5),
          child: SolidLineConnector(
            color: splashBlue,
            
          ),
        ),
      ),
    );
  }
}
List<String> deliverySteps=[
  'Order Packed',
  'Shipped',
  'Out For Delivery',
  'Delivery'
];