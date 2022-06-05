

import 'package:customerapp/view/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50.0),
          SizedBox(
            width: 300,
            height: 300,
            child: const Image(
              color: Colors.brown,
              image: NetworkImage(
                  'https://images.squarespace-cdn.com/content/v1/5f4d8391808aeb43341150c6/1599060209675-WOBESQ5EPIMNKMPROJMB/FODS-LOG2O.png?format=1500w'),
            ),
          ),
          SizedBox(height: 50.0),
          Center(
            child: ElevatedButton(
              child: Text("Get Started"),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                );
              },
            ),
          ),
        ],
      )
    );
  }
}