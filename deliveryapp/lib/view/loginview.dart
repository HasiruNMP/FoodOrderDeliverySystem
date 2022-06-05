import 'dart:convert';

import 'package:deliveryapp/auth/authservice.dart';
import 'package:deliveryapp/view/homeview.dart';
import 'package:deliveryapp/view/orderview.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../common/globals.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final tecUsername = TextEditingController();
  final tecPassword = TextEditingController();

  Future<void> login() async {
    String tok ='';
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('${Urls.apiUrl}/auth/login'));
    request.body = json.encode({
      "userID": tecUsername.text,
      "password": tecPassword.text,
      "userType": "DL"
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      tok = await response.stream.bytesToString();
      print(tok);
      //Auth.token = tok;
      Globals.userName = tecUsername.text;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You Are Signed In!'),),
      );
      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) {return HomeView();},
),
);
    }
    else {
      print(response.reasonPhrase);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign In Failed!'),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: SizedBox(),
            ),
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: tecUsername,
                    decoration: InputDecoration(
                        labelText: 'Username', border: OutlineInputBorder()),
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    controller: tecPassword,
                    decoration: const InputDecoration(
                        labelText: 'Password', border: OutlineInputBorder()),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    child: const Text('LOGIN'),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
