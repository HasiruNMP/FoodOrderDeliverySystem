import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'categoryview.dart';

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
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
                FutureBuilder(
                  future:
                      FirebaseFirestore.instance.collection('categories').get(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text("Something went wrong");
                    }

                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      //   return CircularProgressIndicator();
                    }

                    if (snapshot.hasData) {
                      print('has data in items');
                      print(snapshot.data!.size);
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(
                            snapshot.data!.docs.length,
                            (index) {
                              QueryDocumentSnapshot category =
                                  snapshot.data!.docs[index];
                              int categoryId = category['id'];

                              return Container(
                                margin: const EdgeInsets.only(
                                  bottom: 0,
                                ),
                                child: Card(
                                  elevation: 5,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              CategoryView(category['id'],
                                                  category['name']),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 5, right: 5, left: 5),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 110,
                                                width: double.infinity,
                                                child: Image.network(
                                                  category['imgUrl'],
                                                  alignment: Alignment.topLeft,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Container(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 7),
                                                  child: Text(
                                                    category['name'],
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
                              );
                            },
                          ),
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
                // Row(
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: AspectRatio(
                //         aspectRatio: 1 / 1,
                //         child: Card(
                //             child: TextButton(
                //           onPressed: () {
                //             Navigator.pushNamed(context, 'category');
                //           },
                //           child: const Text("category 1"),
                //         )),
                //       ),
                //     ),
                //     const Expanded(
                //       flex: 1,
                //       child: AspectRatio(
                //         aspectRatio: 1 / 1,
                //         child: Card(
                //           child: Text("category 2"),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // Row(
                //   children: const [
                //     Expanded(
                //       flex: 1,
                //       child: AspectRatio(
                //         aspectRatio: 1 / 1,
                //         child: Card(
                //           child: Text("category 3"),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: AspectRatio(
                //         aspectRatio: 1 / 1,
                //         child: Card(
                //           child: Text("category 4"),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // Row(
                //   children: const [
                //     Expanded(
                //       flex: 1,
                //       child: AspectRatio(
                //         aspectRatio: 1 / 1,
                //         child: Card(
                //           child: Text("category 5"),
                //         ),
                //       ),
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: AspectRatio(
                //         aspectRatio: 1 / 1,
                //         child: Card(
                //           child: Text("category 6"),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
