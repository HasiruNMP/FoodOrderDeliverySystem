import 'dart:convert';

import 'package:deliveryapp/auth/authservice.dart';
import 'package:deliveryapp/common/globals.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  var profiledetails = [];
  bool loaded = false;

  Future fetchprofiledetails() async {
    String url =
        "${Urls.apiUrl}/employee/getprofiledetails?EmployeeId=${Globals.EmployeeId}";

    final response = await http.get(Uri.parse(url));
    var resJson = json.decode(response.body);

    if (response.statusCode == 200) {
      var a = resJson as List;
      profiledetails = a.toList();
      print(profiledetails);
      setState(() => loaded = true);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    fetchprofiledetails();
    super.initState();
  }

  TextStyle st1 = TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SafeArea(
        child: (loaded)
            ? Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text('Name'),
                              subtitle: Text(
                                profiledetails[0]['Name'].toString(),
                                style: st1,
                              ),
                            ),
                            ListTile(
                              title: Text('Username'),
                              subtitle: Text(
                                profiledetails[0]['Username'].toString(),
                                style: st1,
                              ),
                            ),
                            ListTile(
                              title: Text('Phone'),
                              subtitle: Text(
                                profiledetails[0]['Phone'].toString(),
                                style: st1,
                              ),
                            ),
                            ListTile(
                              title: Text('NIC'),
                              subtitle: Text(
                                profiledetails[0]['NIC'].toString(),
                                style: st1,
                              ),
                            ),
                            ListTile(
                              title: Text('License No'),
                              subtitle: Text(
                                profiledetails[0]['License'].toString(),
                                style: st1,
                              ),
                            ),
                          ],
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
              )
            : Center(
                child: CircularProgressIndicator(),
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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
