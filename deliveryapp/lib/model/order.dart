import 'package:cloud_firestore/cloud_firestore.dart';

class Order {

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> markAsDelivered(String orderID) {
    return orders.doc(orderID).update({
      'isDelivered': true,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

}