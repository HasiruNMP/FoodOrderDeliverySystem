import 'package:flutter/material.dart';
import 'package:shopapp/view/completedordersview.dart';
import 'package:shopapp/view/newordersview.dart';
import 'package:shopapp/view/pendingordersview.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

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
      child: Column(
        children: <Widget>[
          SizedBox(height: 5,),
          ButtonsTabBar(
            backgroundColor: Colors.brown,
            unselectedBackgroundColor: Colors.brown.shade100,
            unselectedLabelStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
            tabs: [
              Tab(
                //icon: Icon(Icons.directions_transit),
                text: "   New Orders   ",
              ),
              Tab(
                //icon: Icon(Icons.directions_transit),
                text: "   Pending Orders   ",
              ),
              Tab(
                //icon: Icon(Icons.directions_transit),
                text: "   Completed Orders   ",
              ),
            ],
          ),
          Divider(),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                NewOrdersView(),
                PendingOrdersView(),
                CompletedOrdersView()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
