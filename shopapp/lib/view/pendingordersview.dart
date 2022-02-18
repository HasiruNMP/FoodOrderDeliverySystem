import 'package:flutter/material.dart';

class PendingOrdersView extends StatefulWidget {
  const PendingOrdersView({Key? key}) : super(key: key);

  @override
  _PendingOrdersViewState createState() => _PendingOrdersViewState();
}

class _PendingOrdersViewState extends State<PendingOrdersView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    title: Text('Order No: 23457'),
                    subtitle: Text('12:23 PM - 13.02.2022'),
                  ),
                ),
              )
            ],
          ),
        ),
        VerticalDivider(
          color: Colors.black26,
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: Text('Order Description'),
                        alignment: Alignment.center,
                      ),
                      Container(
                        child: Text('Customer Name'),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        child: Text('Timestamp'),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          minLines: 10,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Order Items',
                            //errorText: 'Error message',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      Container(
                        child: Text('Total Price'),
                        alignment: Alignment.centerLeft,
                      ),
                    ],
                  ),
                ),
                CheckboxListTile(
                  title: Text('Delivered'),
                  value: true,
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
                CheckboxListTile(
                  title: Text('Recieved'),
                  value: true,
                  onChanged: null,
                  controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                ),
                OutlinedButton(onPressed: (){}, child: Text('TRACK Delivery')),
                Container(
                  child: Text('Location'),
                  alignment: Alignment.centerLeft,
                ),
                Container(
                  height: MediaQuery.of(context).size.height/2.5,
                  color: Colors.teal,
                  child: Text('Google Map'),
                ),
                //SizedBox(height: 20,),
                //ElevatedButton(onPressed: (){}, child: Text('ASSIGN'),),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
