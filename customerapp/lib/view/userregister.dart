
import 'package:customerapp/controller/usermodel.dart';
import 'package:customerapp/global.dart';
import 'package:customerapp/main.dart';
import 'package:customerapp/view/homeview.dart';
import 'package:flutter/material.dart';

import '../api/apiservice.dart';

class userRegister extends StatefulWidget {
  @override
  _userRegister createState() => _userRegister();
}

class _userRegister extends State<userRegister> {
  late String phonNo;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fnameController = TextEditingController();
  final TextEditingController _lnameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    phonNo = Auth.userId;
  }

  userModel user = userModel(
    firstName: '',
    lastName: '',
    phone: '',
    userId: 0,
  );

  Future<void> addUserData() async {
    user.firstName = _fnameController.text;
    user.lastName = _lnameController.text;
    user.phone = phonNo;
    bool saveResponse = await APIService.adduser(user);
    if(saveResponse == true){
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    }else{
      showAlertDialog(context);
    }
  }

  // void addUserData() {
  //   FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(phonNo.toString())
  //       .set({
  //         "fname": _fnameController.text,
  //         "lname": _lnameController.text,
  //         "name": '${_fnameController.text} ${_lnameController.text}',
  //         "mobileNo": phonNo,
  //       })
  //       .then(
  //         (value) => print('Data Added Succesfully'),
  //       )
  //       .catchError((error) => print("Failed: $error"));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Name'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _fnameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'First Name',
                            labelStyle: TextStyle(
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the First Name';
                            } else if (RegExp(
                                    r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                .hasMatch(value)) {
                              return 'Enter a Valid Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller: _lnameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Last Name',
                            labelStyle: TextStyle(
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                            // suffixIcon: Icon(
                            //   Icons.error,
                            // ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter the second Name';
                            } else if (RegExp(
                                    r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                .hasMatch(value)) {
                              return 'Enter a Valid Name';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    addUserData();
                  } else {
                    return null;
                  }
                },
                child: const Text('CONTINUE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
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
    content: Text('Something Wrong'),
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
