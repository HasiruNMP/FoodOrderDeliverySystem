// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Data {
  final int OrderId;
  final int UserId;
  final int EmployeeId;
  final String OrderStatus;
  final bool IsDelivered;
  final bool IsProcessed;
  final bool IsReceived;
  final Timestamp DateTime;
  final double TotalPrice;
  final double Longitude;
  final double Latitude;

  Data(
      {required this.OrderId,
      required this.UserId,
      required this.EmployeeId,
      required this.OrderStatus,
      required this.IsDelivered,
      required this.IsProcessed,
      required this.IsReceived,
      required this.DateTime,
      required this.TotalPrice,
      required this.Longitude,
      required this.Latitude});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      OrderId: json['OrderId'],
      UserId: json['UserId'],
      EmployeeId: json['OrderId'],
      OrderStatus: json['OrderStatus'],
      IsDelivered: json['IsDelivered'],
      IsProcessed: json['IsProcessed'],
      IsReceived: json['IsReceived'],
      DateTime: json['DateTime'],
      TotalPrice: json['TotalPrice'],
      Longitude: json['Longitude'],
      Latitude: json['Latitude'],
    );
  }
}

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({Key? key}) : super(key: key);

  @override
  _PendingOrdersViewState createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  Future<List<Data>> fetchData() async {
    final response = await http
        .get(Uri.parse('https://localhost:7072/orders/getprocessedorders'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => new Data.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  int OrderId = 0;
  int UserId = 0;
  int EmployeeId = 0;
  String OrderStatus = "null";
  bool IsDelivered = false;
  bool IsProcessed = false;
  bool IsReceived = false;
  Timestamp DateTime = Timestamp.now();
  double TotalPrice = 0.0;
  double Longitude = 0.0;
  double Latitude = 0.0;

  void updateOrderDetails(OrderId, UserId, EmployeeId, OrderStatus, IsDelivered,
      IsProcessed, IsReceived, DateTime, TotalPrice, Longitude, Latitude) {
    setState(() {
      this.OrderId = OrderId;
      this.UserId = UserId;
      this.EmployeeId = EmployeeId;
      this.OrderStatus = OrderStatus;
      this.IsDelivered = IsDelivered;
      this.IsProcessed = IsProcessed;
      this.IsReceived = IsReceived;
      this.DateTime = DateTime;
      this.TotalPrice = TotalPrice;
      this.Longitude = Longitude;
      this.Latitude = Latitude;
    });
  }

  var deliveryPerson = 'null';
  int selectedOrderId = 0;

  void setDeliveryPerson(String name) {
    setState(() {
      deliveryPerson = name;
    });
  }

  void setSelectedOrderId(int id) {
    setState(() {
      selectedOrderId = id;
    });
  }

  late Future<List<Data>> futureData;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "New Orders",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
              Expanded(
                flex: 11,
                child: FutureBuilder<List<Data>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Data>? data = snapshot.data;
                        return ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  updateOrderDetails(
                                      data[index].OrderId,
                                      data[index].UserId,
                                      data[index].EmployeeId,
                                      data[index].OrderStatus,
                                      data[index].IsDelivered,
                                      data[index].IsProcessed,
                                      data[index].IsReceived,
                                      data[index].DateTime,
                                      data[index].TotalPrice,
                                      data[index].Longitude,
                                      data[index].Latitude);
                                  setSelectedOrderId(data[index].OrderId);
                                },
                                child: ListTile(
                                  title: Text('Order No: ' +
                                      data[index].OrderId.toString()),
                                  subtitle: Text(
                                      data[index].DateTime.toDate().toString()),
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return CircularProgressIndicator();
                    }),
              ),
            ],
          ),
        ),
        const VerticalDivider(
          color: Colors.black26,
        ),
        Expanded(
          child: Column(
            children: [
              const Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Delivery Person",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )),
              Expanded(
                flex: 11,
                child: SizedBox(),
                // child: FirestoreListView<PostEmployee>(
                //     pageSize: 4,
                //     query: queryPost2,
                //     itemBuilder: (context, snapshot) {
                //       final post = snapshot.data();
                //       return Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Card(
                //           child: TextButton(
                //             onPressed: () {
                //               setDeliveryPerson(post.name);
                //             },
                //             child: ListTile(
                //               title: Text(post.name),
                //               subtitle: Text(post.phone),
                //             ),
                //           ),
                //         ),
                //       );
                //     }),
              ),
            ],
          ),
        ),
        const VerticalDivider(
          color: Colors.black26,
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: const Text(
                      'Order Description',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          letterSpacing: 1),
                    ),
                    alignment: Alignment.center,
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: Text("Customer Name")),
                      const Expanded(child: Text(":")),
                      Expanded(
                        flex: 10,
                        child: Text(
                          UserId.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: Text("Timestamp")),
                      const Expanded(child: Text(":")),
                      Expanded(
                        flex: 10,
                        child: Text(
                          DateTime.toDate().toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: ListView(
                      children: const [
                        TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 10,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Order Items',
                            //errorText: 'Error message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: Text("Total Price")),
                      const Expanded(child: Text(":")),
                      Expanded(
                        flex: 10,
                        child: Text(
                          TotalPrice.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Expanded(flex: 2, child: Text("Location")),
                      const Expanded(child: Text(":")),
                      Expanded(
                        flex: 10,
                        child: Text(
                          Latitude.toString() + " , " + Longitude.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(children: [
                        GoogleMap(
                          markers: {
                            Marker(
                              markerId: const MarkerId('_distressedAnimal'),
                              infoWindow:
                                  const InfoWindow(title: 'Delivery Location'),
                              icon: BitmapDescriptor.defaultMarker,
                              position: LatLng(Latitude, Longitude),
                            )
                          },
                          initialCameraPosition: CameraPosition(
                              target: LatLng(Latitude, Longitude), zoom: 16),
                        ),
                      ]),
                    )),
                Expanded(
                  child: Text("\nDelivery Person: " + deliveryPerson),
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        //updateOrders(selectedOrderId, deliveryPerson);
                      },
                      child: const Text('ASSIGN'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
