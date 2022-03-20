// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:shopapp/model/postCategory.dart';
import 'package:shopapp/model/postItems.dart';
import 'package:shopapp/view/deliveryview.dart';
import 'package:shopapp/view/homeview.dart';

class MenuHomeView extends StatefulWidget {
  const MenuHomeView({Key? key}) : super(key: key);

  @override
  State<MenuHomeView> createState() => _MenuHomeViewState();
}

class _MenuHomeViewState extends State<MenuHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              child: const SideBar(),
            ),
          ),
          const Expanded(
            flex: 14,
            child: MenuView(),
          ),
        ],
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.food_bank), Text('FODS')],
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MenuHomeView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                Text(
                  'MENU',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.black,
        ),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HomeView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.store,
                  color: Colors.black,
                ),
                Text(
                  'ORDERS',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const DeliveryView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.pedal_bike,
                  color: Colors.black,
                ),
                Text(
                  'DELIVERY',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
      ],
    );
  }
}

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  String categoryId = "null";
  String selectedCategory = "null";
  void setCategoryId(String id, String cat) {
    setState(() {
      categoryId = id;
      selectedCategory = cat;
    });
  }

  final queryPost = FirebaseFirestore.instance
      .collection('categories')
      .withConverter<PostCategory>(
        fromFirestore: (snapshot, _) => PostCategory.fromJson(snapshot.data()!),
        toFirestore: (id, _) => id.toJson(),
      );

  String prodId = "null";
  String categoryIdItem = "null";
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
      this.categoryIdItem = categoryIdItem;
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

  CollectionReference category =
      FirebaseFirestore.instance.collection('categories');
  Future<void> addCategory(newCategory) {
    return category
        .add({
          'id': "null",
          'name': newCategory,
          'imgUrl': "null",
        })
        .then((value) => category.doc(value.id).update({'id': value.id}))
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category Added'),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to report: $error'),
            ),
          ),
        );
  }

  CollectionReference product =
      FirebaseFirestore.instance.collection('products');
  Future<void> addItm(newDescription, newImgUrl, newName, newPrice) {
    return product
        .add({
          'prodId': "null",
          'categoryId': categoryId,
          'description': newDescription,
          'imgUrl': newImgUrl,
          'name': newName,
          'price': newPrice,
        })
        .then((value) => product.doc(value.id).update({'prodId': value.id}))
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item Added'),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to report: $error'),
            ),
          ),
        );
  }

  void update(String id, String fieldName, String newValue) {
    product
        .doc(id)
        .update({
          fieldName: newValue,
        })
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Value Updated'),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to report: $error'),
            ),
          ),
        );
  }

  void deleteItem() {
    product
        .doc(prodId)
        .delete()
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Item Deleted'),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to report: $error'),
            ),
          ),
        );
  }

  void deleteCategory() {
    category
        .doc(categoryId)
        .delete()
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category Deleted'),
            ),
          ),
        )
        .catchError(
          (error) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to report: $error'),
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _formKey2 = GlobalKey<FormState>();
    final queryPost2 = FirebaseFirestore.instance
        .collection('products')
        .where('categoryId', isEqualTo: categoryId)
        .withConverter<PostItems>(
          fromFirestore: (snapshot, _) => PostItems.fromJson(snapshot.data()!),
          toFirestore: (prodId, _) => prodId.toJson(),
        );
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Menu'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 2,
                  child: FirestoreListView<PostCategory>(
                    pageSize: 4,
                    query: queryPost,
                    itemBuilder: (context, snapshot) {
                      final post = snapshot.data();
                      return Card(
                        child: TextButton(
                          onPressed: () {
                            setCategoryId(post.id, post.name);
                            updateItemDetails(
                                "null", "null", "null", "null", "null", "null");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post.name),
                              const Icon(Icons.navigate_next),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(selectedCategory),
                    ElevatedButton(
                        onPressed: () {
                          deleteCategory();
                        },
                        child: Text("Delete Category"))
                  ],
                )),
                Divider(),
                Expanded(
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
                              addCategory(newCategory.text);
                            }
                          },
                          child: Text("Add New"),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Category Items",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 2,
                  child: FirestoreListView<PostItems>(
                    pageSize: 4,
                    query: queryPost2,
                    itemBuilder: (context, snapshot) {
                      final post = snapshot.data();
                      return Card(
                        child: TextButton(
                          onPressed: () {
                            updateItemDetails(
                              post.prodId,
                              post.categoryId,
                              post.description,
                              post.imgUrl,
                              post.name,
                              post.price,
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post.name),
                              const Icon(Icons.navigate_next),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Category Name: " + selectedCategory),
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
                            decoration:
                                InputDecoration(hintText: "Description"),
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
                          TextFormField(
                            decoration: InputDecoration(hintText: "imgUrl"),
                            controller: newImgUrl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          OutlinedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                addItm(newDescription.text, newImgUrl.text,
                                    newName.text, newPrice.text);
                              }
                            },
                            child: Text("Add New"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Item Code: " + prodId,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  //child: Image(image: NetworkImage(imgUrl)),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Item Name:",
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(name),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: updateName,
                            decoration: InputDecoration(
                                hintText: "New Value",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              update(prodId, "name", updateName.text);
                            },
                            child: Text("Update"),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Description:",
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(description),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: updateDescription,
                            decoration: InputDecoration(
                                hintText: "New Value",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              update(prodId, "description",
                                  updateDescription.text);
                            },
                            child: Text("Update"),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Price:",
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(price),
                        ),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: updatePrice,
                            decoration: InputDecoration(
                                hintText: "New Value",
                                border: OutlineInputBorder()),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              update(prodId, "price", updatePrice.text);
                            },
                            child: Text("Update"),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    )
                  ],
                ),
                Divider(),
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Category Name:",
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(selectedCategory),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(),
                Expanded(
                    child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        deleteItem();
                      },
                      child: Text("Delete Item")),
                )),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
