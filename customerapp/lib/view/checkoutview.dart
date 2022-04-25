import 'dart:async';

import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/controller/makepayment.dart';
import 'package:customerapp/view/selectlocationview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

import '../controller/cart.dart';
import 'homeview.dart';
import 'package:pay/pay.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  double quantityPrice = 0;
  late String fname;
  late String lname;
  late String fullname;
  late String phoneNo;
  late String totalPrice;
  late String items;
  late int orderNum;
  late String orderId;
  late Timestamp timeStamp;
  LatLng location = LatLng(0.0, 0.0);
  List<String> itemsArr = [];

  //map variables
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng lastTap;
  final CameraPosition initLocation = const CameraPosition(
    target: LatLng(6.820934, 80.041671),
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();

    getPhoneNo();
    totalPrice = Cart.totalPrice.toString();
    getUserInfo();
    _determinePosition();

    itemsArr = [
      for (int i = 0; i < Cart.basketItems.length; i++)
        " ${Cart.basketItems[i].name} * ${Cart.basketItems[i].quantity}  Rs.${Cart.basketItems[i].quantity * Cart.basketItems[i].price}"
    ];
    print(itemsArr);
  }

  void getPhoneNo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      setState(() {
        phoneNo = auth.currentUser!.phoneNumber!;
      });

      print(phoneNo);
    }
  }

  void getUserInfo() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(phoneNo)
        .get()
        .then((documentSnapshot) {
      if (documentSnapshot.exists) {
        fname = documentSnapshot.data()!['fname'];
        lname = documentSnapshot.data()!['lname'];
        fullname = "${fname}' '${lname} ";
        print(fname);
        print(lname);
      }
    });
  }

  void Pay() {
    Map paymentObject = {
      "sandbox": true, // true if using Sandbox Merchant ID
      "merchant_id": "1219946", // Replace your Merchant ID
      "notify_url": "http://sample.com/notify",
      "order_id": orderId,
      "items": itemsArr,
      "amount": totalPrice,
      "currency": "LKR",
      "first_name": fname,
      "last_name": lname,
      "email": "",
      "phone": phoneNo,
      "address": "",
      "city": "",
      "country": "Sri Lanka",
      // "delivery_address": "No. 46, Galle road, Kalutara South",
      // "delivery_city": "Kalutara",
      // "delivery_country": "Sri Lanka",
      // "custom_1": "",
      // "custom_2": ""
    };

    PayHere.startPayment(paymentObject, (paymentId) {
      print("One Time Payment Success. Payment Id: $paymentId");
      IncreaseOrderNumbers();
      AddOrderDetails();
      AddEachItems();
      setState(() {
        Cart.EmptyCart();
      });
      Navigator.pop(context);
      setState(() {
        Navigator.pushReplacementNamed(context, 'home');
        // Navigator.popUntil(context, ModalRoute.withName('home'));
        const AdvanceSnackBar(
          message: "Payment Completed Successfully!",
          mode: Mode.ADVANCE,
          duration: Duration(seconds: 3),
          bgColor: Colors.blue,
          textColor: Colors.black,
          iconColor: Colors.black,
        ).show(context);
      });
    }, (error) {
      print("One Time Payment Failed. Error: $error");
    }, () {
      print("One Time Payment Dismissed");
    });
  }

  void getOrderId() async {
    FirebaseFirestore.instance
        .collection('OrderCount')
        .doc('OrderNumbers')
        .get()
        .then((DocumentSnapshot OrderNo) {
      if (OrderNo.exists) {
        orderNum = OrderNo['lastOrderNumber'];
        orderNum = orderNum + 1;

        orderId = 'ID' + orderNum.toString();
        print('Order ID: ' + orderId);

        Pay();
      }
    });
  }

  void IncreaseOrderNumbers() {
    FirebaseFirestore.instance
        .collection("OrderCount")
        .doc('OrderNumbers')
        .update({"lastOrderNumber": FieldValue.increment(1)})
        .then((value) => print("Order Number Increased"))
        .catchError((error) => print("Failed: $error"));
  }

  void AddOrderDetails() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(orderId)
        .set({
          "orderid": orderId,
          "orderTime": DateTime.now(),
          "customerName": fullname,
          "customerLocation": GeoPoint(location.latitude, location.longitude),
          "totalPrice": totalPrice,
          "customerPhone": phoneNo,
          "orderStatus": 'New',
          "isProcessed" : false,
          "isDelivered" : false,
          "isReceived" : false,
        })
        .then((value) => print("Records Added Successfully!"))
        .catchError((error) => print("Failed: $error"));
  }

  void AddEachItems() {
    for (int index = 0; index < Cart.basketItems.length; index++) {
      int addId = Cart.basketItems[index].id;
      String addName = Cart.basketItems[index].name;
      double addPrice = Cart.basketItems[index].price;
      int addQuantity = Cart.basketItems[index].quantity;
      double addprice =
          Cart.basketItems[index].price * Cart.basketItems[index].quantity;

      print(addName);
      print(addPrice);
      print(addQuantity);
      print(addprice);
      FirebaseFirestore.instance
          .collection("orders")
          .doc(orderId)
          .collection('OrderItems')
          .doc(addId.toString())
          .set({
            "id": addId,
            "name": addName,
            "price": addPrice,
            "quantity": addQuantity,
            "price": addprice,
          })
          .then((value) => print("Each item added!"))
          .catchError((error) => print("Failed: $error"));
    }
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    location = LatLng(position.latitude, position.longitude);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Items"),
                        ),
                        Container(
                          color: Colors.white,
                          height: 180,
                          child: ListView(
                            children: [
                              Builder(
                                builder: (context) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: Cart.basketItems.length,
                                    itemBuilder: (context, index) {
                                      quantityPrice =
                                          Cart.basketItems[index].quantity *
                                              Cart.basketItems[index].price;
                                      print(index);
                                      return Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Text(
                                                      Cart.basketItems[index]
                                                          .name,
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10),
                                                      child: Row(
                                                        children: [
                                                          const Text(
                                                            " Price: ",
                                                            style: TextStyle(
                                                                fontSize: 14),
                                                          ),
                                                          Text(
                                                            '${Cart.basketItems[index].quantity.toString()} * ${Cart.basketItems[index].price}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        14),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child: Text(
                                                      '= Rs.$quantityPrice ',
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              "Total Price: Rs. ${Cart.totalPrice.toString()}"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 11,
                //color: Colors.indigo,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(phoneNo)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return Text("Document does not exist");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                          return Column(
                            children: [
                              Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Name: ${data['fname']}')),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Contact Number: $phoneNo'),
                              ),
                            ],
                          );
                        }

                        return Text("loading");
                      },
                    ),

                    //Container(alignment: Alignment.centerLeft,child: Text('Location')),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _navigateAndDisplaySelection(context);
                  },
                  child: Text('Select Location'),
                ),
                //OutlinedButton(onPressed: (){}, child: Text('Select Different Location'),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 3.2,
                color: Colors.teal,
                child: Container(
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
                    onTap: (LatLng pos) {
                      setState(() {
                        lastTap = pos;
                      });
                    },
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  //getOrderId();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MakePayment(),),);
                },
                child: Text('PAY'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigateAndDisplaySelection(BuildContext context) async {
    LatLng newLocation = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectLocationView()),
    );

    location = newLocation;

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$newLocation')));
  }

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
}
