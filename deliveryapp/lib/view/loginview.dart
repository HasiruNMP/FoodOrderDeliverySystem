import 'package:deliveryapp/view/orderview.dart';
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
              children: const [
                Expanded(
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: TextField(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const OrderView();
                          },
                        ),
                      );
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
