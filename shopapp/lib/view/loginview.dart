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
        title: const Center(child: Text('Login')),
      ),
      body: Column(
        children: [
          const Image(
            image: NetworkImage(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
          ),
          const TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Username'),
          ),
          const TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}
