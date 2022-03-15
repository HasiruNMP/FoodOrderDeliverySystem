import 'package:advance_notification/advance_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';

import '../controller/cart.dart';
import 'homeview.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  double quantityPrice = 0;
  late String userEmail = 'rakshitha1@gmail.com';
  late String fname;
  late String lname;
  late String fullname;
  late String phoneNo = '0766807668';
  late String totalPrice;
  late String items;
  late int orderNum;
  late String orderId;
  late Timestamp timeStamp;
  late GeoPoint location;
  List<String> itemsArr = [];

  @override
  void initState() {
    super.initState();

    //  getUserMail();
    totalPrice = Cart.totalPrice.toString();
    getUserInfo();

    itemsArr = [
      for (int i = 0; i < Cart.basketItems.length; i++)
        " ${Cart.basketItems[i].name} * ${Cart.basketItems[i].quantity}  Rs.${Cart.basketItems[i].quantity * Cart.basketItems[i].price}"
    ];
    print(itemsArr);
  }

  // void getUserMail() {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   if (auth.currentUser != null) {
  //     userEmail = auth.currentUser.email;
  //     print(auth.currentUser.email);
  //   }
  // }

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
      "email": userEmail,
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
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => HomeView(),
          ),
        );
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
        .collection('orders')
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
        .collection("orders")
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
          "customerLocation": GeoPoint(53.483959, -2.244644),
          "totalPrice": totalPrice,
          "customerPhone": phoneNo,
          "email": userEmail,
          "orderStatus": 'Pending',
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
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Name: User Name')),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text('Contact Number: User Phone Number')),
                    //Container(alignment: Alignment.centerLeft,child: Text('Location')),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {},
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
                  child: Text('Google Map'),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  getOrderId();
                },
                child: Text('PAY'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
