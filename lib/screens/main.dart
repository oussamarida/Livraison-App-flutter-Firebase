import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last_livrai/screens/Home.dart';
import 'package:last_livrai/screens/auth.dart';
import 'package:last_livrai/screens/pages/livreur/home.dart';
import 'package:last_livrai/screens/pages/livreur/menuLivreu.dart';

class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user != null) {
            // Check the user's role in Firestore
            FirebaseFirestore.instance
                .collection('users') // Replace with your Firestore collection
                .doc(user.uid)
                .get()
                .then((DocumentSnapshot documentSnapshot) {
              if (documentSnapshot.exists) {
                String userRole = documentSnapshot['rool'] ?? ''; // Assuming 'role' is the attribute storing user's role
                print(documentSnapshot['rool']);
                if (userRole == 'Client' && mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(user: user)));
                } else if (userRole == 'Livreu' && mounted) {
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeLivreur(user: user)));
                } else if (mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()));
                }
              }
            });

            return CircularProgressIndicator(); // Loading while checking user role
          } else {
            return Auth(); // Not signed in
          }
        } else {
          return CircularProgressIndicator(); // Loading
        }
      },
    );
  }
}
