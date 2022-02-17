import 'package:deliveryapp/view/deliverview.dart';
import 'package:deliveryapp/view/historyview.dart';
import 'package:deliveryapp/view/profileview.dart';
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
        child: ListView(
          children: [
            ListTile(
              title: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Order No.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Text(':')),
                            Expanded(flex: 4, child: Text('0003')),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Expanded(
                                flex: 2,
                                child: Text('Time',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text(':')),
                            Expanded(
                                flex: 4, child: Text('3rd Jan 2022, 12.45pm')),
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
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'Order No.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Text(':')),
                            Expanded(flex: 4, child: Text('0003')),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: const [
                            Expanded(
                                flex: 2,
                                child: Text('Time',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold))),
                            Expanded(child: Text(':')),
                            Expanded(
                                flex: 4, child: Text('3rd Jan 2022, 12.45pm')),
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
  }
}

