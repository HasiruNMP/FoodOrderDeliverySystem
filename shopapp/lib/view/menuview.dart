import 'package:flutter/material.dart';

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
        title: Text('Menu'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text("Categories"),
                OutlinedButton(onPressed: (){}, child: Text('Add New')),
                Container(
                  child: Card(
                    child: TextButton(
                      onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Snacks'),
                          Icon(Icons.navigate_next),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text("Category Items"),
                OutlinedButton(onPressed: (){}, child: Text('Add New')),
                Container(
                  child: Card(
                    child: TextButton(
                      onPressed: (){},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cheese Burger'),
                          Icon(Icons.navigate_next),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          VerticalDivider(),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                Text("Item")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ItemView extends StatefulWidget {
  const ItemView({Key? key}) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
      ],
    );
  }
}
