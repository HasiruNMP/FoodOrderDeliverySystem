import 'package:customerapp/api/apiservice.dart';
import 'package:customerapp/controller/ordermodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderCompleted extends StatefulWidget {
  LatLng delLoc;
  double total;
  OrderCompleted(this.delLoc,this.total);

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

  void placeOrder() async {
      orderID = await APIService.addNewOrder(
        NewOrderModel(
          userId: 1,
          dateTime: DateTime.now().toString(),
          totalPrice: widget.total,
          lat: widget.delLoc.latitude,
          lng: widget.delLoc.longitude,
        ),
      );
      setState(() {
        p = true;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: SafeArea(
        child: (orderID != "0")? Center(
          child: (orderID != "error") ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
              SizedBox(height: 20,),
              const Text("Order Successful!"),
              SizedBox(height: 20,),
              Text(
                "Your Order ID: $orderID",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20,),
              const Text("Thank You!"),
              SizedBox(height: 20,),
            ],
          ):Column(
            children: [
              Icon(
                Icons.error,
                color: Colors.redAccent,
                size: 100,
              ),
              SizedBox(height: 20,),
              const Text("Error Processing Order!"),
              SizedBox(height: 20,),
/*              Text(
                "Your Order ID: $orderID",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),*/
              //SizedBox(height: 20,),
              const Text("We are sorry!"),
              SizedBox(height: 20,),
            ],
          ),
        ): Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}
