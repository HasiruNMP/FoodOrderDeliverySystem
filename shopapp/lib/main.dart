import 'package:flutter/material.dart';
import 'package:shopapp/view/assignview.dart';
import 'package:shopapp/view/deliveryview.dart';
import 'package:shopapp/view/homeview.dart';
import 'package:shopapp/view/loginview.dart';
import 'package:shopapp/view/menuview.dart';
import 'package:shopapp/view/navigationview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOODS Shop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AssignView(),
    );
  }
}
