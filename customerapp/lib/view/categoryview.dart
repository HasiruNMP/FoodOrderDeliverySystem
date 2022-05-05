import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/global_urls.dart';
import 'package:customerapp/view/itemview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/cart.dart';
import 'cartview.dart';

class CategoryView extends StatefulWidget {
  String categoryId;
  String name;
  CategoryView(this.categoryId, this.name);

  @override
  _CategoryViewState createState() => _CategoryViewState(this.categoryId, this.name);
}

class _CategoryViewState extends State<CategoryView> {
  String categoryId;
  String name;
  _CategoryViewState(this.categoryId, this.name);
  
  List products = [];
  bool isLoaded = false;

  Future<void> getProductsByCategory() async {
    String url = "${Urls.apiUrl}/products/getcategoryproducts?categoryId=" + categoryId.toString();
    print(url);
    final response = await http.get(Uri.parse(url));
    var resJson = json.decode(response.body);
    if (response.statusCode == 200) {
      var a = resJson as List;
      products = a.toList();
      print(products);
      setState(() => isLoaded = true);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    getProductsByCategory();
  }

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
              //Navigator.pop(context);
              //Navigator.pop(context);
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
        child: Container(
          child: (isLoaded)? ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (BuildContext context, index) {
              return AspectRatio(
                aspectRatio: 4/3,
                child: Container(
                  margin: const EdgeInsets.all(5),
                  child: Card(
                      child: InkWell(
                        highlightColor: Colors.blue.withOpacity(0.6),
                        splashColor: Colors.blue.withOpacity(0.3),
                        onTap: () {
                          print(products[index]);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ItemView(
                              itemID: products[index]['ProductId'],
                              name: products[index]['Name'],
                              price: products[index]['Price'].toString(),
                              imgUrl: products[index]['ImgUrl'],
                              discription: products[index]['Description'],
                            ),),
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.all(8),
                              child: Image.network(
                                "${Urls.filesUrl}/static/images/p${products[index]['ProductId']}.png",
                                height: 200,
                              ),
                            ),
                            Container(
                              margin:
                              EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(products[index]['Name'].toString(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "Rs. "+products[index]['Price'].toString(),
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
                ),
              );
            },
          ): Center(child: CircularProgressIndicator(),),
        ),
      ),
    );
  }
}
