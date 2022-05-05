import 'dart:io';

import 'package:deliveryapp/auth/authservice.dart';
import 'package:deliveryapp/view/homeview.dart';
import 'package:deliveryapp/view/loginview.dart';
import 'package:deliveryapp/view/orderview.dart';
import 'package:deliveryapp/view/statemanager.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => Auth()),
        ChangeNotifierProvider<Auth>(create: (context) => Auth()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FODS',
        theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.white
        ),
        home: StateManager(),
      ),
    );
  }
}
