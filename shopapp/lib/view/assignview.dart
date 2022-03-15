import 'package:flutter/material.dart';

class AssignView extends StatefulWidget {
  const AssignView({Key? key}) : super(key: key);

  @override
  State<AssignView> createState() => _AssignViewState();
}

class _AssignViewState extends State<AssignView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(child: Text('text field ekak danna')),
                ),
                Expanded(
                  child: Text('list view danna'),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.black26,
            ),
            Column(
              children: [
                Container(
                  child: Text('this is a container'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Assign'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
