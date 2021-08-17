import 'package:flutter/material.dart';
import 'package:yellowclassactual/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    //width of elements
    final double widthElements = MediaQuery.of(context).size.width - 50;

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
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => MyHomePage()));
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
              onPressed: () {},
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
  }
}
