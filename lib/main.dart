import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//Hive package
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import '/Screens/LoginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}
