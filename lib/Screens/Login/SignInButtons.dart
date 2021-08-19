import 'package:flutter/material.dart';

// 3rd Party Packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

// screens
import '../initHive/initializeHive.dart';

// Google Sign In Button, isUserSignedIn is passed as true, therefore there is an add button
Widget googleSignInButton(
    FirebaseAuth _firebaseAuth, BuildContext _context, double _width) {
  return Container(
    width: _width,
    height: 60,
    child: SignInButton(Buttons.Google, onPressed: () async {
      UserCredential userCredential;

      final GoogleSignInAccount? _googleSignInAccount =
          await GoogleSignIn().signIn();
      final GoogleSignInAuthentication _googleAuth =
          await _googleSignInAccount!.authentication;

      final _googleAuthCred = GoogleAuthProvider.credential(
          accessToken: _googleAuth.accessToken, idToken: _googleAuth.idToken);

      userCredential =
          await _firebaseAuth.signInWithCredential(_googleAuthCred);

      final user = userCredential.user;

      try {
        ScaffoldMessenger.of(_context).showSnackBar(
            SnackBar(content: Text('Sign In ${user!.uid} with Google')));
      } catch (e) {
        ScaffoldMessenger.of(_context)
            .showSnackBar(SnackBar(content: Text('Failed')));
      }
    }),
  );
}

// Anon Sign in Button isUserSignedIn is passed as true, therefore there is  add button
Widget anonymousSignInButton(
    double _widgetWidth, Function _signInAnonymously, BuildContext _context) {
  return Center(
    child: Container(
      height: 60,
      width: _widgetWidth,
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: Colors.black,
        onPressed: () async {
          bool _success = await _signInAnonymously();

          Navigator.of(_context).push(MaterialPageRoute(
              builder: (context) => InitializeHive(isUserSignedIn: _success)));
        },
        child: Text('Sign In Anonymously!',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
    ),
  );
}

// Skip Sign in Button, isUserSignedIn is passed as false, therefore no add button, only reload button in the home screen
Widget skipSignInTextButton(BuildContext _context) {
  return TextButton(
      onPressed: () {
        Navigator.of(_context).push(MaterialPageRoute(
            builder: (context) => InitializeHive(isUserSignedIn: false)));
      },
      child: Text(
        'Skip for now',
        style: TextStyle(
            decoration: TextDecoration.underline,
            color: Colors.grey[700],
            fontSize: 16),
      ));
}
