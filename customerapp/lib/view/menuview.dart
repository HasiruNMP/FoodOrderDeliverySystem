import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:customerapp/global.dart' as global;
import '../api/apiservice.dart';
import 'categoryview.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late String phonNo;
  var user;
  int userId = 0;
  @override
  void initState() {
    super.initState();

    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      phonNo = auth.currentUser!.phoneNumber!;
      print(phonNo);
      global.phoneNo = phonNo;
      print(global.phoneNo);
    }
    getUserId();
  }

  Future<void> getUserId() async {
    user = await APIService.getUserDetails(global.phoneNo);
    userId = user[0]["UserId"];
    global.userId = userId;
    print(global.userId);
  }
  
    List categories = [];
  bool isLoaded = false;

  Future<void> getCategories() async {
    String url = "https://10.0.2.2:7072/api/Category/getcategories";
    final response = await http.get(Uri.parse(url));
    var resJson = json.decode(response.body);
    if (response.statusCode == 200) {
      var a = resJson as List;
      categories = a.toList();
      print(categories);
      setState(() => isLoaded = true);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Menu'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(2, (index) {
                        return Container(
                          child: Card(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryView("category id", "category name")));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 110,
                                          width: double.infinity,
                                          child: Image.network(""),
                                        ),
                                        Container(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 7),
                                            child: Text("category name"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                /*Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                            child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'category');
                          },
                          child: const Text("category 1"),
                        )),
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          child: Text("category 2"),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: const [
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          child: Text("category 3"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          child: Text("category 4"),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: const [
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          child: Text("category 5"),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          child: Text("category 6"),
                        ),
                      ),
                    )
                  ],
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
