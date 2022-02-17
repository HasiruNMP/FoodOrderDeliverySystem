import 'package:flutter/material.dart';

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
        title: Text('Your Profile'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const ListTile(
              title: Text('Name:'),
              subtitle: Text('Mahinda Rajapaksha'),
            ),
            const ListTile(
              title: Text('Email'),
              subtitle: Text('mahinda@rajapaksha.com'),
            ),
            const ListTile(
              title: Text('Phone Number:'),
              subtitle: Text('0701234567'),
            ),
            Container(
              //alignment: Alignment.centerLeft,
              child: TextButton(onPressed: (){},
                child: Text('Change Password')
              ),
            ),
            Container(
              //alignment: Alignment.centerLeft,
              child: TextButton(onPressed: (){},
                  child: Text('Delete Account')
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {},
              child: const Text('SIGN OUT'),
            ),
          ],
        ),
      ),
    );
  }
}
