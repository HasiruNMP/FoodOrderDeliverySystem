import 'package:advance_notification/advance_notification.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:customerapp/global_urls.dart';
import '../controller/cart.dart';
import '../controller/item.dart';
import 'cartview.dart';

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
          actions: [
            Badge(
              position: BadgePosition.topEnd(top: 0, end: 3),
              animationDuration: Duration(milliseconds: 300),
              badgeColor: Colors.yellow,
              animationType: BadgeAnimationType.slide,
              badgeContent: Text(Cart.count.toString(),),
              child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  iconSize: 27,
                  onPressed: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => CartView(),
                      ),
                    );
                  }),
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
        body: SafeArea(
          child: ListView(
            children: [
              AspectRatio(
                aspectRatio: 4/4,
                child: Image.network(
                  "${Urls.filesUrl}/static/images/p${widget.itemID}.png",
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 20),
                child: Text(discription),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, top: 20),
                child: Text('Rs.$price',style: const TextStyle(
                  fontSize: 22,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                          icon: Icon(Icons.remove_circle_outlined)),
                      Text(
                        quantity.toString(),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          icon: Icon(Icons.add_circle_rounded)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      final List<Item> items = [
                        Item(
                            id: itemID,
                            name: name,
                            price: double.parse(price),
                            imgUrl: imgUrl,
                            quantity: quantity),
                      ];
                      cart.add(items[0]);
                      const AdvanceSnackBar(
                        message: "Item Added!",
                        //mode: Mode.ADVANCE,
                        duration: Duration(seconds: 2),
                        //bgColor: Colors.blue,
                        //textColor: Colors.black,
                        //iconColor: Colors.black,
                      ).show(context);
                      print('qauntitiy $quantity');
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
