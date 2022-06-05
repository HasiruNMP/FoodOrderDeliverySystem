import 'package:customerapp/global_urls.dart';
import 'package:flutter/material.dart';
import 'package:customerapp/global.dart' as global;
import '../api/apiservice.dart';
import '../global.dart';
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
    phonNo = Auth.userId;
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
    final response = await http.get(Uri.parse(url),
        headers: {'Authorization': 'Bearer ${Auth.token}'});
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
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Container(
            child: (isLoaded)
                ? Container(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(
                        categories.length,
                        (index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            margin: EdgeInsets.all(6),
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: InkWell(
                              //highlightColor: Colors.blue.withOpacity(0.6),
                              //splashColor: Colors.blue.withOpacity(0.3),
                              onTap: () {
                                print(
                                    categories[index]['CategoryId'].toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryView(
                                        categories[index]['CategoryId']
                                            .toString(),
                                        categories[index]['Name']),
                                  ),
                                );
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    child: Image.network(
                                        "${Urls.filesUrl}/static/images/c${categories[index]['CategoryId']}.png"),
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
                                                Colors.white.withOpacity(0.8),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    categories[index]['Name']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.black87),
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
                          );
                          return InkWell(
                            onTap: () {
                              print(categories[index]['CategoryId'].toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CategoryView(
                                          categories[index]['CategoryId']
                                              .toString(),
                                          categories[index]['Name'])));
                            },
                            child: Card(
                              color: Colors.amber.shade50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 5 / 4,
                                          child: FittedBox(
                                            fit: BoxFit.fill,
                                            child: Image.network(
                                                "${Urls.filesUrl}/static/images/c${categories[index]['CategoryId']}.png"),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Container(
                                          child: Text(
                                            categories[index]['Name']
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}
