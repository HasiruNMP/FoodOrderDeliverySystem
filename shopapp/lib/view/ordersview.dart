import 'package:flutter/material.dart';

class OrdersView extends StatefulWidget {
  const OrdersView({Key? key}) : super(key: key);

  @override
  _OrdersViewState createState() => _OrdersViewState();
}

class _OrdersViewState extends State<OrdersView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car),text: 'New',),
              Tab(icon: Icon(Icons.directions_transit),text: 'Pending',),
              Tab(icon: Icon(Icons.directions_bike),text: 'Completed',),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_car),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
