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
            child: Column(
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
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Image.network(
                                        Cart.basketItems[index].imgUrl),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
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
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                Cart.basketItems[index].name,
                                              )),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        cart.updateProduct(
                                                            Cart.basketItems[
                                                                index],
                                                            Cart
                                                                    .basketItems[
                                                                        index]
                                                                    .quantity -
                                                                1);
                                                      });
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove)),
                                                Text(
                                                  Cart.basketItems[index]
                                                      .quantity
                                                      .toString(),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        cart.updateProduct(
                                                            Cart.basketItems[
                                                                index],
                                                            Cart
                                                                    .basketItems[
                                                                        index]
                                                                    .quantity +
                                                                1);
                                                      });
                                                    },
                                                    icon: Icon(Icons.add_box)),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  'Rs.${Cart.basketItems[index].price.toString()}')),
                                        ),
                                      ],
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Price: Rs.${Cart.totalPrice.toString()}"),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'checkout');
                              },
                              child: const Text("Checkout")),
                        ],
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
