import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_livrai/screens/Home.dart';
import 'package:last_livrai/screens/auth.dart';
import 'package:last_livrai/screens/login.dart';
import 'package:last_livrai/screens/signin.dart';

class ProfileLive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            return Center(
                child: Column(
              children: [
                Container(
                  child: Text("Name: ${user.displayName}"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text("Logout"),
                ),
              ],
            ));
          } else {
            return LoginPage();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
