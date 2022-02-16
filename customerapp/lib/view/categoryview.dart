import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category 1'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              AspectRatio(
                aspectRatio: 4/3,
                child: Card(
                    child: TextButton(
                      onPressed: (){
                        Navigator.pushNamed(context, 'category');
                      },
                      child: Column(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Image.network('https://picsum.photos/200/300')
                          ),
                          Expanded(
                              flex: 1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    "Large Pizza",
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                  Text(
                                    "Rs. 2590",
                                    style: TextStyle(fontSize: 18, color: Colors.black),
                                  ),
                                ],
                              ),
                          ),
                        ],
                      ),
                    )
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
