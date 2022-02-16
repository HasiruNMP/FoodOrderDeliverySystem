import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: ListView(
                  children: [
                    Container(
                      height: (MediaQuery.of(context).size.height)/6,
                      child: Card(
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: AspectRatio(
                                aspectRatio: 1/1,
                                child: Image.network("https://picsum.photos/200"),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: IconButton(icon: Icon(Icons.close), onPressed: (){},),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text("Large Pizza")
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            IconButton(onPressed: (){}, icon: Icon(Icons.add_box)),
                                            Text("1"),
                                            IconButton(onPressed: (){}, icon: Icon(Icons.add_box)),
                                          ],
                                        ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Rs 2000")
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  child: Row(
                    children: [
                      Text("Total Price: Rs. 5000"),
                      ElevatedButton(
                        onPressed: (){},
                        child: const Text("Checkout")
                      ),
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
