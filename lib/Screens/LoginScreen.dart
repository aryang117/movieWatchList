import 'package:flutter/material.dart';
import 'package:yellowclassactual/Screens/HomeScreen.dart';
import 'package:yellowclassactual/main.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initFB = Firebase.initializeApp();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> _signInAnonymously() async {
    bool _success = true;
    try {
      final User? user = (await _firebaseAuth.signInAnonymously()).user;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signed in Anonymously as user ${user?.uid}'),
        ),
      );
      _success = true;
    } catch (e) {
      _success = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in Anonymously'),
        ),
      );
    }

    return _success;
  }

  @override
  Widget build(BuildContext context) {
    //width of elements
    final double widthElements = MediaQuery.of(context).size.width - 50;

    return StreamBuilder<User?>(
        stream: _firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          print("snapshotdata" + snapshot.data.toString());
          if (snapshot.hasData) {
            print(snapshot.data);
            return MyHomePage(isUserSignedIn: true);
          } else
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      height: 60,
                      width: widthElements,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        color: Colors.black,
                        onPressed: () async {
                          bool _success = await _signInAnonymously();

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(isUserSignedIn: _success)));
                        },
                        child: Text('Sign In!',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(isUserSignedIn: false)));
                      },
                      child: Text(
                        'Skip for now',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.grey[700],
                            fontSize: 16),
                      )),
                ],
              ),
            );
        });
  }
}
