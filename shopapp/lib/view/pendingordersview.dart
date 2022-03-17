import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:shopapp/model/post.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({Key? key}) : super(key: key);

  @override
  _PendingOrdersViewState createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  final queryPost = FirebaseFirestore.instance
      .collection('orders')
      .where('isProcessed', isEqualTo: true)
      .where('orderStatus', isEqualTo: 'New')
      .withConverter<Post>(
        fromFirestore: (snapshot, _) => Post.fromJson(snapshot.data()!),
        toFirestore: (orderID, _) => orderID.toJson(),
      );

  String customerName = "null";
  String customerPhone = "null";
  String orderId = "null";
  String orderStatus = "null";
  Timestamp orderTime = Timestamp.now();
  String totalPrice = "null";
  double latitude = 0.0;
  double longitude = 0.0;
  bool isDelivered = false;
  bool isProcessed = false;
  bool isReceived = false;
  String deliveryPerson = 'null';

  void updateOrderDetails(
    customerName,
    customerPhone,
    orderId,
    orderStatus,
    orderTime,
    totalPrice,
    latitude,
    longitude,
    isDelivered,
    isProcessed,
    isReceived,
    deliveryPerson,
  ) {
    setState(() {
      this.customerName = customerName;
      this.customerPhone = customerPhone;
      this.orderId = orderId;
      this.orderStatus = orderStatus;
      this.orderTime = orderTime;
      this.totalPrice = totalPrice;
      this.latitude = latitude;
      this.longitude = longitude;
      this.isDelivered = isDelivered;
      this.isProcessed = isProcessed;
      this.isReceived = isReceived;
      this.deliveryPerson = deliveryPerson;
    });
  }

  var selectedOrderId = 'null';

  void setSelectedOrderId(String id) {
    selectedOrderId = id;
  }

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');
  updateOrders(String id) {
    orders.doc(id).update({
      'orderStatus': 'Delivered',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: FirestoreListView<Post>(
              pageSize: 4,
              query: queryPost,
              itemBuilder: (context, snapshot) {
                final post = snapshot.data();
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TextButton(
                      onPressed: () {
                        updateOrderDetails(
                          post.customerName,
                          post.customerPhone,
                          post.orderId,
                          post.orderStatus,
                          post.orderTime,
                          post.totalPrice,
                          post.customerLocation.latitude,
                          post.customerLocation.longitude,
                          post.isDelivered,
                          post.isProcessed,
                          post.isReceived,
                          post.deliveryPerson,
                        );
                        setSelectedOrderId(post.orderId);
                      },
                      child: ListTile(
                        title: Text('Order No: ' + post.orderId),
                        subtitle: Text(post.orderTime.toDate().toString()),
                      ),
                    ),
                  ),
                );
              }),
        ),
        VerticalDivider(
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
                    child: Text(
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
                      Expanded(flex: 5, child: Text("Customer Name")),
                      Expanded(child: Text(":")),
                      Expanded(
                        flex: 8,
                        child: Text(
                          customerName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(flex: 6, child: Text("Delivery Person NIC")),
                      Expanded(child: Text(":")),
                      Expanded(
                        flex: 6,
                        child: Text(
                          deliveryPerson,
                          style: TextStyle(
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
                      Expanded(flex: 2, child: Text("Timestamp")),
                      Expanded(child: Text(":")),
                      Expanded(
                        flex: 10,
                        child: Text(
                          orderTime.toDate().toString(),
                          style: TextStyle(
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
                      children: [
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
                      Expanded(flex: 2, child: Text("Total Price")),
                      Expanded(child: Text(":")),
                      Expanded(
                        flex: 10,
                        child: Text(
                          totalPrice,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 4, child: SizedBox()),
                      Expanded(
                          flex: 2,
                          child: Text(
                            "Delivered",
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                        flex: 2,
                        child: Checkbox(
                          value: isDelivered,
                          onChanged: null,
                        ),
                      ),
                      Expanded(flex: 4, child: SizedBox()),
                      Expanded(
                          flex: 2,
                          child: Text(
                            "Received",
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                        flex: 2,
                        child: Checkbox(
                          value: isReceived,
                          onChanged: null,
                        ),
                      ),
                      Expanded(flex: 4, child: SizedBox()),
                    ],
                  ),
                ),
                Divider(),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text("Location")),
                      Expanded(child: Text(":")),
                      Expanded(
                        flex: 10,
                        child: Text(
                          latitude.toString() + " , " + longitude.toString(),
                          style: TextStyle(
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
                              position: LatLng(latitude, longitude),
                            )
                          },
                          initialCameraPosition: CameraPosition(
                              target: LatLng(latitude, longitude), zoom: 16),
                        ),
                      ]),
                    )),
                Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        updateOrders(selectedOrderId);
                      },
                      child: Text('COMPLETED'),
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
