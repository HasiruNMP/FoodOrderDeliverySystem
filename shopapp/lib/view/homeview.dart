import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/view/deliveryview.dart';
import 'package:shopapp/view/menuview.dart';
import 'package:shopapp/view/ordersview.dart';

import 'loginview.dart';

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
              child: const SideBar(),
            ),
          ),
          const Expanded(
            flex: 14,
            child: OrdersView(),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.food_bank), Text('FODS')],
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MenuHomeView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                Text(
                  'MENU',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.black,
        ),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HomeView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.store,
                  color: Colors.black,
                ),
                Text(
                  'ORDERS',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const DeliveryView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.pedal_bike,
                  color: Colors.black,
                ),
                Text(
                  'DELIVERY',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              showAlertDialog1(context);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
      ],
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  showAlertDialog1(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "YES",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red,
        ),
      ),
      onPressed: () {
        logout();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginView()),
            (route) => false);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "NO",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text("Log Out"),
      content: Text("Are you sure you want to log out?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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
                    onPressed: () {},
                    child: const Center(
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
                    onPressed: () {},
                    child: const Center(
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
                    onPressed: () {},
                    child: const Center(
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
