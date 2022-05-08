import 'dart:convert';

import 'package:deliveryapp/common/globals.dart';
import 'package:deliveryapp/model/order.dart';
import 'package:deliveryapp/view/deliverview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompletedOrdersView extends StatefulWidget {
  const CompletedOrdersView({Key? key}) : super(key: key);

  @override
  _CompletedOrdersViewState createState() => _CompletedOrdersViewState();
}

class _CompletedOrdersViewState extends State<CompletedOrdersView> {
  var pendingorders = [];
  bool loaded = false;
  Future fetchpendingorders() async {
    String url =
        "${Urls.apiUrl}/orders/getcompleteddeliveryorders?EmployeeId=${Globals.EmployeeId}";

    final response = await http.get(Uri.parse(url));
    var resJson = json.decode(response.body);

    if (response.statusCode == 200) {
      var a = resJson as List;
      pendingorders = a.toList();
      print(pendingorders);
      setState(() => loaded = true);
    } else {
      print(response.reasonPhrase);
      setState(() => loaded = true);
    }
  }

  @override
  void initState() {
    fetchpendingorders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Orders'),
      ),
      body: SafeArea(
        child: (loaded)
            ? Container(
                child: (pendingorders.length != 0)
                    ? ListView(
                        children: List.generate(pendingorders.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.brown.shade50,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DeliverView(
                                      pendingorders[index]['OrderId']
                                          .toString(),
                                      'completed',
                                      "${pendingorders[index]['FirstName']} ${pendingorders[index]['LastName']}",
                                      pendingorders[index]['Phone'],
                                      GeoPoint(pendingorders[index]['Latitude'],
                                          pendingorders[index]['Longitude']),
                                      pendingorders[index]['TotalPrice']
                                          .toString(),
                                    ),
                                  ),
                                );
                              },
                              child: ListTile(
                                title: Row(
                                  children: [
                                    Text('Order ID: '),
                                    Text(pendingorders[index]['OrderId']
                                        .toString()),
                                  ],
                                ),
                                subtitle: Text(pendingorders[index]['datetime']
                                    .toString()),
                              ),
                            ),
                          ),
                        );
                      }))
                    : Center(
                        child: Text("No Results"),
                      ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
