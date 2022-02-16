import 'package:deliveryapp/view/historyview.dart';
import 'package:deliveryapp/view/profileview.dart';
import 'package:flutter/material.dart';

class OrderView extends StatefulWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  int _selectedIndex = 0;

  static final List<AppBar> _appBarOptions = <AppBar>[
    AppBar(
      title: const Text('Pending Orders'),
    ),
    AppBar(
      title: const Text('Order History'),
    ),
    AppBar(
      title: const Text('Profile'),
    )
  ];
  static final List<Widget> _widgetOptions = <Widget>[
    // PENDING ORDERS TAB
    SafeArea(
      child: ListView(
        children: [
          ListTile(
            title: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Order No.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: Text(':')),
                          Expanded(flex: 4, child: Text('0003')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Expanded(
                              flex: 2,
                              child: Text('Time',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(child: Text(':')),
                          Expanded(
                              flex: 4, child: Text('3rd Jan 2022, 12.45pm')),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('DELIVERED'),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          flex: 3,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('VIEW'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            title: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Order No.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: Text(':')),
                          Expanded(flex: 4, child: Text('0003')),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Expanded(
                              flex: 2,
                              child: Text('Time',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(child: Text(':')),
                          Expanded(
                              flex: 4, child: Text('3rd Jan 2022, 12.45pm')),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('DELIVERED'),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          flex: 3,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: const Text('VIEW'),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ),

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
      appBar: _appBarOptions.elementAt(_selectedIndex),
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
