import 'dart:async';
import 'dart:io';

import 'package:customerapp/view/categoryview.dart';
import 'package:customerapp/view/checkoutview.dart';
import 'package:customerapp/view/homeview.dart';
import 'package:customerapp/view/loginview.dart';
import 'package:customerapp/view/menuview.dart';
import 'package:customerapp/view/ordersview.dart';
import 'package:customerapp/view/ordertrackingview.dart';
import 'package:customerapp/view/otpverificationview.dart';
import 'package:customerapp/view/signupview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/cart.dart';
import 'firebase_options.dart';

String appState = '1';
StreamController<String> streamController = StreamController<String>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  HttpOverrides.global = new MyHttpOverrides();
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
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      //   initialRoute: '/',
      routes: {
        'otpsetup': (context) => OtpSetup(),
        'home': (context) => const HomeView(),
        'menu': (context) => const MenuView(),
        'category': (context) => CategoryView('0', '0'),
        'checkout': (context) => const CheckoutView(),
        'track': (context) => TrackOrderView('0', '1', 3.4),
        'orders': (context) => Orderview(),
      },
      home: ViewController(streamController.stream),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ViewController extends StatefulWidget {
  ViewController(this.stream);
  final Stream<String> stream;
  @override
  _ViewControllerState createState() => _ViewControllerState();
}

class _ViewControllerState extends State<ViewController> {
  void setAppState(String appStateValue) {
    print(appStateValue);
    setState(() {
      appState = appStateValue;
    });
  }

  @override
  void initState() {
    super.initState();
    widget.stream.listen((appStateValue) {
      setAppState(appStateValue);
    });
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
        setAppState('2');
      } else {
        print('User is signed in!');
        setAppState('0');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (appState == '0') {
      print(appState);
      return HomeView();
    } else if (appState == '2') {
      setState(() {
        appState = '2';
      });
      return OtpSetup();
    } else {
      return Scaffold(
        body: Container(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    }
  }
}
