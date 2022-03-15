import 'package:deliveryapp/auth/authservice.dart';
import 'package:deliveryapp/view/loginview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StateManager extends StatefulWidget {
  const StateManager({Key? key}) : super(key: key);

  @override
  State<StateManager> createState() => _StateManagerState();
}

class _StateManagerState extends State<StateManager> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<Auth>(context,listen: false);
    
    return StreamBuilder<CurrentUser>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            final currentUser = snapshot.data;

            if ((currentUser != null)) {
              return StateManager();
            } else {
              return LoginView();
            }
          }
          return Scaffold(
            body: Container(
              child: Center(
                child: Text('ZXC'),
              ),
            ),
          );
        }
    );
  }
}
