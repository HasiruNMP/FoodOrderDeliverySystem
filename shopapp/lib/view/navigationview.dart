import 'package:flutter/material.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:shopapp/view/deliveryview.dart';
import 'package:shopapp/view/menuview.dart';
import 'package:shopapp/view/newordersview.dart';
import 'package:shopapp/view/ordersview.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  PageController page = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: page,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              // backgroundColor: Colors.amber
              // openSideMenuWidth: 200
            ),
            title: Column(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: 150,
                  ),
                  //child: Image.network('https://firebasestorage.googleapis.com/v0/b/ddhprr-fods.appspot.com/o/common%2Flogo.png?alt=media&token=908ad592-fd14-4ae1-b2ce-2d95e85eca75'),
                ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            footer: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'mohada',
                style: TextStyle(fontSize: 15),
              ),
            ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'NEW ORDERS',
                onTap: () {
                  page.jumpToPage(0);
                },
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                priority: 1,
                title: 'ORDERS',
                onTap: () {
                  page.jumpToPage(1);
                },
                icon: const Icon(Icons.home),
              ),
              SideMenuItem(
                priority: 2,
                title: 'MENU',
                onTap: () {
                  page.jumpToPage(2);
                },
                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                priority: 3,
                title: 'DELIVERY',
                onTap: () {
                  page.jumpToPage(3);
                },
                icon: const Icon(Icons.file_copy_rounded),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Logout',
                onTap: () {},
                icon: const Icon(Icons.file_copy_rounded),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  color: Colors.white,
                  child: const NewOrdersView(),
                ),
                Container(
                  color: Colors.white,
                  child: const OrdersView(),
                ),
                Container(
                  color: Colors.white,
                  child: const MenuView(),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
