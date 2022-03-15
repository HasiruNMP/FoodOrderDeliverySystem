import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  String id;
  CurrentUser(this.id);
}

class Auth {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<CurrentUser> get onAuthStateChanged => _auth.authStateChanges().map((User? user) => CurrentUser(user!.uid));

  void signInWithEmail(String email, String password) async{
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

  void signOut() async{
    await FirebaseAuth.instance.signOut();
  }

}