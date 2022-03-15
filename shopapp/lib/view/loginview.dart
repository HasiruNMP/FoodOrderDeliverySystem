import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
      ),
      body: Column(
        children: [
          Image(
            image: NetworkImage(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Username'),
          ),
          TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
