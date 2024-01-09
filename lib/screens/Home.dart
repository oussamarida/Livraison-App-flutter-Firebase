import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:last_livrai/screens/pages/Menu.dart';
import 'package:last_livrai/screens/pages/Order.dart';
import 'package:last_livrai/screens/pages/Panie.dart';
import 'package:last_livrai/screens/pages/Profile.dart';

class Home extends StatefulWidget {
  final User? user;

  Home({this.user});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Menu(),
    Panie(),
    Order(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
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
          ), BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panie',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_shipping,
            ),
            label: 'Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
         
        ],
      ),
    );
  }
}
