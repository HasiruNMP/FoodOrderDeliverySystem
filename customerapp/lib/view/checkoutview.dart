import 'dart:async';

import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/view/makepayment.dart';
import 'package:customerapp/view/ordercompleteview.dart';
import 'package:customerapp/view/setlocationview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

import '../controller/cart.dart';
import 'homeview.dart';
import 'package:pay/pay.dart';

class CheckoutView extends StatefulWidget {

  LatLng delLoc;
  CheckoutView(this.delLoc, {Key? key}) : super(key: key);

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
  //LatLng location = LatLng(0.0, 0.0);
  List<String> itemsArr = [];

  //map variables
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  late LatLng lastTap;
  late CameraPosition initLocation;

  @override
  void initState() {
    super.initState();

    getPhoneNo();
    totalPrice = Cart.totalPrice.toString();

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: ListView(
                  children: [
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Delivery Location",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.2,
                      color: Colors.teal,
                      child: Container(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(widget.delLoc.latitude, widget.delLoc.longitude),
                            zoom: 10,
                          ),
                          onMapCreated: _onMapCreated,
                          compassEnabled: true,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          zoomControlsEnabled: true,
                          zoomGesturesEnabled: true,
                          markers: markers.values.toSet(),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                      child: Text("Customer Details",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 2, 8, 0),
                      child: Text("    Name: ",),
                    ),Padding(
                      padding: const EdgeInsets.fromLTRB(5, 3, 8, 0),
                      child: Text("    Phone: ",),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                      child: Text("Order Description",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.4,
                      child: ListView(
                        children: List.generate(Cart.basketItems.length,(index){
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${Cart.basketItems[index].name} [${Cart.basketItems[index].price} x ${Cart.basketItems[index].quantity}]"),
                                Text("   =  ${Cart.basketItems[index].quantity*Cart.basketItems[index].price}"),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    Center(
                      child: Text("Total: ${Cart.totalPrice.toString()}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              //color: Colors.green,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OrderCompleted(widget.delLoc,Cart.totalPrice)),
                          );
                        },
                        child: Text("Confirm & Pay"),
                      ),
                    ),
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
    final marker = Marker(
      markerId: MarkerId('place_name'),
      position: LatLng(widget.delLoc.latitude, widget.delLoc.longitude),
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
