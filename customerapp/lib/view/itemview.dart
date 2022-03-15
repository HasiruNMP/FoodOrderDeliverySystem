import 'package:flutter/material.dart';

class ItemView extends StatefulWidget {

  String itemID;
  String title;

  ItemView(this.itemID,this.title, {Key? key}) : super(key: key);

  @override
  State<ItemView> createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(''),
              ),
            ),
            Text('Price'),
            Text('Description'),
            Container(
              alignment: Alignment.center,
              child: Row(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.add_box)),
                  Text("1"),
                  IconButton(onPressed: (){}, icon: Icon(Icons.add_box)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton(onPressed: (){}, child: Text('Add To Cart')),
            )
          ],
        ),
      ),
    );
  }
}
