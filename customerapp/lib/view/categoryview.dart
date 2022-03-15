import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/view/itemview.dart';
import 'package:flutter/material.dart';

import '../controller/cart.dart';
import 'cartview.dart';

class CategoryView extends StatefulWidget {
  int categoryId;
  String name;
  CategoryView(this.categoryId, this.name);

  @override
  _CategoryViewState createState() =>
      _CategoryViewState(this.categoryId, this.name);
}

class _CategoryViewState extends State<CategoryView> {
  int categoryId;
  String name;
  _CategoryViewState(this.categoryId, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => CartView(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 5),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(4),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
              child: Text(
                Cart.count.toString(),
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('products')
                    .where('categoryId', isEqualTo: categoryId)
                    .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  // if (snapshot.connectionState == ConnectionState.waiting ||
                  //     !snapshot.hasData) {
                  //   return CircularProgressIndicator();
                  // }

                  if (snapshot.hasData) {
                    print('has data in items');

                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          QueryDocumentSnapshot catItems =
                              snapshot.data!.docs[index];

                          return Container(
                            margin: const EdgeInsets.all(5),
                            height: 250,
                            child: Card(
                                child: InkWell(
                              highlightColor: Colors.blue.withOpacity(0.6),
                              splashColor: Colors.blue.withOpacity(0.3),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemView(
                                      itemID: catItems['prodId'],
                                      imgUrl: catItems['imgUrl'],
                                      name: catItems['name'],
                                      price: catItems['price'],
                                      discription: catItems['description'],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(8),
                                    child: Image.network(
                                      catItems['imgUrl'],
                                      height: 200,
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          catItems['name'],
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'Rs.${catItems['price']}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
