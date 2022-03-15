import 'package:flutter/material.dart';

class DeliveryView extends StatefulWidget {
  const DeliveryView({Key? key}) : super(key: key);

  @override
  State<DeliveryView> createState() => _DeliveryViewState();
}

class _DeliveryViewState extends State<DeliveryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text('Add'),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 200.0,
                    child: ListView(
                      children: [
                        Card(
                          child: Text('Name'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            VerticalDivider(
              color: Colors.black26,
            ),
            Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Name'),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Username'),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Password'),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Phone Number'),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'NIC'),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'License'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
