import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/view/homeview.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPassworController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String Useremail;
  bool status = true;
  bool _obscureText = true;
  late String _password;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      setState(() {
        status = false;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _userEmailController.text,
              password: _userPassworController.text);

      Useremail = _userPassworController.text;

      print('Sign in Succefully {$Useremail}');

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          status = true;
        });
        print('No user found for that email.');
        showAlertDialog('No user found for that email.', context);
      } else if (e.code == 'wrong-password') {
        setState(() {
          status = true;
        });
        print('Wrong password provided for that user.');
        showAlertDialog('Wrong password provided for that user.', context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Login')),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 350),
        child: Column(
          children: [
            SizedBox(height: 50.0),
            SizedBox(
              width: 300,
              height: 300,
              child: const Image(
                color: Colors.brown,
                image: NetworkImage(
                    'https://images.squarespace-cdn.com/content/v1/5f4d8391808aeb43341150c6/1599060209675-WOBESQ5EPIMNKMPROJMB/FODS-LOG2O.png?format=1500w'),
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 350),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 50.0),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10),
                              child: TextFormField(
                                controller: _userEmailController,
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.3),
                                  labelText: 'Email',
                                  suffixIcon: const Icon(
                                    Icons.email,
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                enableSuggestions: false,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: TextFormField(
                                controller: _userPassworController,
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.withOpacity(0.3),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    onPressed: _toggle,
                                    icon: const Icon(
                                      Icons.remove_red_eye_rounded,
                                      color: Colors.black,
                                    ),
                                  ),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 7) {
                                    return 'Please enter a long password';
                                  }
                                  return null;
                                },
                                onSaved: (val) => _password = val!,
                                obscureText: _obscureText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(right: 50, left: 50, top: 40),
                        child: SizedBox(
                          width: 250,
                          height: 50,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.brown[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _signInWithEmailAndPassword();
                                } else {
                                  return null;
                                }

                                //
                              },
                              child: status == true
                                  ? Text(
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : const CircularProgressIndicator(
                                      backgroundColor: Colors.black38,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

showAlertDialog(String message, BuildContext context) {
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
