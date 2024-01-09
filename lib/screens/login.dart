import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last_livrai/screens/Home.dart';
import 'package:last_livrai/screens/pages/livreur/home.dart';
import 'package:last_livrai/screens/pages/livreur/menuLivreu.dart';
import 'package:last_livrai/screens/signin.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            // Check if the user exists in Firestore
            FirebaseFirestore.instance
                .collection('users') // Replace with your Firestore collection
                .doc(user.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                // Existing user
                // print(documentSnapshot['rool']);
                if (documentSnapshot['rool'] == 'Client') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Home(user: user)),
                  );
                } else if (documentSnapshot['rool'] == 'Livreu') {
                   Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeLivreur()));
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              } else {
                // New user
                // Add the user data to Firestore if needed
                // Then navigate to the appropriate page
                // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewUserPage()));
              }
            });

            return CircularProgressIndicator(); // Loading while checking user status
          } else {
            return LoginPage(); // Not signed in
          }
        } else {
          return CircularProgressIndicator(); // Loading
        }
      },
    );
  }
}
