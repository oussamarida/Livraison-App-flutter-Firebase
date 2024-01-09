import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_livrai/screens/pages/Menu.dart';
import 'package:last_livrai/screens/pages/Order.dart';
import 'package:last_livrai/screens/pages/Panie.dart';
import 'package:last_livrai/screens/pages/Profile.dart';
import 'package:last_livrai/screens/pages/livreur/mapsLivreur.dart';
import 'package:last_livrai/screens/pages/livreur/menuLivreu.dart';
import 'package:last_livrai/screens/login.dart'; // Import your login screen

class HomeLivreur extends StatefulWidget {
  final User? user;

  HomeLivreur({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeLivreur> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    MenuLivreur(),
    MapScreenLivreur(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user != null) {
            return Scaffold(
              body: _pages[_currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                elevation: 10,
                backgroundColor: Colors.white,
                selectedItemColor: const Color.fromARGB(255, 184, 33, 243),
                unselectedItemColor: Colors.grey,
                selectedFontSize: 14,
                unselectedFontSize: 12,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Menu',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Maps',
                  ),
                ],
              ),
            );
          } else {
            // Redirect to login screen if user is not authenticated
            return Login();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
