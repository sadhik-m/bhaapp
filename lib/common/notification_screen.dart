
import 'package:bhaapp/common/models/notification_model.dart';
import 'package:bhaapp/common/services/send_push_notification_service.dart';
import 'package:bhaapp/common/widgets/appBar.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight=MediaQuery.of(context).size.height;
    var screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar('Notifications', [
      ], true),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth*0.05,
            vertical: screenHeight*0.02),
        child: FutureBuilder<List<NotificationModel>>(
          future:NotificationService().getNotificationList() ,
          builder: (
              BuildContext context,
              snapshot,
              ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
               child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                if(snapshot.data!.isEmpty){
                  return Center(
                    child: Text('No notifications yet!'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        decoration:BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3),
                                width: 2
                            )
                        ),
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data![index].title,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                  fontSize: 15
                              ),),
                            SizedBox(height: 10,),
                            Text(snapshot.data![index].body,
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize: 14
                              ),),
                          ],
                        ),
                      ),
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
    );
  }

}