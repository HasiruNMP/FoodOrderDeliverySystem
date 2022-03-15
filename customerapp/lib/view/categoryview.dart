import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  int categoryId;
  CategoryView(this.categoryId);

  @override
  _CategoryViewState createState() => _CategoryViewState(this.categoryId);
}

class _CategoryViewState extends State<CategoryView> {
  int categoryId;
  _CategoryViewState(this.categoryId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category 1'),
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
                              onTap: () {},
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
