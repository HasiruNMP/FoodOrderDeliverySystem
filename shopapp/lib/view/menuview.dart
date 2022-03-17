import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:shopapp/model/postCategory.dart';
import 'package:shopapp/model/postItems.dart';
import 'package:shopapp/view/homeview.dart';
import 'package:shopapp/view/ordersview.dart';

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
              child: SideBar(),
            ),
          ),
          Expanded(
            flex: 14,
            child: Container(
              //color: Colors.deepOrange,
              child: MenuView(),
            ),
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
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.food_bank), Text('FODS')],
            ),
          ),
        ),
        Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
        Divider(
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
              children: [
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
        Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
        Divider(color: Colors.black),
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
  int categoryId = 1;
  void setCategoryId(int id) {
    setState(() {
      categoryId = id;
    });
  }

  final queryPost = FirebaseFirestore.instance
      .collection('categories')
      .withConverter<PostCategory>(
        fromFirestore: (snapshot, _) => PostCategory.fromJson(snapshot.data()!),
        toFirestore: (id, _) => id.toJson(),
      );

  @override
  Widget build(BuildContext context) {
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
        title: Text('Menu'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text("Categories"),
                OutlinedButton(onPressed: () {}, child: Text('Add New')),
                Expanded(
                  child: FirestoreListView<PostCategory>(
                    pageSize: 4,
                    query: queryPost,
                    itemBuilder: (context, snapshot) {
                      final post = snapshot.data();
                      return Card(
                        child: TextButton(
                          onPressed: () {
                            setCategoryId(post.id);
                            print(categoryId);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post.name),
                              Icon(Icons.navigate_next),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text("Category Items"),
                OutlinedButton(onPressed: () {}, child: Text('Add New')),
                Expanded(
                  child: FirestoreListView<PostItems>(
                    pageSize: 4,
                    query: queryPost2,
                    itemBuilder: (context, snapshot) {
                      final post = snapshot.data();
                      return Card(
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(post.name),
                              Icon(Icons.navigate_next),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 5,
            child: Column(
              children: [Text("Item")],
            ),
          ),
        ],
      ),
    );
  }
}
