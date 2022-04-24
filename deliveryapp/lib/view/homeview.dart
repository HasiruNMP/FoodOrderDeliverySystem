import 'package:deliveryapp/view/historyview.dart';
import 'package:deliveryapp/view/orderview.dart';
import 'package:deliveryapp/view/pendingview.dart';
import 'package:deliveryapp/view/profileview.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

/*  static final List<AppBar> _appBarOptions = <AppBar>[
    AppBar(
      title: const Text('Pending Orders'),
    ),
    AppBar(
      title: const Text('Order History'),
    ),
    AppBar(
      title: const Text('Profile'),
    )
  ];*/
  static final List<Widget> _widgetOptions = <Widget>[
    // PENDING ORDERS TAB
    const PendingOrdersView(),

    // ORDER HISTORY TAB
    const HistoryView(),

    // PROFILE TAB
    const ProfileView()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: _appBarOptions.elementAt(_selectedIndex),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.pending), label: 'Pending'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
