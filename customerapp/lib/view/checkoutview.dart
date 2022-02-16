import 'package:flutter/material.dart';


class CheckoutView extends StatefulWidget {
  const CheckoutView({Key? key}) : super(key: key);

  @override
  _CheckoutViewState createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height/3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text("Items"),
                            )
                        ),
                        Expanded(
                          flex: 6,
                          child: ListView(
                            children: [
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                              Text('Large Pizza x 3'),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text("Total Price: Rs. 5000"),
                          )
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height/11,
                //color: Colors.indigo,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(alignment: Alignment.centerLeft,child: Text('Name: User Name')),
                    Container(alignment: Alignment.centerLeft,child: Text('Contact Number: User Phone Number')),
                    //Container(alignment: Alignment.centerLeft,child: Text('Location')),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(onPressed: (){}, child: Text('Select Location'),),
                //OutlinedButton(onPressed: (){}, child: Text('Select Different Location'),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height/3.2,
                color: Colors.teal,
                child: Container(
                  child: Text('Google Map'),
                ),
              ),
            ),

            Center(
              child: ElevatedButton(
                onPressed: (){},
                child: Text('PAY'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
