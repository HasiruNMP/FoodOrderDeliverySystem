import 'package:customerapp/api/apiservice.dart';
import 'package:customerapp/controller/ordermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:customerapp/global.dart' as global;
import 'package:twilio_flutter/twilio_flutter.dart';

import '../controller/cart.dart';

class OrderCompleted extends StatefulWidget {
  LatLng delLoc;
  double total;
  String fname;
  String phoneNo;
  OrderCompleted(this.delLoc, this.total, this.fname, this.phoneNo);

  @override
  State<OrderCompleted> createState() => _OrderCompletedState();
}

class _OrderCompletedState extends State<OrderCompleted> {
  bool isDone = false;
  String orderID = "0";
  bool p = false;

  @override
  void initState() {
    placeOrder();
  }

  late TwilioFlutter twilioFlutter;

  void sendSms() async {
    twilioFlutter = TwilioFlutter(
        accountSid: 'AC0af284e07dd78c2b827ec036ba464315',
        authToken: '388f87fc7fc687da4f6cd9653ba7ab7b',
        twilioNumber: '+19289853180');
    twilioFlutter.sendSMS(
        toNumber: widget.phoneNo,
        messageBody:
            'Hello ${widget.fname}! Your Order ID is $orderID, Your package will be delivered to you soon. Thank you!');
  }

  void placeOrder() async {
    orderID = await APIService.addNewOrder(
      NewOrderModel(
        userId: global.userId,
        dateTime: DateTime.now().toString(),
        totalPrice: widget.total,
        lat: widget.delLoc.latitude,
        lng: widget.delLoc.longitude,
      ),
    );

    void addItems() async {}

    setState(() {
      p = true;
    });
    sendSms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SafeArea(
        child: (orderID != "0")
            ? Center(
                child: (orderID != "error")
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 100,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Text("Order Successful!"),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Your Order ID: $orderID",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Text("Thank You!"),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Cart.EmptyCart();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'home', (route) => false);
                            },
                            child: Text('Back to Home'),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Icon(
                            Icons.error,
                            color: Colors.redAccent,
                            size: 100,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          const Text("Error Processing Order!"),
                          SizedBox(
                            height: 20,
                          ),
/*              Text(
                "Your Order ID: $orderID",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),*/
                          //SizedBox(height: 20,),
                          const Text("We are sorry!"),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, 'home', (route) => false);
                            },
                            child: Text('Back to Home'),
                          ),
                        ],
                      ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
