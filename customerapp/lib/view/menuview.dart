import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/global_urls.dart';
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
    getCategories();

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
    String url = "${Urls.apiUrl}/api/Category/getcategories";
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
            child: (isLoaded)? Container(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(categories.length, (index) {
                  return Container(
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          print(categories[index]['CategoryId'].toString());
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryView(categories[index]['CategoryId'].toString(), categories[index]['Name'])));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 4/3,
                                    child: FittedBox(
                                      fit: BoxFit.fill,
                                      child: Image.network("${Urls.filesUrl}/static/images/c${categories[index]['CategoryId']}.png"),
                                    ),
                                  ),
                                  Container(
                                    child: Text(categories[index]['Name'].toString()),
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
            ) : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
