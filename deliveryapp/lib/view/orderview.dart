import 'package:deliveryapp/view/deliverview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              //  return CircularProgressIndicator();
            }

            if (snapshot.hasData) {
              print('has data');
              return Container(
                height: 529,


                color: Colors.white,
                child: ListView.builder(

                  itemCount: snapshot.data!.docs.length,

                  // ignore: missing_return
                  itemBuilder: (BuildContext context, index) {
                    QueryDocumentSnapshot category =
                    snapshot.data!.docs[index];
                    GeoPoint cLocation=category['customerLocation'];
                    String cName=category['customerName'];
                    String cPhone=category['customerPhone'];
                    String deliveryPerson=category['deliveryPerson'];
                    //String itemCounts=category['itemCounts'];
                    String itemID=category['orderid'];
                    Timestamp orderTime=category['orderTime'];
                    String orderId=category['orderid'];
                    String  totalPrice=category['totalPrice'];


                    return ListTile(
                      title: Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Card(
                                child: Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.all(8.0),
                                        child: Row(
                                          children:  [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'Order No.',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(child: Text(':')),
                                            Expanded(flex: 4, child: Text(itemID.toString())),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.all(8.0),
                                        child: Row(
                                          children:  [
                                            Expanded(
                                                flex: 2,
                                                child: Text('Time',
                                                    style:
                                                    TextStyle(fontWeight: FontWeight.bold))),
                                            Expanded(child: Text(':')),
                                            Expanded(
                                                flex: 4, child: Text(orderTime.toString())),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              child: const Text('DELIVERED'),
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          Expanded(
                                            flex: 3,
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) {return const DeliverView();},),);
                                              },
                                              child: const Text('VIEW'),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            ListTile(
                              title: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:  EdgeInsets.all(8.0),
                                        child: Row(
                                          children:  [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                'Order No.',
                                                style: TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Expanded(child: Text(':')),
                                            Expanded(flex: 4, child: Text(itemID.toString())),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 2,
                                                child: Text('Time',
                                                    style:
                                                    TextStyle(fontWeight: FontWeight.bold))),
                                            Expanded(child: Text(':')),
                                            Expanded(
                                                flex: 4, child: Text(orderTime.toString())),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              child: const Text('DELIVERED'),
                                            ),
                                          ),
                                          const Expanded(child: SizedBox()),
                                          Expanded(
                                            flex: 3,
                                            child: OutlinedButton(
                                              onPressed: () {},
                                              child: const Text('VIEW'),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}
