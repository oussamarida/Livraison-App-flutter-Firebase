import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:last_livrai/screens/Home.dart';
import 'package:last_livrai/screens/pages/livreur/home.dart';
import 'package:last_livrai/screens/registre.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  bool isLoading = false;

  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Container(
              margin: EdgeInsets.all(12),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/TakeAway.png',
                      height: 300,
                    ),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Email',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                          left: 14.0,
                          bottom: 8.0,
                          top: 8.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.length == 0) {
                          return "Email cannot be empty";
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return "Please enter a valid email";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure3,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure3
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure3 = !_isObscure3;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Password',
                        enabled: true,
                        contentPadding: const EdgeInsets.only(
                          left: 14.0,
                          bottom: 8.0,
                          top: 15.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return "Password cannot be empty";
                        }
                        if (!regex.hasMatch(value)) {
                          return "Please enter a valid password (min. 6 characters)";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      elevation: 5.0,
                      height: 40,
                      onPressed: () {
                        setState(() {
                          visible = true;
                          isLoading = true;
                        });
                        signIn(emailController.text, passwordController.text);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: visible,
                      child: Container(
                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      elevation: 5.0,
                      height: 40,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Register(),
                          ),
                        );
                      },
                      color: Colors.black,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        User? user = FirebaseAuth.instance.currentUser;

        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            final rool = documentSnapshot.get('rool') as String?;
            print(rool == "Client");

            if (rool == "Client" && mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home(user: user)),
              );
            } else if (rool == "Livreu" && mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeLivreur(user: user)),
              );
            } else {
              print('Invalid or null "rool" value in the document');
            }
          } else {
            print('Document does not exist on the database');
          }
        }).whenComplete(() {
          setState(() {
            isLoading = false;
          });
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
