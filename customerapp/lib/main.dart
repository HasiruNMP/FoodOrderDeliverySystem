import 'package:customerapp/view/categoryview.dart';
import 'package:customerapp/view/checkoutview.dart';
import 'package:customerapp/view/homeview.dart';
import 'package:customerapp/view/loginview.dart';
import 'package:customerapp/view/menuview.dart';
import 'package:customerapp/view/ordertrackingview.dart';
import 'package:customerapp/view/signupview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/cart.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); //run the application
  runApp(ChangeNotifierProvider(
    create: (context) => Cart(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeView(),
        'menu': (context) => const MenuView(),
        'category': (context) => CategoryView(0, '0'),
        'checkout': (context) => const CheckoutView(),
        'track': (context) => TrackOrderView('0'),
      },
    );
  }
}
