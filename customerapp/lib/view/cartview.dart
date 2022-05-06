import 'package:customerapp/api/apiservice.dart';
import 'package:customerapp/controller/ordermodel.dart';
import 'package:customerapp/global_urls.dart';
import 'package:customerapp/view/setlocationview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/cart.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Cart.basketItems.length == 0
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                          child: Icon(
                        Icons.report_gmailerrorred_outlined,
                        size: 100,
                        color: Colors.blue,
                      )),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'No Items in Your Cart',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Add some items! ',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 8,
                        child: ListView(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: Cart.basketItems.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: (MediaQuery.of(context).size.height) / 6,
                                  child: Card(
                                    color: Colors.amber.shade50,
                                    child: Row(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            margin: EdgeInsets.all(8),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(5),
                                              child: Image.network(
                                                "${Urls.filesUrl}/static/images/p${Cart.basketItems[index].id}.png",
                                                //Cart.basketItems[index].imgUrl,
                                                width: 150,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(top: 20),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      margin: const EdgeInsets.only(left: 12),
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        Cart.basketItems[index].name,
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      )),
                                                  Container(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                cart.updateProduct(
                                                                    Cart.basketItems[
                                                                    index],
                                                                    Cart.basketItems[index]
                                                                        .quantity -
                                                                        1);
                                                              });
                                                            },
                                                            icon: const Icon(Icons
                                                                .remove_circle_outlined)),
                                                        Text(
                                                          Cart
                                                              .basketItems[
                                                          index]
                                                              .quantity
                                                              .toString(),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                cart.updateProduct(
                                                                    Cart.basketItems[index],
                                                                    Cart.basketItems[index]
                                                                        .quantity +
                                                                        1);
                                                              });
                                                            },
                                                            icon: const Icon(Icons
                                                                .add_circle)),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets.only(left: 12),
                                                      alignment:
                                                      Alignment.centerLeft,
                                                      child: Text(
                                                          'Rs.${Cart.basketItems[index].price.toString()}',style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black87,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),),
                                                    ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),),
                                        Container(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            icon: Icon(Icons.close,color: Colors.black45,),
                                            onPressed: () {
                                              cart.remove(
                                                  Cart.basketItems[index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: Colors.grey.shade100,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Total: Rs.${Cart.totalPrice.toString()}",style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight:
                                  FontWeight.bold,
                                ),),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SetLocation()),
                                      );
                                      /*APIService.addNewOrder(
                                      NewOrderModel(
                                        userId: 1,
                                        dateTime: DateTime.now().toString(),
                                        totalPrice: 123,
                                        lat: 12,
                                        lng: 12,
                                      ),
                                    );*/
                                    },
                                    child: const Text("Checkout")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
