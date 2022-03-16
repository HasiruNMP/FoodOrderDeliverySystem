import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrackOrderView extends StatefulWidget {
  String orderId;
  TrackOrderView(this.orderId);

  @override
  _TrackOrderViewState createState() => _TrackOrderViewState(this.orderId);
}

class _TrackOrderViewState extends State<TrackOrderView> {
  String orderId;
  _TrackOrderViewState(this.orderId);
  @override
  Widget build(BuildContext context) {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Order'),
      ),
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                Container(
                  height: 200,
                  child: FutureBuilder<DocumentSnapshot>(
                    future: orders.doc(orderId).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> orders =
                            snapshot.data!.data() as Map<String, dynamic>;
                        DateTime myDateTime = DateTime.parse(
                            orders['orderTime'].toDate().toString());
                        String formattedDateTime =
                            DateFormat('yyyy-MM-dd – kk:mm').format(myDateTime);
                        return Card(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Order No: $orderId"),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                alignment: Alignment.centerLeft,
                                child: Text(formattedDateTime),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 5),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  "Items",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('orders')
                                      .doc(orderId)
                                      .collection('OrderItems')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasError) {
                                      return Text("Something went wrong");
                                    }

                                    // if (snapshot.connectionState ==
                                    //         ConnectionState.waiting ||
                                    //     !snapshot.hasData) {
                                    //   return CircularProgressIndicator();
                                    // }

                                    if (snapshot.hasData) {
                                      print('has data in Order Items');
                                      return Container(
                                        color: Colors.grey.shade200,
                                        height: 100,
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      index) {
                                                QueryDocumentSnapshot
                                                    orderItems =
                                                    snapshot.data!.docs[index];

                                                return Column(
                                                  children: [
                                                    Text(
                                                        '${orderItems['name']} x ${orderItems['quantity']} =${orderItems['price']}'),
                                                  ],
                                                );
                                              }),
                                        ),
                                      );
                                    }
                                    return Container(
                                      height: 100,
                                      width: 100,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }),
                              Container(
                                margin: EdgeInsets.only(top: 5, right: 58),
                                alignment: Alignment.centerRight,
                                child: Text(
                                    "Total Price: Rs. ${orders['totalPrice']}"),
                              ),
                            ],
                          ),
                        );
                      }

                      return Container(
                        height: 100,
                        width: 100,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text("Delivery Location"),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1,
                  color: Colors.teal,
                  child: Text("google map"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
