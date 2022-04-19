import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TrackOrderView extends StatefulWidget {
  String orderId;
  String time;
  double totalPrice;

  TrackOrderView(this.orderId, this.time, this.totalPrice);

  @override
  _TrackOrderViewState createState() => _TrackOrderViewState();
}

class _TrackOrderViewState extends State<TrackOrderView> {
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final CameraPosition initLocation = const CameraPosition(
    target: LatLng(6.820934, 80.041671),
    zoom: 10,
  );

  void _onMapCreated(GoogleMapController controller) {
    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(9.669111, 80.014007),
      // icon: BitmapDescriptor.,
      infoWindow: InfoWindow(
        title: 'title',
        snippet: 'address',
      ),
    );

    setState(() {
      markers[MarkerId('place_name')] = marker;
    });
  }

  late String status;
  @override
  Widget build(BuildContext context) {
    CollectionReference orders =
        FirebaseFirestore.instance.collection('orders');
    return Scaffold(
        appBar: AppBar(
          title: Text('Track Your Order'),
        ),
        body: SafeArea(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Container(
                    height: 200,
                    child: Card(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text("Order No: ${widget.orderId}"),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            alignment: Alignment.centerLeft,
                            child: Text(widget.time),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              "Items",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('orders')
                                  .doc('ID16')
                                  .collection('OrderItems')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something went wrong");
                                }

                                // if (snapshot.connectionState ==
                                //         ConnectionState.waiting ||
                                //     !snapshot.hasData) {
                                //   return CircularProgressIndicator();
                                // }

                                if (snapshot.hasData) {
                                  print('has data in Order Items');
                                  return Container(
                                    color: Colors.grey.shade200,
                                    height: 100,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: true,
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            QueryDocumentSnapshot orderItems =
                                                snapshot.data!.docs[index];

                                            return Column(
                                              children: [
                                                Text(
                                                    '${orderItems['name']} x ${orderItems['quantity']} =${orderItems['price']}'),
                                              ],
                                            );
                                          }),
                                    ),
                                  );
                                }
                                return Container(
                                  height: 100,
                                  width: 100,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }),
                          Container(
                            margin: EdgeInsets.only(top: 5, right: 58),
                            alignment: Alignment.centerRight,
                            child:
                                Text("Total Price: Rs. ${widget.totalPrice}"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Delivery Location"),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: initLocation,
                      onMapCreated: _onMapCreated,
                      compassEnabled: true,
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      zoomControlsEnabled: true,
                      zoomGesturesEnabled: true,
                      markers: markers.values.toSet(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
