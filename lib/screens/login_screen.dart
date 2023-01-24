import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import '../landing_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = "login-screen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
    // User is not signed in
    if (!snapshot.hasData) {
      return SignInScreen(
        showAuthActionSwitch: false,
        headerBuilder: (context, constraints, _) {
          return  Padding(
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: Column(
                  children: const [
                    Text("Shop App",style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold
                    ),),
                    Text("Vendor",style:TextStyle(fontSize: 20))
                  ],
                ),
              )
            ),
          );
        },
        subtitleBuilder: (context, action){
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              action == AuthAction.signIn ? 'Welcome to Shop App-Vendor! Please sign in to continue.':
              'Welcome to Shop App-Vendor! Please create an account to continue',
              style: const TextStyle(color: Colors.grey),textAlign: TextAlign.center,
            ),
          );
        },
      );
    }

    // Render your application if authenticated
     return const LandingScreen();
    },

      );
  }
}
