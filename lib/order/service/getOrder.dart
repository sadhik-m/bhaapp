import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetOrder{
    getOrderList()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String ? uid= preferences.getString('uid');
    Stream<QuerySnapshot> snapshot = await FirebaseFirestore.instance.collection('orders').where('userId',isEqualTo: uid!).snapshots();
    return snapshot;
  }
}