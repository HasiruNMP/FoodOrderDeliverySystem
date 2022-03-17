import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customerapp/view/otpverificationview.dart';
import 'package:customerapp/view/userregister.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String phonNo;
  @override
  void initState() {
    super.initState();
    getPhoneNo();
  }

  void getPhoneNo() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      setState(() {
        phonNo = auth.currentUser!.phoneNumber!;
      });

      print(phonNo);
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OtpSetup()));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(phonNo.toString())
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> profileData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  //return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                  return Column(
                    children: [
                      ListTile(
                        title: const Text('First Name:'),
                        subtitle: Text(profileData['fname']),
                      ),
                      ListTile(
                        title: const Text('Last Name'),
                        subtitle: Text(profileData['lname']),
                      ),
                      ListTile(
                        title: const Text('Full Name'),
                        subtitle: Text(profileData['name']),
                      ),
                      ListTile(
                        title: const Text('Phone Number:'),
                        subtitle: Text(phonNo.toString()),
                      ),
                    ],
                  );
                }

                return const Text("loading");
              },
            ),
            Container(
              //alignment: Alignment.centerLeft,
              child:
                  TextButton(onPressed: () {}, child: Text('Delete Account')),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                logout();
              },
              child: const Text('SIGN OUT'),
            ),
          ],
        ),
      ),
    );
  }
}
