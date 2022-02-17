import 'package:flutter/material.dart';
import 'package:shopapp/view/loginview.dart';
import 'package:shopapp/view/ordersview.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
              child: OrdersView(),
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
              children: [
                Icon(Icons.food_bank),
                Text('FODS')
              ],
            ),
          ),
        ),
        Divider(
            color: Colors.black
        ),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: (){},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.menu,color: Colors.black,),
                Text('MENU',style: TextStyle(color: Colors.black),)
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
            onPressed: (){},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.store,color: Colors.black,),
                Text('ORDERS',style: TextStyle(color: Colors.black),)
              ],
            ),
          ),
        ),
        Divider(
            color: Colors.black
        ),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: (){},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pedal_bike,color: Colors.black,),
                Text('DELIVERY',style: TextStyle(color: Colors.black),)
              ],
            ),
          ),
        ),
        Divider(
            color: Colors.black
        ),
      ],
    );
  }
}

class ShortCuts extends StatelessWidget {
  const ShortCuts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(200.0),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Card(
                  child: TextButton(
                    onPressed: (){},
                    child: Center(
                      child: Text('MENU'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Card(
                  child: TextButton(
                    onPressed: (){},
                    child: Center(
                      child: Text('ORDERS'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: AspectRatio(
                aspectRatio: 1,
                child: Card(
                  child: TextButton(
                    onPressed: (){},
                    child: Center(
                      child: Text('DELIVERY'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
