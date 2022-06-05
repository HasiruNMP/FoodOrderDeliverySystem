import 'dart:convert';

import 'package:deliveryapp/common/globals.dart';
import 'package:deliveryapp/model/order.dart';
import 'package:deliveryapp/view/deliverview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../auth/authservice.dart';

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({Key? key}) : super(key: key);

  @override
  _PendingOrdersViewState createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  var pendingorders = [];
  bool loaded = false;
  late int empId;

  Future getEmployeeDetails() async {
    http.Response response = await http.get(
        Uri.parse(
            '${Urls.apiUrl}/employee/getemployeedetailsbyusername?username=${Globals.userName}'),
        headers: {'Authorization': 'Bearer ${Auth.token}'});

    if (response.statusCode == 200) {
      print(response.statusCode);
      String data = response.body;
      print(data);
      var info = jsonDecode(data);
      //empId = info[0]["EmployeeId"];
      //Globals.EmployeeId = empId;
      //print(empId);
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
    }

    fetchpendingorders();
  }

  Future fetchpendingorders() async {
    String url = "https://fodsapi.azurewebsites.net/orders/getorderlist?EmployeeId=21";

    print(Auth.token);

    final response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${Auth.token}'});
    var resJson = json.decode(response.body);

    if (response.statusCode == 200) {
      var a = resJson as List;
      pendingorders = a.toList();
      print(pendingorders);
      setState(() => loaded = true);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    //getEmployeeDetails();
    fetchpendingorders();
    print(Globals.userName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
      ),
      body: SafeArea(
        child: (loaded)
            ? Container(
                child: (pendingorders.length != 0)
                    ? ListView(
                        children: List.generate(pendingorders.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Card(
                            //elevation: 0,
                            color: Colors.brown.shade50,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DeliverView(
                                      pendingorders[index]['OrderId']
                                          .toString(),
                                      'pending',
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
                                title: Text("Order ID: " +
                                    pendingorders[index]['OrderId'].toString()),
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
