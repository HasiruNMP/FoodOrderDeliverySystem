import 'package:deliveryapp/auth/authservice.dart';
import 'package:deliveryapp/view/homeview.dart';
import 'package:deliveryapp/view/loadingview.dart';
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
    auth.listenToAuthStateChanges();

    return ChangeNotifierProvider<Auth>(
      create: (context) => Auth(),
      child: Consumer<Auth>(
        builder: (context, themeProvider, child) {
          return (Auth.authState==1)? HomeView() : LoginView();
        },
      ),
    );
  }
}



/*class _StateManagerState extends State<StateManager> {
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<Auth>(context,listen: false);

    return StreamBuilder<CurrentUser>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            final currentUser = snapshot.data;

            if ((currentUser == null)) {
              return LoginView();
            } else {
              return StateManager();
            }
          }
          return LoadingView();
        }
    );
  }
}*/
