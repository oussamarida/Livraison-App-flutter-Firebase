import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:last_livrai/firebase_options.dart';
import 'package:last_livrai/screens/Home.dart';
import 'package:last_livrai/screens/auth.dart';
import 'package:last_livrai/screens/login.dart';
import 'package:last_livrai/screens/main.dart';
import 'package:last_livrai/screens/pages/Menu.dart';
import 'package:last_livrai/screens/pages/Order.dart';
import 'package:last_livrai/screens/pages/Panie.dart';
import 'package:last_livrai/screens/pages/Profile.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livraison App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/auth': (context) => Auth(),
        '/login': (context) => Login(),
        '/': (context) => Main(),
        '/home': (context) => Home(),
        '/Order': (context) => Order(),
        '/Menu': (context) => Menu(),
        '/Profile': (context) => Profile(),
        '/Panie': (context) => Panie(),
      },
    );
  }
}
