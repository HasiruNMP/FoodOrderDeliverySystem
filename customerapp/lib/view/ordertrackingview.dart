import 'package:flutter/material.dart';


class TrackOrderView extends StatefulWidget {
  const TrackOrderView({Key? key}) : super(key: key);

  @override
  _TrackOrderViewState createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Your Order'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.height/3,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Order No"),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Timestamp"),
                            )
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Items"),
                            )
                        ),
                        Expanded(
                          flex: 6,
                          child: ListView(
                            children: [
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text("Total Price: Rs. 5000"),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("Delivery Location"),
              ),
              Container(
                height: MediaQuery.of(context).size.height/1,
                color: Colors.teal,
                child: Text("google map"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
