import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

sendNotificationToAdmin(String body,String title) async {
  print('N#22');
  //Our API Key
  var serverKey = 'AAAApZTigxU:APA91bFgVHd3GTHcWofnx63D44ev7Onhw9u9wfKBLKA4GYfoUGTe9rNFyZiruqeXZMDeXC9JMzr3Jw-F79xA5zRyM62kPSS4IiJpOgjK6v3IWnXx1Bh_MvNN-JhSoOVl3PTMP8v9dzM7';
   SharedPreferences preferences=await SharedPreferences.getInstance();
  //Get our Admin token from Firesetore DB
  //String token=preferences.getString('dev_id')??'';
  String token=preferences.getString('vendorDeviceId')??'';


  //Create Message with Notification Payload
  String constructFCMPayload(String token) {

    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': title,
        },
        'data': <String, dynamic>{
          'name': '',

        },
        'to': token
      },
    );
  }

  try {
    print('N#33');
    //Send  Message
    http.Response response =
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: constructFCMPayload(token));

    print("status: ${response.statusCode} | Message Sent Successfully!");
  } catch (e) {
    print("error push notification $e");
  }
}


sendNotificationToDriver(String body,String title,String orderId) async {
  //Our API Key
  var serverKey = 'AAAApZTigxU:APA91bFgVHd3GTHcWofnx63D44ev7Onhw9u9wfKBLKA4GYfoUGTe9rNFyZiruqeXZMDeXC9JMzr3Jw-F79xA5zRyM62kPSS4IiJpOgjK6v3IWnXx1Bh_MvNN-JhSoOVl3PTMP8v9dzM7';
   SharedPreferences preferences=await SharedPreferences.getInstance();
  String constructFCMPayload(String token) {

    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': body,
          'title': title,
        },
        'data': <String, dynamic>{
          'name': '',

        },
        'to': token
      },
    );
  }

  await FirebaseFirestore.instance
      .collection('orders')
      .doc(orderId)
      .get()
      .then((DocumentSnapshot documentSnapshot) async{
    if (documentSnapshot.exists) {

      QuerySnapshot querySnapshot= await FirebaseFirestore.instance
          .collection('executives').get();
      for (int i = 0; i < querySnapshot.docs.length; i++) {
        if(documentSnapshot['deliveringBy']==querySnapshot.docs[i]['ID']){
          try {
            //Send  Message
            http.Response response =
            await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                headers: <String, String>{
                  'Content-Type': 'application/json',
                  'Authorization': 'key=$serverKey',
                },
                body: constructFCMPayload(querySnapshot.docs[i]['device_id']));

            print("status: ${response.statusCode} | Message Sent Successfully!");
          } catch (e) {
            print("error push notification $e");
          }
        }
      }
    } else {
      print('Document does not exist on the database');
    }
  });
}