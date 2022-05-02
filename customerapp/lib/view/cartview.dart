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
                                  height:
                                      (MediaQuery.of(context).size.height) / 6,
                                  child: Card(
                                    child: Row(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            margin: EdgeInsets.all(10),
                                            child: Image.network(
                                              "https://fodsfiles.herokuapp.com/static/images/Burger.jpg",
                                              //Cart.basketItems[index].imgUrl,
                                              width: 150,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10, top: 20),
                                              child: Column(
                                                children: [
                                                  Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        Cart.basketItems[index]
                                                            .name,
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
                                                                    Cart.basketItems[
                                                                        index],
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
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          'Rs.${Cart.basketItems[index].price.toString()}')),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                cart.remove(
                                                    Cart.basketItems[index]);
                                              },
                                            ),
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
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "Total Price: Rs.${Cart.totalPrice.toString()}"),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, 'checkout');
                                      },
                                      child: const Text("Checkout")),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
          ),
        ),
      );
    });
  }
}
