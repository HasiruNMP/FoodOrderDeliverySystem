import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/cart.dart';
import '../controller/item.dart';

class ItemView extends StatefulWidget {
  int itemID;
  String name;
  String imgUrl;
  String price;
  String discription;

  ItemView(
      {required this.itemID,
      required this.name,
      required this.price,
      required this.imgUrl,
      required this.discription});

  @override
  State<ItemView> createState() => _ItemViewState(
      imgUrl: imgUrl,
      price: price,
      name: name,
      itemID: itemID,
      discription: discription);
}

class _ItemViewState extends State<ItemView> {
  int itemID;
  String name;
  String imgUrl;
  String price;
  String discription;
  int quantity = 1;

  _ItemViewState(
      {required this.itemID,
      required this.name,
      required this.price,
      required this.imgUrl,
      required this.discription});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(builder: (context, cart, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(imgUrl),
                ),
              ),
              Text('Rs.$price'),
              Text(discription),
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (quantity == 1) {
                              quantity = 1;
                            } else {
                              quantity--;
                            }
                          });
                        },
                        icon: Icon(Icons.remove)),
                    Text(
                      quantity.toString(),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: Icon(Icons.add_box)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      final List<Item> items = [
                        Item(
                            name: name,
                            price: double.parse(price),
                            imgUrl: imgUrl,
                            quantity: quantity),
                      ];
                      cart.add(items[0]);
                      print('quntitiy $quantity');
                    },
                    child: Text('Add To Cart')),
              )
            ],
          ),
        ),
      );
    });
  }
}
