import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart'as http;

class Order {

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> markAsDelivered(String orderID) async {
    var request = http.Request('PUT', Uri.parse('https://10.0.2.2:7072/orders/updateorderstatus?orderId=1&orderStatus=completed'));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
    print(response.reasonPhrase);
    }
    return orders.doc(orderID).update({
      'isDelivered': true,
    }).then((value) => print("User Added")).catchError((error) => print("Failed to add user: $error"));
  }

}