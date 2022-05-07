// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shopapp/globals.dart';

import '../api/apiservice.dart';
import '../model/orderitemsmodel.dart';
import '../model/postEmployee.dart';
import '../model/productmodel.dart';

class Data {
  final int OrderId;
  final int UserId;
  final int EmployeeId;
  final String OrderStatus;
  final bool IsDelivered;
  final bool IsProcessed;
  final bool IsReceived;
  final String DateTime;
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
      EmployeeId: json['EmployeeId'],
      OrderStatus: json['OrderStatus'],
      IsDelivered: json['IsDelivered'],
      IsProcessed: json['IsProcessed'],
      IsReceived: json['IsReceived'],
      DateTime: json['datetime'],
      TotalPrice: json['TotalPrice'],
      Longitude: json['Longitude'],
      Latitude: json['Latitude'],
    );
  }
}

class CompletedOrdersView extends StatefulWidget {
  const CompletedOrdersView({Key? key}) : super(key: key);

  @override
  _CompletedOrdersViewState createState() => _CompletedOrdersViewState();
}

class _CompletedOrdersViewState extends State<CompletedOrdersView> {
  Future<List<Data>> fetchData() async {
    final response =
        await http.get(Uri.parse('${Urls.apiUrl}/orders/getcompletedorders'));
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
  String dateTime = '';
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
      this.dateTime = DateTime;
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

  late Future<List<productModel>> productDetails;
  late Future<List<orderItemModel>> orderItems;
  late Future<List<Data>> futureData;
  late Future<List<PostEmployee>> futureEmployeeData;
  @override
  void initState() {
    super.initState();
    futureData = fetchData();
    orderItems = APIService.getOrderItems(0);
    futureEmployeeData = APIService.getDeliveryEmployees();
  }

  var deliveryInfo;
  var user;
  String fname = '';
  String lname = '';
  String phoneNo = '';

  Future<void> callUserDetailsApi() async {
    user = await APIService.getUserDetailsbyUserId(UserId);
    updateUi(user);
  }

  void updateUi(dynamic user) {
    setState(() {
      fname = user[0]["FirstName"];
      lname = user[0]["LastName"];
      phoneNo = user[0]["Phone"];
    });
  }

  int selOrder = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const VerticalDivider(),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Completed Orders",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Divider(),
              Expanded(
                child: FutureBuilder<List<Data>>(
                    future: futureData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Data>? data = snapshot.data;
                        return ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                color: (selOrder == index)
                                    ? Colors.brown.shade100
                                    : Colors.brown.shade50,
                                //elevation: 2,
                                child: TextButton(
                                    onPressed: () async {
                                      selOrder = index;
                                      updateOrderDetails(
                                          data[index].OrderId,
                                          data[index].UserId,
                                          data[index].EmployeeId,
                                          data[index].OrderStatus,
                                          data[index].IsDelivered,
                                          data[index].IsProcessed,
                                          data[index].IsReceived,
                                          DateTime.parse(data[index].DateTime)
                                              .toString(),
                                          data[index].TotalPrice,
                                          data[index].Longitude,
                                          data[index].Latitude);
                                      callUserDetailsApi();
                                      orderItems =
                                          APIService.getOrderItems(OrderId);
                                      setSelectedOrderId(data[index].OrderId);

                                      print(data[index].EmployeeId);
                                      deliveryInfo =
                                          await APIService.getDeliveryInfo(
                                              data[index].EmployeeId);
                                      deliveryPerson = deliveryInfo[0]["Name"];
                                    },
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: ListTile(
                                            title: Text('Order No: ' +
                                                data[index].OrderId.toString()),
                                            subtitle: Text(DateTime.parse(
                                                    data[index].DateTime)
                                                .toString()),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Center(
                                            child:
                                                const Icon(Icons.navigate_next),
                                          ),
                                        ),
                                      ],
                                    )),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
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
          ),
        ),
        const VerticalDivider(),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Order Description',
                      style: TextStyle(
                        //color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        //letterSpacing: 1
                      ),
                    ),
                  ),
                  alignment: Alignment.center,
                ),
                //Divider(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Order Items"),
                                )),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  color: Colors.red.shade50.withOpacity(0.5),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FutureBuilder<List<orderItemModel>>(
                                        future: orderItems,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasError) {
                                            return Text(
                                                "Something went wrong ");
                                          }

                                          if (snapshot.hasData) {
                                            print('has data in Order Items');
                                            List<orderItemModel>? data =
                                                snapshot.data;

                                            return ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: data!.length,
                                                itemBuilder:
                                                    (BuildContext context, i) {
                                                  productDetails = APIService
                                                      .getProductDetails(
                                                          data[i].productId);

                                                  return FutureBuilder<
                                                          List<productModel>>(
                                                      future: productDetails,
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot.hasError) {
                                                          return Text(
                                                              "Something went wrong future 2");
                                                        }

                                                        // if (snapshot.connectionState ==
                                                        //         ConnectionState.waiting ||
                                                        //     !snapshot.hasData) {
                                                        //   return CircularProgressIndicator();
                                                        // }

                                                        if (snapshot.hasData) {
                                                          print(
                                                              'has data in Order Items');
                                                          List<productModel>?
                                                              product =
                                                              snapshot.data;

                                                          return Container(
                                                            child: ListView
                                                                .builder(
                                                                    scrollDirection:
                                                                        Axis
                                                                            .vertical,
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemCount:
                                                                        product!
                                                                            .length,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            index) {
                                                                      return Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                '${product[index].name}  ',
                                                                                style: const TextStyle(
                                                                                    //fontWeight: FontWeight.bold,
                                                                                    ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: Container(
                                                                                alignment: Alignment.centerRight,
                                                                                child: Text(
                                                                                  '${data[i].quantity} x ${product[index].price}     =     ${product[index].price * data[i].quantity}',
                                                                                  textAlign: TextAlign.right,
                                                                                  style: const TextStyle(
                                                                                      //fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                          );
                                                        }
                                                        return Container(
                                                          height: 100,
                                                          width: 100,
                                                          child: const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          ),
                                                        );
                                                      });
                                                });
                                          }
                                          return Container(
                                            height: 100,
                                            width: 100,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView(
                                children: [
                                  ListTile(
                                    title: Text("Customer Name"),
                                    subtitle: Text(
                                      '$fname $lname',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Phone Number"),
                                    subtitle: Text(
                                      '$phoneNo',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Time"),
                                    subtitle: Text(
                                      dateTime,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Total Price"),
                                    subtitle: Text(
                                      TotalPrice.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    title: Text("Delivery Person"),
                                    subtitle: Text(deliveryPerson),
                                  ),
                                ],
                              ),
                            ),
                            /*Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (deliveryPerson != 'null') {
                                      var updateStatus = await APIService
                                          .updateOrderStatusNdelivery(
                                          OrderId, EmployeeId);
                                      if (updateStatus == 0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.blue,
                                            content:
                                            Text('Assigned Successfully!'),
                                          ),
                                        );
                                        */ /*Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                NewOrdersView(),
                                          ),
                                              (route) => false,
                                        );*/ /*
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text('Failed to assigned!'),
                                          ),
                                        );
                                      }

                                      // updateOrders(selectedOrderId, deliveryPerson);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              ' Please select a Delivery Person'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: const Text('ASSIGN'),
                                  ),
                                ),
                              ),
                            ),*/
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Delivery Location"),
                                )),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GoogleMap(
                                  markers: {
                                    Marker(
                                      markerId:
                                          const MarkerId('_distressedAnimal'),
                                      infoWindow: const InfoWindow(
                                          title: 'Delivery Location'),
                                      icon: BitmapDescriptor.defaultMarker,
                                      position: LatLng(Latitude, Longitude),
                                    )
                                  },
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(Latitude, Longitude),
                                      zoom: 16),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(),
      ],
    );
  }
}
