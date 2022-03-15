import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryapp/auth/authservice.dart';
import 'package:deliveryapp/common/globals.dart';
import 'package:flutter/material.dart';
import 'loginview.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  CollectionReference employees = FirebaseFirestore.instance.collection('employees');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Container(
                  child: FutureBuilder<DocumentSnapshot>(
                    future: employees.doc('sample-delivery-person').get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                      if (snapshot.hasError) {
                        return Text("Something went wrong");
                      }

                      if (snapshot.hasData && !snapshot.data!.exists) {
                        return Text("Document does not exist");
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                        return Column(
                          children: [
                            ListTile(
                              title: Text('Name'),
                              subtitle: Text(data['name']),
                            ),
                            ListTile(
                              title: Text('Username'),
                              subtitle: Text(data['username']),
                            ),
                            ListTile(
                              title: Text('Phone'),
                              subtitle: Text(data['phone']),
                            ),
                            ListTile(
                              title: Text('NIC'),
                              subtitle: Text(data['nic']),
                            ),
                            ListTile(
                              title: Text('License No'),
                              subtitle: Text(data['license']),
                            ),
                          ],
                        );
                      }

                      return Text("loading");
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  //color: Colors.teal,
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Auth().signOut();
                      },
                      child: const Text('SIGN OUT'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileDataItem extends StatelessWidget {
  ProfileDataItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  String label;
  String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 17,
          ),
        ),
      ],
    );
  }
}
