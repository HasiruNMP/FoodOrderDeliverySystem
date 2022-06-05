
import 'package:customerapp/global_urls.dart';
import 'package:customerapp/view/itemview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controller/cart.dart';
import 'cartview.dart';
import 'package:badges/badges.dart';

class CategoryView extends StatefulWidget {
  String categoryId;
  String name;
  CategoryView(this.categoryId, this.name);

  @override
  _CategoryViewState createState() =>
      _CategoryViewState(this.categoryId, this.name);
}

class _CategoryViewState extends State<CategoryView> {
  String categoryId;
  String name;
  _CategoryViewState(this.categoryId, this.name);

  List products = [];
  bool isLoaded = false;

  Future<void> getProductsByCategory() async {
    String url = "${Urls.apiUrl}/products/getcategoryproducts?categoryId=" +
        categoryId.toString();
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
        child: Container(
          child: (isLoaded)
              ? ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(10),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              //highlightColor: Colors.blue.withOpacity(0.6),
                              //splashColor: Colors.blue.withOpacity(0.3),
                              onTap: () {
                                print(products[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemView(
                                      itemID: products[index]['ProductId'],
                                      name: products[index]['Name'],
                                      price:
                                          products[index]['Price'].toString(),
                                      imgUrl: products[index]['ImgUrl'],
                                      discription: products[index]
                                          ['Description'],
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    child: Image.network(
                                      "${Urls.filesUrl}/static/images/p${products[index]['ProductId']}.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 5,
                                          child: Container(),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            color:
                                                Colors.white.withOpacity(0.6),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    products[index]['Name']
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Rs. " +
                                                        products[index]['Price']
                                                            .toString(),
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*child: InkWell(
                          //highlightColor: Colors.blue.withOpacity(0.6),
                          //splashColor: Colors.blue.withOpacity(0.3),
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
                          child: Container(
                            child: Column(
                              children: [
                                Expanded(
                                  child:
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(products[index]['Name'].toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black87,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Rs. "+products[index]['Price'].toString(),
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )*/
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}
