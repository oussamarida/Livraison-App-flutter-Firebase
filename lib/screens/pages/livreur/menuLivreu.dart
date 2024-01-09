import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_livrai/screens/login.dart';
import 'package:last_livrai/screens/signin.dart';

class MenuLivreur extends StatelessWidget {
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
                  child: Text("Name: ${user.email}"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
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
