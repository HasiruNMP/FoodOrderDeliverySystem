import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/model/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../common/globals.dart';
import '../model/orderitemsmodel.dart';
import '../model/productmodel.dart';

class DeliverView extends StatefulWidget {
  String orderID;
  String customerName;
  String phoneNo;
  GeoPoint customerLocation;
  String price;
  String deliveryStatus;

  DeliverView(this.orderID, this.deliveryStatus, this.customerName,
      this.phoneNo, this.customerLocation, this.price,
      {Key? key})
      : super(key: key);

  @override
  _DeliverViewState createState() => _DeliverViewState();
}

class _DeliverViewState extends State<DeliverView> {
  late BitmapDescriptor markerIcon;
  late GoogleMapController mapController;
  static final _initialPosition = LatLng(7.2906, 80.6337);
  LatLng _lastPostion = _initialPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    setMapMarker();
    super.initState();
  }

  Future updateAsDeliverd() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'PUT',
      Uri.parse(
          '${Urls.apiUrl}/orders/updateorderasdelivered?orderId=${widget.orderID}'),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(await response.stream.bytesToString());
      return 0;
    } else {
      print(response.statusCode);
      print(response.reasonPhrase);
      return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order ID: ${widget.orderID}"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Delivery Location',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.5,
                    color: Colors.teal,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(widget.customerLocation.latitude,
                            widget.customerLocation.longitude),
                        zoom: 10.0,
                      ),
                      myLocationEnabled: true,
                      mapType: MapType.normal,
                      compassEnabled: true,
                      onCameraMove: _onCameraMove,
                      markers: _markers,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text(
                                'Customer Name: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(widget.customerName),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Phone: ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(widget.phoneNo),
                            ),
                            TextButton(
                              onPressed: () {
                                launch("tel://214324234");
                              },
                              child: Text('Call'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          orderItems = getOrderItems(int.parse(widget.orderID));
                          _settingModalBottomSheet(
                              context, widget.price, widget.orderID);
                        },
                        child: Text('View Order')),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: widget.deliveryStatus != 'completed'
                        ? OutlinedButton(
                            onPressed: () {
                              updateAsDeliverd();
                            },
                            child: Text('Mark As Delivered'),
                          )
                        : Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    showCustomerLocation();
  }

  void showCustomerLocation() async {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('customer'),
          position: LatLng(widget.customerLocation.latitude,
              widget.customerLocation.longitude),
          //icon: markerIcon,
        ),
      );
      mapController.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(widget.customerLocation.latitude,
              widget.customerLocation.longitude),
        ),
      );
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPostion = position.target;
    });
  }

  void setMapMarker() async {
    markerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(25, 25)), 'assets/cIcon.png');
  }
}

late Future<List<orderItemModel>> orderItems;
late Future<List<productModel>> productDetails;

Future<List<orderItemModel>> getOrderItems(int orderId) async {
  final response = await http
      .get(Uri.parse('${Urls.apiUrl}/orders/getOrderItems?orderId=$orderId'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((data) => new orderItemModel.fromJson(data))
        .toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

Future<List<productModel>> getProductDetails(int productId) async {
  final response = await http.get(Uri.parse(
      '${Urls.apiUrl}/orders/getproductdetails?productId=$productId'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => new productModel.fromJson(data)).toList();
  } else {
    throw Exception('Unexpected error occured!');
  }
}

void _settingModalBottomSheet(context, String price, String orderID) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 270,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total Price: Rs.$price',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.black,
                ),
                Expanded(
                  flex: 8,
                  child: Container(
                    child: FutureBuilder<List<orderItemModel>>(
                        future: orderItems,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong ");
                          }

                          if (snapshot.hasData) {
                            print('has data in Order Items');
                            List<orderItemModel>? data = snapshot.data;

                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: data!.length,
                                itemBuilder: (BuildContext context, i) {
                                  productDetails =
                                      getProductDetails(data[i].productId);

                                  return FutureBuilder<List<productModel>>(
                                      future: productDetails,
                                      builder: (context, snapshot) {
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
                                          print('has data in Order Items');
                                          List<productModel>? product =
                                              snapshot.data;

                                          return Container(
                                            child: ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: product!.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
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
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Text(
                                                              '${data[i].quantity} x ${product[index].price}     =     ${product[index].price * data[i].quantity}',
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
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
                                            child: CircularProgressIndicator(),
                                          ),
                                        );
                                      });
                                });
                          }
                          return Container(
                            height: 100,
                            width: 100,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
