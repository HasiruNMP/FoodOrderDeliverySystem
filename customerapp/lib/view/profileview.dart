
import 'package:customerapp/main.dart';
import 'package:customerapp/archive/otpverificationview.dart';
import 'package:customerapp/view/userregister.dart';
import 'package:customerapp/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:customerapp/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var user;
  String fname = '';
  String lname = '';
  String phoneNo = '';
  bool loading = false;
  var deleteStatus;
  @override
  void initState() {
    super.initState();
    CallApi();
  }

  Future<void> CallApi() async {
    user = await APIService.getUserDetails(global.phoneNo);
    updateUi(user);
  }

  void updateUi(dynamic user) {
    setState(() {
      fname = user[0]["FirstName"];
      lname = user[0]["LastName"];
      phoneNo = user[0]["Phone"];
      loading = true;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Profile'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            loading == true
                ? Column(
                    children: [
                      /*ListTile(
                        title: const Text('First Name:'),
                        subtitle: Text(fname,style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      ListTile(
                        title: const Text('Last Name'),
                        subtitle: Text(lname,style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),*/
                      ListTile(
                        title: const Text('Name'),
                        subtitle: Text('$fname $lname',style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                      ListTile(
                        title: const Text('Phone Number:'),
                        subtitle: Text(global.phoneNo,style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    ],
                  ),
            Container(
              //alignment: Alignment.centerLeft,
              child: TextButton(
                  onPressed: () async {
                    deleteStatus = await APIService.deleteAccount(global.phoneNo);
                    showAlertDialog2(context);
                  },
                  child: Text('Delete Account')),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: () {
                  signOutAlertDialog(context);
                },
                child: const Text('SIGN OUT'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('auth', 0);
    await prefs.setString('phone', '0');
    await prefs.setString('token', '0');
    Navigator.pushNamedAndRemoveUntil(context, 'auth', (route) => false);
  }

  showAlertDialog2(BuildContext context) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: const Text(
        "Yes",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red,
        ),
      ),
      onPressed: () {
        if (deleteStatus == 1) {
          logout();
         // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => OtpSetup()), (route) => false);
        } else {
          showAlertDialog(context, 'Failed to delete this account!');
        }
        //Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(
        "No",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      //title: Text("Confirm"),
      content: const Text("Are you sure you want to delete this account?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signOutAlertDialog(BuildContext context) {
    // set up the buttons
    Widget continueButton = TextButton(
      child: const Text(
        "Yes",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.red,
        ),
      ),
      onPressed: () {
        logout();
        //Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: const Text(
        "No",
        style: TextStyle(
          fontSize: 16.0,
          color: Colors.black,
        ),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      //title: Text("Confirm"),
      content: const Text("Are you sure you want to sign out?"),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

showAlertDialog(BuildContext context, String message) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Alert Box"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
