import 'package:flutter/material.dart';
import 'package:shopapp/view/completedordersview.dart';
import 'package:shopapp/view/newordersview.dart';
import 'package:shopapp/view/pendingordersview.dart';

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
          automaticallyImplyLeading: false,
          title: const Text('Orders'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.directions_car),
                text: 'New',
              ),
              Tab(
                icon: Icon(Icons.directions_transit),
                text: 'Pending',
              ),
              Tab(
                icon: Icon(Icons.directions_bike),
                text: 'Completed',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NewOrdersView(),
            PendingOrdersView(),
            CompletedOrdersView(),
          ],
        ),
      ),
    );
  }
}
