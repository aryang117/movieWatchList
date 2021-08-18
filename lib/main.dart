import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

//Hive package
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

import 'package:yellowclassactual/Screens/HomeScreen.dart';
import 'package:yellowclassactual/Screens/LoginScreen.dart';

import 'Models/movieDB.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.isUserSignedIn}) : super(key: key);

  final bool isUserSignedIn;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> loadHiveStuff() async {
    Hive.openBox('movieDB');
    Hive.registerAdapter(MovieDBAdapter());
  }

  @override
  void initState() {
    super.initState();
    loadHiveStuff();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Hive.openBox('moviedb'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Container(
                    padding: const EdgeInsets.only(top: 100),
                    child: Text(snapshot.error.toString()));
              else
                return HomeScreen();
            } else
              return CircularProgressIndicator();
          }),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
