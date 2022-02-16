import 'package:flutter/material.dart';


class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Menu'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: Card(
                        child: TextButton(
                          onPressed: (){
                            Navigator.pushNamed(context, 'category');
                          },
                          child: const Text("category 1"),
                        )
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: Card(
                        child: Text("category 2"),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: const [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: Card(
                        child: Text("category 3"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: Card(
                        child: Text("category 4"),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: const [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: Card(
                        child: Text("category 5"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: Card(
                        child: Text("category 6"),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  void test(){}
}

