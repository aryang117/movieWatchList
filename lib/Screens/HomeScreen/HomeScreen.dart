import 'package:flutter/material.dart';

// 3rd party packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

// widgets
import 'bottomNavBar.dart';
import 'fab.dart';
import 'movieList.dart';

import '/Models/movieDB.dart';

// This is the home screen, this is where the list of movies will be displayed
// if the user is logged in [isUserLoggedIn is true], they will see fab[floating action button] that will allow them to add movies

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.isUserLoggedIn}) : super(key: key);

  final bool isUserLoggedIn;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // updating values in the box
  void updateValuesDB(int _index, MovieDB _updatedValue) {
    setState(() {
      Hive.box('movieDB').putAt(_index, _updatedValue);
    });
  }

  // deleting values in the box
  void deleteValuesDB(int _index) {
    setState(() {
      Hive.box('movieDB').deleteAt(_index);
    });
  }

  // refresh data in the box, not needed anymore, all the CRUD operations already refresh state
  void refreshDBData() {
    setState(() {
      print('list refreshed');
    });
  }

  // clears all of the data in the box
  void _clearAllData() {
    setState(() {
      Hive.box('movieDB').clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar:
          bottomNavigationBar(_firebaseAuth, context, _clearAllData),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child:
                    movieListBuilder(context, updateValuesDB, deleteValuesDB)),
          ]),
        ),
      ),
      floatingActionButton:
          floatingActionButton(widget.isUserLoggedIn, context, refreshDBData),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
