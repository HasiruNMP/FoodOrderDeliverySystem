import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/view/deliveryview.dart';
import 'package:shopapp/view/menuview.dart';
import 'package:shopapp/view/ordersview.dart';
import 'loginview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedPage = 0;
  final PageController controller = PageController(
    initialPage: 2,
  );

  Widget menuItem(String label, int index, IconData iconData){
    return Container(
      child: AspectRatio(
        aspectRatio: 3/2,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: InkWell(
            onTap: (){
              controller.jumpToPage(index);
              setState(() {
                _selectedPage = index;
              });
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: _selectedPage==index? Colors.brown.shade200 : Colors.brown.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(iconData),
                    SizedBox(height: 3,),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Food Order Delivery System',
        ),
        elevation: 0,
        centerTitle: true,
        //backgroundColor: Colors.deepPurple.shade50,
      ),
      body: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.brown.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      menuItem("Orders", 0, Icons.shopping_bag),
                      menuItem("Menu", 1, Icons.fastfood),
                      menuItem("Delivery", 2, Icons.delivery_dining),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: PageView(
                controller: controller,
                children: const <Widget>[
                  OrdersView(),
                  MenuView(),
                  DeliveryDetailedView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

