import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text('Orders History'),
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
                      title: Card(
                        child: TextButton(
                          onPressed: () {
                            // showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return const AlertDialog(
                            //         title: Text('test'),
                            //       );
                            //     });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'OderID',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          ':',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          itemID.toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
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
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                      Expanded(
                                        child: Text(
                                          ':',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          orderTime.toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:  EdgeInsets.all(8.0),
                                  child: Row(
                                    children:  [
                                      Expanded(
                                          flex: 2,
                                          child: Text('Name',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black))),
                                      Expanded(
                                        child: Text(
                                          ':',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          cName.toString(),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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

