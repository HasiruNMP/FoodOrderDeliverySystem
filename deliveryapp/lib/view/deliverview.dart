import 'package:flutter/material.dart';

class DeliverView extends StatefulWidget {
  const DeliverView({Key? key}) : super(key: key);

  @override
  _DeliverViewState createState() => _DeliverViewState();
}

class _DeliverViewState extends State<DeliverView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('#Order No'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Customer Name'),
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text('Phone No    '),
                  ),
                  OutlinedButton(onPressed: () {}, child: Text('Call'),),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Delivery Location'),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 1.5,
                color: Colors.teal,
                child: Text('google map'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      _settingModalBottomSheet(context);
                    },
                    child: Text('View Order')),
                  OutlinedButton(
                    onPressed: () {}, child: Text('Mark As Delivered')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        height: 270,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: Text('Total Price: Rs.5000'),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  child: ListView(
                    children: [
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                      Text('Large Pizza'),
                    ],
                  )
                ),
              ),
            ],
          ),
        ),
      );
    }
  );
}
