import 'dart:async';
import 'dart:io';

import 'package:customerapp/view/auth_controller.dart';
import 'package:customerapp/view/categoryview.dart';
import 'package:customerapp/view/checkoutview.dart';
import 'package:customerapp/view/homeview.dart';
import 'package:customerapp/view/loginview.dart';
import 'package:customerapp/view/menuview.dart';
import 'package:customerapp/view/ordersview.dart';
import 'package:customerapp/view/ordertrackingview.dart';
import 'package:customerapp/archive/otpverificationview.dart';
import 'package:customerapp/view/signupview.dart';
import 'package:customerapp/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/cart.dart';

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
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white
      ),
      initialRoute: 'auth',
      routes: {
        'auth': (context) => AuthController(),
        'main': (context) => ViewController(streamController.stream),
        //'otpsetup': (context) => OtpSetup(),
        'home': (context) => const HomeView(),
        'menu': (context) => const MenuView(),
        'category': (context) => CategoryView('0', '0'),
        //'checkout': (context) => const CheckoutView(),
        'track': (context) => TrackOrderView('0', '1', 3.4),
        'orders': (context) => Orderview(),
      },
      //home: ViewController(streamController.stream),
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

  bool loading = false;
  int? authState = 0;
  String? token = '';
  String? phone = '';

  void getAuthState() async {
    setState(() {loading = true;});

    final prefs = await SharedPreferences.getInstance();

    authState = prefs.getInt('auth');
    token = prefs.getString('token');
    phone = prefs.getString('phone');

    if(authState == 1){
      setAppState('0');
    }else{
      setAppState('2');
    }

    setState(() {loading = false;});
  }

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
      return WelcomeScreen();
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
