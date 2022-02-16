import 'package:customerapp/view/loginview.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  static String id = 'signup';
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 40),
                  child: TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      // prefixIcon: Icon(Icons.email),
                      labelText: 'First Name',
                      labelStyle: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      // prefixIcon: Icon(Icons.email),
                      labelText: 'Last Name',
                      labelStyle: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      // prefixIcon: Icon(Icons.email),
                      labelText: 'Email',
                      labelStyle: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      // prefixIcon: Icon(Icons.email),
                      labelText: 'Mobile No',
                      labelStyle: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      // prefixIcon: Icon(Icons.email),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: TextFormField(
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(11),
                      ),
                      // prefixIcon: Icon(Icons.email),
                      labelText: 'Re-type Password',
                      labelStyle: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 70, right: 70),
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text('Sign Up'),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already Have and Account?'),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
