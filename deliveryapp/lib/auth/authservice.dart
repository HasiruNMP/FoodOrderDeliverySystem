import 'package:deliveryapp/common/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrentUser {
  String id;
  CurrentUser(this.id);
}

class Auth with ChangeNotifier {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static int authState = 0;

  Stream<CurrentUser> get onAuthStateChanged => _auth.authStateChanges().map((User? user) => CurrentUser(user!.uid));

  void listenToAuthStateChanges(){
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        authState = 0;
        notifyListeners();
      } else {
        print('User is signed in!');
        authState = 1;
        notifyListeners();
      }
    });
  }

  void signIn(String email, String password) async{
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(userCredential.user!=null){
        Globals.userID = userCredential.user!.uid;
        authState = 1;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  void signOut() async{
    authState = 0;
    await FirebaseAuth.instance.signOut();
  }

}