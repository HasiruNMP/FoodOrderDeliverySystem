import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:shopapp/model/postCategory.dart';
import 'package:shopapp/model/postItems.dart';
import 'package:shopapp/view/deliveryview.dart';
import 'package:shopapp/view/homeview.dart';
//import 'package:image_picker_web/image_picker_web.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopapp/globals.dart';
import 'package:http/http.dart' as http;

import '../api/apiservice.dart';
import '../model/postEmployee.dart';
import 'loginview.dart';

class Category {
  final int CategoryId;
  final String Name;
  final String ImgUrl;

  Category(
      {required this.CategoryId, required this.Name, required this.ImgUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      CategoryId: json['CategoryId'],
      Name: json['Name'],
      ImgUrl: json['ImgUrl'],
    );
  }
}

class Product {
  final int ProductId;
  final int CategoryId;
  final String Name;
  final String Description;
  final double Price;
  final String ImgUrl;

  Product(
      {required this.ProductId,
      required this.CategoryId,
      required this.Name,
      required this.Description,
      required this.Price,
      required this.ImgUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      ProductId: json['ProductId'],
      CategoryId: json['CategoryId'],
      Name: json['Name'],
      Description: json['Description'],
      Price: json['Price'],
      ImgUrl: json['ImgUrl'],
    );
  }
}

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  int CategoryId = 0;
  String Name = 'null';
  String ImgUrl = 'null';
  late String imagePath;
  late var file;

  void setCategoryId(int CategoryId, String Name, String ImgUrl) {
    setState(() {
      this.CategoryId = CategoryId;
      this.Name = Name;
      this.ImgUrl = ImgUrl;
    });
  }

  String prodId = 'null';
  String categoryName = 'null';
  String description = "null";
  String imgUrl = "null";
  String name = "null";
  String price = "null";

  void updateItemDetails(
    prodId,
    categoryIdItem,
    description,
    imgUrl,
    name,
    price,
  ) {
    setState(() {
      this.prodId = prodId;
      this.categoryName = categoryIdItem;
      this.description = description;
      this.imgUrl = imgUrl;
      this.name = name;
      this.price = price;
    });
  }

  TextEditingController newDescription = TextEditingController();
  TextEditingController newImgUrl = TextEditingController();
  TextEditingController newName = TextEditingController();
  TextEditingController newPrice = TextEditingController();

  TextEditingController newCategory = TextEditingController();

  TextEditingController updateDescription = TextEditingController();
  TextEditingController updateName = TextEditingController();
  TextEditingController updatePrice = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  late Future<List<Category>> futureCategoryData;
  late Future<List<Product>> futureProductData;

  @override
  void initState() {
    super.initState();
    futureCategoryData = fetchCategories();
    futureProductData = fetchProducts();
  }

  Future<List<Category>> fetchCategories() async {
    final response =
        await http.get(Uri.parse('${Urls.apiUrl}/api/Category/getcategories'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Category.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future addCategory(String Name, String ImgUrl) async {
    final response = await http.post(
        Uri.parse(
            '${Urls.apiUrl}/api/Category/postcategory?Name=$Name&ImgUrl=$ImgUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category Added!'),
        ),
      );
    } else {
      throw Exception('Failed to add.');
    }
  }

  Future deleteCategory(int CategoryId) async {
    final response = await http.delete(
        Uri.parse('${Urls.apiUrl}/api/Category?CategoryId=$CategoryId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category Deleted!'),
        ),
      );
    } else {
      throw Exception('Failed to add.');
    }
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(
        '${Urls.apiUrl}/products/getcategoryproducts?categoryId=$CategoryId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future addProduct(int CategoryId, String Name, String Description,
      double Price, String ImgUrl) async {
    final response = await http.post(
        Uri.parse(
            '${Urls.apiUrl}/products/postproduct?CategoryId=$CategoryId&Name=$Name&Description=$Description&Price=$Price&ImgUrl=$ImgUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item Added!'),
        ),
      );
    } else {
      throw Exception('Failed to add.');
    }
  }

  Future updateProduct(int ProductId, int CategoryId, String Name,
      String Description, double Price, String ImgUrl) async {
    final response = await http.put(
        Uri.parse(
            '${Urls.apiUrl}/products/putproductdetails?ProductId=$ProductId&CategoryId=$CategoryId&Name=$Name&Description=$Description&Price=$Price&ImgUrl=$ImgUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Update.');
    }
  }

  Future deleteProduct(int ProductId) async {
    final response = await http.delete(
        Uri.parse('  ${Urls.apiUrl}/products?ProductId=$ProductId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to add.');
    }
  }

  int selCat = 0;
  int selPro = 0;

  Widget addCat() {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  decoration: InputDecoration(hintText: "New Category"),
                  controller: newCategory,
                ),
                OutlinedButton(
                  onPressed: () {
                    if (_formKey2.currentState!.validate()) {
                      addCategory(newCategory.text, 'img.urllll');
                    }
                  },
                  child: Text("Add New"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addPro() {
    return AlertDialog(
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Category Name: " + Name),
              TextFormField(
                decoration: InputDecoration(hintText: "Item Name"),
                controller: newName,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Description"),
                controller: newDescription,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(hintText: "Price"),
                controller: newPrice,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: selectFile,
                child: Text('Select Image'),
              ),
              OutlinedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addProduct(CategoryId, newName.text, newDescription.text,
                        double.parse(newPrice.text), 'img.url');
                  }
                },
                child: Text("Add New"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          VerticalDivider(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Categories",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  child: FutureBuilder<List<Category>>(
                      future: futureCategoryData,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        //
                        // if (snapshot.connectionState == ConnectionState.waiting ||
                        //     !snapshot.hasData) {
                        //   return CircularProgressIndicator();
                        // }

                        if (snapshot.hasData) {
                          List<Category>? data = snapshot.data;
                          return ListView.builder(
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: (selCat == index)
                                      ? Colors.brown.shade100
                                      : Colors.brown.shade50,
                                  child: TextButton(
                                    onPressed: () {
                                      selCat = index;
                                      setCategoryId(data[index].CategoryId,
                                          data[index].Name, data[index].ImgUrl);
                                      // updateItemDetails("null", "null", "null",
                                      //     "null", "null", "null");
                                      futureProductData = fetchProducts();
                                    },
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(data[index].Name),
                                          const Icon(Icons.navigate_next),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                        return Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }),
                ),
                Divider(),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return addCat();
                                  });
                            },
                            child: Text(
                              "ADD NEW",
                              style: TextStyle(color: Colors.indigo),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              deleteCategory(CategoryId);
                            },
                            child: Text(
                              "DELETE",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Products",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 2,
                  child: FutureBuilder<List<Product>>(
                      future: futureProductData,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text("Something went wrong");
                        }
                        //
                        // if (snapshot.connectionState == ConnectionState.waiting ||
                        //     !snapshot.hasData) {
                        //   return CircularProgressIndicator();
                        // }

                        if (snapshot.hasData) {
                          List<Product>? data = snapshot.data;
                          return ListView.builder(
                              itemCount: data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: (selPro == index)
                                      ? Colors.brown.shade100
                                      : Colors.brown.shade50,
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selPro = index;
                                          prodId =
                                              data[index].ProductId.toString();
                                          imgUrl = data[index].ImgUrl;
                                          updateName.text = data[index].Name;
                                          updateDescription.text =
                                              data[index].Description;
                                          updatePrice.text =
                                              data[index].Price.toString();
                                        });

                                        updateItemDetails(
                                          data[index].ProductId,
                                          data[index].CategoryId,
                                          data[index].Description,
                                          data[index].ImgUrl,
                                          data[index].Name,
                                          data[index].Price,
                                        );
                                      },
                                      child: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(data[index].Name),
                                            const Icon(Icons.navigate_next),
                                          ],
                                        ),
                                      )),
                                );
                              });
                        }
                        return Center(
                          child: Container(
                            height: 100,
                            width: 100,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }),
                ),
                Divider(),
                /*Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: (){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return addPro();
                                  },
                              );
                            },
                            child: Text("ADD NEW",style: TextStyle(color: Colors.indigo),),
                          ),),
                        SizedBox(width: 5,),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: (){
                              //deleteCategory(CategoryId);
                            },
                            child: Text("DELETE",style: TextStyle(color: Colors.red),),
                          ),),
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 5,
            child: Form(
              key: _formKey3,
              child: Column(
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Product Details",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 200),
                              child: ListView(
                                children: [
                                  /*Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Item Code'),
                                      SizedBox(height: 5,),
                                      Text(prodId.toString()),
                                    ],
                                  ),
                                ),*/
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Item Code: ${prodId.toString()}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Category Name:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(Name),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Product Image",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      height: 400,
                                      width: 400,
                                      child: Image.network(
                                        "https://fodsfiles.herokuapp.com/static/images/p${prodId}.png",
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //Divider(),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Item Name:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: TextFormField(
                                              controller: updateName,
                                              decoration: InputDecoration(
                                                  hintText: "New Value",
                                                  border: OutlineInputBorder()),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter item name';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  //Divider(),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Description:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: TextFormField(
                                              controller: updateDescription,
                                              decoration: InputDecoration(
                                                  hintText: "New Value",
                                                  border: OutlineInputBorder()),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter description';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  //Divider(),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                "Price:",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: TextFormField(
                                              controller: updatePrice,
                                              decoration: InputDecoration(
                                                  hintText: "New Value",
                                                  border: OutlineInputBorder()),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter item price';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Divider(),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(200, 5, 200, 15),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return addPro();
                                        },
                                      );
                                    },
                                    child: Text(
                                      "ADD NEW",
                                      style: TextStyle(color: Colors.indigo),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      if (_formKey3.currentState!.validate()) {
                                        var updateStatus = await APIService
                                            .updateProductDetails(
                                                int.parse(prodId),
                                                updateName.text,
                                                updateDescription.text,
                                                double.parse(updatePrice.text),
                                                imgUrl);
                                        if (updateStatus == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.blue,
                                              content:
                                                  Text('Updated Successfully!'),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text('Failed to Update!'),
                                            ),
                                          );
                                        }
                                      } else {
                                        return null;
                                      }
                                    },
                                    child: Text(
                                      "UPDATE",
                                      style:
                                          TextStyle(color: Colors.deepOrange),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      if (prodId != 'null') {
                                        var deleteStatus =
                                            await APIService.deleteAccount(
                                                int.parse(prodId));
                                        if (deleteStatus == 0) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.blue,
                                              content:
                                                  Text('Deleted Successfully!'),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content:
                                                  Text('Failed to Delete!'),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                'Please select the item you want to delete!'),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      "DELETE",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(),
        ],
      ),
    );
  }

  Future selectFile() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    Uint8List data = await image!.readAsBytes();
    List<int> list = data.cast();

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://d21f-2402-d000-a400-52ba-fc34-b963-a9c3-6e76.ngrok.io/uploads'));
    request.files.add(
        await http.MultipartFile.fromBytes('image', list, filename: '123.png'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
