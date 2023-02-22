import 'dart:convert';

import 'package:bhaapp/common/models/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService{
  sendNotification()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String dev_id=preferences.getString('dev_id')??'';
    var url=Uri.parse('https://fcm.googleapis.com/fcm/send');
    var body=json.encode({
      "to": dev_id,
      "notification": {
        "title": "NOTIFICATION",
        "body": "test body contentt gfwugf efguqhifiufu qefhuiefuieb efgieqfgieqhu kefgeu",
        "mutable_content": true,
        "sound": "Tri-tone"
      },

      "data": {
        "url": "<url of media image>",
        "dl": "<deeplink action on tap of notification>"
      }
    });
    var response=await http.post(
      url,
      body: body,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "key=AAAApZTigxU:APA91bFgVHd3GTHcWofnx63D44ev7Onhw9u9wfKBLKA4GYfoUGTe9rNFyZiruqeXZMDeXC9JMzr3Jw-F79xA5zRyM62kPSS4IiJpOgjK6v3IWnXx1Bh_MvNN-JhSoOVl3PTMP8v9dzM7"
      }
    ).then((value){
      print(value.body.toString());
    });
  }

  saveNotifications(String title,String body)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String uid=preferences.getString('uid')??'';
    try{
      await FirebaseFirestore.instance.collection('customers').doc(uid).collection('notifications')
          .add(
        NotificationModel(title: title,body: body).toJson(),
      );
    }catch(e){}
  }

  Future<List<NotificationModel>> getNotificationList()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid=preferences.getString('uid');
    List<NotificationModel> notificationList=[];
    await FirebaseFirestore.instance.collection('customers').doc(uid).collection('notifications').get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        notificationList.add(NotificationModel(title: doc['title'], body: doc['body'], ));
      });
    });

    return notificationList;
  }
}