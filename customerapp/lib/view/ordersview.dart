import 'package:flutter/material.dart';

class Orderview extends StatefulWidget {
  const Orderview({Key? key}) : super(key: key);

  @override
  _OrderviewState createState() => _OrderviewState();
}

class _OrderviewState extends State<Orderview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('Pending Orders'),
            Container(
              margin: const EdgeInsets.all(10),
              child: Card(
                color: Colors.grey[200],
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Expanded(flex: 2, child: Text('Order No: 0123')),
                          Expanded(flex: 1, child: Text('2021/04/23')),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(flex: 1, child: Text('Rs.1200/=')),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                    //side: const BorderSide(color: Colors.grey)
                                  ),
                                ),
                                onPressed: () {
//   Navigator.pushNamed(context, OtpVerify.id);
                                },
                                child: Text('Recieved'),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ),
                                onPressed: () {
//   Navigator.pushNamed(context, OtpVerify.id);
                                },
                                child: const Text('Track'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Past Orders'),
            Container(
              margin: EdgeInsets.all(10),
              child: Card(
                color: Colors.grey[200],
                child: Container(
                  margin: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Expanded(flex: 2, child: Text('Order No: 0123')),
                          Expanded(flex: 1, child: Text('2021/04/23')),
                        ],
                      ),
                      Row(
                        children: [
                          const Expanded(flex: 1, child: Text('Rs.1200/=')),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: const EdgeInsets.all(15),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                ),
                                onPressed: () {
//   Navigator.pushNamed(context, OtpVerify.id);
                                },
                                child: const Text('View'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
