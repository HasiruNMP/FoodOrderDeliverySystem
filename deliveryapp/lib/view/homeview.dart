import 'dart:async';

import 'package:deliveryapp/view/historyview.dart';
import 'package:deliveryapp/view/orderview.dart';
import 'package:deliveryapp/view/pendingview.dart';
import 'package:deliveryapp/view/profileview.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';


class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  int _selectedIndex = 0;
  IO.Socket socket = IO.io('https://106f-2402-d000-a500-123b-bc62-280d-ecbb-6fc4.in.ngrok.io/', OptionBuilder().setTransports(['websocket']).build());

  static final List<Widget> _widgetOptions = <Widget>[
    // PENDING ORDERS TAB
    const PendingOrdersView(),

    // ORDER HISTORY TAB
    const CompletedOrdersView(),

    // PROFILE TAB
    const ProfileDetails(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings).listen((Position? position) {
      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
      socket.emit('message', position);
    });

    return "";
  }

  void connectAndListen(){
    socket.onConnect((_) {
      print('connect');
    });
    socket.on('message', (data) {
      print(data);
    });
    socket.onDisconnect((_) => print('disconnect'));
  }


  @override
  void initState() {
    _determinePosition();
    connectAndListen();

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
