import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'ordertrackingview.dart';

class Orderview extends StatefulWidget {
  const Orderview({Key? key}) : super(key: key);

  @override
  _OrderviewState createState() => _OrderviewState();
}

class _OrderviewState extends State<Orderview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('Pending Orders'),
            Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('customerPhone', isEqualTo: '0766807668')
                      .where('orderStatus', isEqualTo: 'Pending')
                      // .orderBy('orderid', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    //
                    // if (snapshot.connectionState == ConnectionState.waiting ||
                    //     !snapshot.hasData) {
                    //   return CircularProgressIndicator();
                    // }

                    if (snapshot.hasData) {
                      print('has data in orders');
                      return Column(
                        children: [
                          Container(
                            height: 290,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, index) {
                                  QueryDocumentSnapshot orders =
                                      snapshot.data!.docs[index];

                                  Timestamp orderTime = orders['orderTime'];
                                  return Card(
                                    color: Colors.grey[200],
                                    child: Container(
                                      margin: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                      'Order No: ${orders['orderid']}')),
                                              Expanded(
                                                flex: 1,
                                                child: Text(timeago.format(
                                                    orderTime.toDate())),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                    'Rs. ${orders['totalPrice']}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                        //side: const BorderSide(color: Colors.grey)
                                                      ),
                                                    ),
                                                    onPressed: () {
//   Navigator.pushNamed(context, OtpVerify.id);
                                                      String orderId =
                                                          orders['orderid'];
                                                      showAlertDialog(
                                                          context, orderId);
                                                    },
                                                    child: Text('Recieved'),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push<void>(
                                                        context,
                                                        MaterialPageRoute<void>(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              TrackOrderView(
                                                                  orders[
                                                                      'orderid']),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text('Track'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    }
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Past Orders'),
            Container(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('orders')
                      .where('customerPhone', isEqualTo: '0766807668')
                      .where('orderStatus', isEqualTo: 'Recieved')
                      // .orderBy('orderid', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    //
                    // if (snapshot.connectionState == ConnectionState.waiting ||
                    //     !snapshot.hasData) {
                    //   return CircularProgressIndicator();
                    // }

                    if (snapshot.hasData) {
                      print('has data in orders');
                      return Column(
                        children: [
                          Container(
                            height: 270,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, index) {
                                  QueryDocumentSnapshot orders =
                                      snapshot.data!.docs[index];

                                  Timestamp orderTime = orders['orderTime'];
                                  return Card(
                                    color: Colors.grey[200],
                                    child: Container(
                                      margin: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                      'Order No: ${orders['orderid']}')),
                                              Expanded(
                                                flex: 1,
                                                child: Text(timeago.format(
                                                    orderTime.toDate())),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                    'Rs. ${orders['totalPrice']}'),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.all(15),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      primary: Colors.white,
                                                      backgroundColor:
                                                          Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(0.0),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      //   Navigator.pushNamed(context, OtpVerify.id);
                                                    },
                                                    child: const Text('View'),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    }
                    return const SizedBox(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String orderId) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: const Text(
        "Yes",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red,
        ),
      ),
      onPressed: () async {
        await FirebaseFirestore.instance
            .collection("orders")
            .doc(orderId)
            .update({
              "orderStatus": 'Recieved',
            })
            .then((value) => print("Status Updated Successfully!"))
            .catchError((error) => print("Failed: $error"));

        Navigator.pop(context);
        // setState(() {
        //   Navigator.pushReplacementNamed(context, OrderDetails.id);
        // });

        // Navigator.pop(context);
        // setState(() {
        //   Navigator.pushNamed(context, OrderDetails.id);
        // });
        // Navigator.of(context).popUntil((route) => route.isCurrent);
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(
        "No",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      //title: Text("Confirm"),
      content: const Text("Did You Recieve your Order?"),
      actions: [
        continueButton,
        cancelButton,
      ],
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
