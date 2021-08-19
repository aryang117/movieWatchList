import 'package:flutter/material.dart';

// 3rd party packages
import 'package:firebase_auth/firebase_auth.dart';

// file containing common widgets used throughout the app
import '/Widgets/commonWidgets.dart';

//other screens
import '../initHive/initializeHive.dart';
import 'SignInButtons.dart';

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
                  anonymousSignInButton(
                      _widgetWidth, _signInAnonymously, context),
                  vertPaddingbetweenElements(),

                  // Google Sign In Button
                  googleSignInButton(_firebaseAuth, context, _widgetWidth),
                  vertPaddingbetweenElements(),

                  // Skip Sign In Button
                  skipSignInTextButton(context),
                  vertPaddingbetweenElements(),
                ],
              ),
            );
        });
  }
}
