import 'package:flutter/material.dart';

// 3rd party packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

// file containing common widgets used throughout the app
import '/Widgets/commonWidgets.dart';

//other screens
import 'initializeHive.dart';

// This is the first screen that the user will see, if they opened the app for the first time or if they have not logged in
// Has 3 CTA, to sign in via Google, sign in Anonymously and skipping sign in altogether
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    //width of widgets
    final double _widgetWidth = MediaQuery.of(context).size.width - 100;

    return StreamBuilder<User?>(
        stream: _firebaseAuth.authStateChanges(),
        builder: (context, snapshot) {
          print("snapshotdata" + snapshot.data.toString());
          if (snapshot.hasData) {
            print(snapshot.data);
            return InitializeHive(isUserSignedIn: true);
          } else
            return Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Anonymouse Sign In Button
                  _anonymousSignInButton(
                      _widgetWidth, _signInAnonymously, context),
                  vertPaddingbetweenElements(),

                  // Google Sign In Button
                  _googleSignInButton(_firebaseAuth, context, _widgetWidth),
                  vertPaddingbetweenElements(),

                  // Skip Sign In Button
                  _skipSignInTextButton(context),
                  vertPaddingbetweenElements(),
                ],
              ),
            );
        });
  }
}

// Google Sign In Button, isUserSignedIn is passed as true, therefore there is an add button
Widget _googleSignInButton(
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
Widget _anonymousSignInButton(
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
Widget _skipSignInTextButton(BuildContext _context) {
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
