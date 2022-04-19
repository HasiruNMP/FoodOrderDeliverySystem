import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/controller/ordermodel.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:customerapp/global.dart' as global;

import '../api/apiservice.dart';
import 'ordertrackingview.dart';

class Orderview extends StatefulWidget {
  const Orderview({Key? key}) : super(key: key);

  @override
  _OrderviewState createState() => _OrderviewState();
}

class _OrderviewState extends State<Orderview> {
  // @override
  // void initState() {
  //   super.initState();
  //   CheckPendingOrders();
  //   CheckDeliveredOrders();
  // }

  late Future<List<orderModel>> newOrders;
  late Future<List<orderModel>> completedOrders;
  @override
  void initState() {
    super.initState();
    newOrders = APIService.getNewOrders(1);
    completedOrders = APIService.getCompletedOrders(1);
  }

  // void CheckPendingOrders() async {
  //   await FirebaseFirestore.instance
  //       .collection('orders')
  //       .where('customerPhone', isEqualTo: global.phoneNo)
  //       .where('orderStatus', isEqualTo: 'New')
  //       .get()
  //       .then((documentSnapshot) {
  //     if (documentSnapshot.size == 0) {
  //       setState(() {
  //         pendingOrderslength = 0;
  //       });
  //     } else {
  //       setState(() {
  //         pendingOrderslength = documentSnapshot.size;
  //       });
  //     }
  //     print('Pending Orders length:${documentSnapshot.size}');
  //   });
  // }

  // void CheckDeliveredOrders() async {
  //   await FirebaseFirestore.instance
  //       .collection('orders')
  //       .where('customerPhone', isEqualTo: global.phoneNo)
  //       .where('orderStatus', isEqualTo: 'Recieved')
  //       .get()
  //       .then((documentSnapshot) {
  //     if (documentSnapshot.size == 0) {
  //       setState(() {
  //         deliveredOrderslength = 0;
  //       });
  //     } else {
  //       setState(() {
  //         deliveredOrderslength = documentSnapshot.size;
  //       });
  //     }
  //     print('delivered Orders length:${documentSnapshot.size}');
  //   });
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            child: FutureBuilder<List<orderModel>>(
                future: newOrders,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  //
                  // if (snapshot.connectionState == ConnectionState.waiting ||
                  //     !snapshot.hasData) {
                  //   return CircularProgressIndicator();
                  // }

                  if (snapshot.hasData) {
                    List<orderModel>? data = snapshot.data;
                    print('has data in orders');
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 5, bottom: 5),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Pending Orders',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 3,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, index) {
                                DateTime orderTime =
                                    DateTime.parse(data[index].dateTime);
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
                                                    'Order No: ${data[index].orderId.toString()}')),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                  (timeago.format(orderTime))),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                  'Rs. ${data[index].totalPrice.toString()}'),
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
                                                          BorderRadius.circular(
                                                              0.0),
                                                      //side: const BorderSide(color: Colors.grey)
                                                    ),
                                                  ),
                                                  onPressed: () {
//   Navigator.pushNamed(context, OtpVerify.id);
                                                    String orderId = data[index]
                                                        .orderId
                                                        .toString();
                                                    showAlertDialog(
                                                        context, orderId);
                                                  },
                                                  child: const Text('Recieved'),
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
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push<void>(
                                                      context,
                                                      MaterialPageRoute<void>(
                                                        builder: (BuildContext
                                                                context) =>
                                                            TrackOrderView(
                                                          data[index]
                                                              .orderId
                                                              .toString(),
                                                          data[index]
                                                              .dateTime
                                                              .toString(),
                                                          data[index]
                                                              .totalPrice,
                                                        ),
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
                  return Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            child: FutureBuilder<List<orderModel>>(
                future: completedOrders,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }
                  //
                  // if (snapshot.connectionState == ConnectionState.waiting ||
                  //     !snapshot.hasData) {
                  //   return CircularProgressIndicator();
                  // }

                  if (snapshot.hasData) {
                    List<orderModel>? data = snapshot.data;
                    print('has data in orders');
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 5, bottom: 5),
                          alignment: Alignment.topLeft,
                          child: const Text(
                            'Past Orders',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          height: 290,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, index) {
                                DateTime orderTime =
                                    DateTime.parse(data[index].dateTime);
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
                                                    'Order No: ${data[index].orderId.toString()}')),
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                  (timeago.format(orderTime))),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Text(
                                                  'Rs. ${data[index].totalPrice.toString()}'),
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
                                                          BorderRadius.circular(
                                                              0.0),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    // Navigator.push<void>(
                                                    //   context,
                                                    //   MaterialPageRoute<
                                                    //       void>(
                                                    //     builder: (BuildContext
                                                    //             context) =>
                                                    //         TrackOrderView(
                                                    //             orders[
                                                    //                 'orderid']),
                                                    //   ),
                                                    // );
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
                  return Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }),
          ),
        ],
      )
          // Column(
          //    mainAxisAlignment: MainAxisAlignment.center,
          //    children: const [
          //      Center(
          //          child: Icon(
          //        Icons.report_gmailerrorred_outlined,
          //        size: 100,
          //        color: Colors.blue,
          //      )),
          //      SizedBox(
          //        height: 20,
          //      ),
          //      Center(
          //        child: Text(
          //          'You have no orders yet',
          //          style: TextStyle(
          //            fontSize: 20,
          //            fontWeight: FontWeight.bold,
          //          ),
          //        ),
          //      ),
          //    ],
          //  ),
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
        // CheckPendingOrders();
        //  CheckDeliveredOrders();
        // setState(() {
        //   Navigator.pushReplacementNamed(context, 'orders');
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
