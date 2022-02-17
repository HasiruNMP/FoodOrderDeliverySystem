import 'package:flutter/material.dart';

import 'loginview.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const ListTile(
              title: Text('Name:'),
              subtitle: Text('Mahinda Rajapaksha'),
            ),
            const ListTile(
              title: Text('Username:'),
              subtitle: Text('@mahiraja'),
            ),
            const ListTile(
              title: Text('Phone Number:'),
              subtitle: Text('+94 123 456 781'),
            ),
            const ListTile(
              title: Text('NIC:'),
              subtitle: Text('12345678V'),
            ),
            const ListTile(
              title: Text('Liscence:'),
              subtitle: Text('47163356353'),
            ),
            const Expanded(child: SizedBox()),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginView();
                    },
                  ),
                );
              },
              child: const Text('SIGN OUT'),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
