import 'package:customerapp/view/homeview.dart';
import 'package:customerapp/view/loading_screen.dart';
import 'package:customerapp/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../global.dart';

class AuthController extends StatefulWidget {
  const AuthController({Key? key}) : super(key: key);

  @override
  State<AuthController> createState() => _AuthControllerState();
}

class _AuthControllerState extends State<AuthController> {

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
      Auth.token = token!;
      Auth.userId = phone!;
      print("${Auth.userId}---------${Auth.token}");
    }

    setState(() {loading = false;});
  }

  @override
  void initState() {
    getAuthState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(!loading){
      if(authState == 1){
        return HomeView();
      }else{
        return WelcomeScreen();
      }
    }
    return LoadingScreen();
  }
}