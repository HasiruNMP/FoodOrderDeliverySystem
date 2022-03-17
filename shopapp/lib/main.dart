import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopapp/firebase_options.dart';
import 'package:shopapp/view/assignview.dart';
import 'package:shopapp/view/deliveryview.dart';
import 'package:shopapp/view/homeview.dart';
import 'package:shopapp/view/loginview.dart';
import 'package:shopapp/view/menuview.dart';
import 'package:shopapp/view/navigationview.dart';
import 'package:shopapp/view/newordersview.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FOODS Shop App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return HomeView();
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
