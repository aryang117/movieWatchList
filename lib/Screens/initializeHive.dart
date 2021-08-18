import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/Models/movieDB.dart';

import 'HomeScreen.dart';

class InitializeHive extends StatefulWidget {
  InitializeHive({Key? key, required this.isUserSignedIn}) : super(key: key);

  final bool isUserSignedIn;
  @override
  _InitializeHiveState createState() => _InitializeHiveState();
}

class _InitializeHiveState extends State<InitializeHive> {
  Future<void> loadHiveStuff() async {
    Hive.openBox('movieDB');
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
                return HomeScreen(isUserLoggedIn: widget.isUserSignedIn);
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
