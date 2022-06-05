import 'package:deliveryapp/common/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentUser {
  String id;
  CurrentUser(this.id);
}

class Auth with ChangeNotifier {
  static String token ='0';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<CurrentUser> get onAuthStateChanged =>
      _auth.authStateChanges().map((User? user) => CurrentUser(user!.uid));

  void signIn(String username, String password) async {
    String email = username + '@fods.lk';
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
