import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:yellowclassactual/Screens/addToDBForm.dart';
import 'package:yellowclassactual/Screens/updateDBForm.dart';

import '/Models/movieDB.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.isUserLoggedIn}) : super(key: key);

  final bool isUserLoggedIn;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void updateValuesDB(int _index, MovieDB _updatedValue) {
    setState(() {
      Hive.box('movieDB').putAt(_index, _updatedValue);
    });
  }

  void deleteValuesDB(int _index) {
    setState(() {
      Hive.box('movieDB').deleteAt(_index);
    });
  }

  void refreshDBData() {
    setState(() {
      print('list refreshed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(currentIndex: 0, items: [
        BottomNavigationBarItem(
            label: 'List',
            icon: IconButton(
                icon: Icon(Icons.list_alt_rounded), onPressed: () {})),
        BottomNavigationBarItem(
            label: 'Sign Out',
            icon: IconButton(
                icon: Icon(Icons.logout_rounded),
                onPressed: () {
                  _firebaseAuth.signOut();

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Signed Out Successfully')));

                  Navigator.pop(context);
                }))
      ]),
      body: Container(
        padding: const EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          child: Column(children: [
            // Text(Hive.box('movieDB').values.last),
            SizedBox(
                height: MediaQuery.of(context).size.height,
                child:
                    _movieListBuilder(context, updateValuesDB, deleteValuesDB)),
          ]),
        ),
      ),
      floatingActionButton:
          _floatingActionButton(widget.isUserLoggedIn, context, refreshDBData),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

FloatingActionButton? _floatingActionButton(
    bool _isUserLoggedIn, BuildContext context, Function _refershPage) {
  if (_isUserLoggedIn) {
    return FloatingActionButton(
      isExtended: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.black,
      child: Icon(
        Icons.add,
        size: 36,
      ),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AddToDBForm()));
      },
    );
  } else {
    return FloatingActionButton(
      isExtended: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      backgroundColor: Colors.black,
      child: Icon(
        Icons.refresh,
        size: 36,
      ),
      onPressed: () {
        _refershPage();
      },
    );
  }
}

ListView _movieListBuilder(
    BuildContext _context, Function _updatedDB, Function _deleteValueFromDB) {
  final _movieBox = Hive.box('movieDB');
  return ListView.builder(
    itemBuilder: (_context, _index) {
      final _movieDB = _movieBox.getAt(_index) as MovieDB;
      final dbItem = _movieBox.length;

      return Container(
        padding: const EdgeInsets.only(top: 20),
        height: 100,
        child: Dismissible(
            key: Key(dbItem.toString()),
            background: Container(
              color: Colors.red,
              child: Text('Delete Item'),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
            ),
            onDismissed: (DismissDirection _direction) {
              _deleteValueFromDB(_index);
              ScaffoldMessenger.of(_context).showSnackBar(
                  SnackBar(content: Text('Deleted Value at index : $_index')));
            },
            child: _listTileMaker(_context, _movieDB.posterLink,
                _movieDB.movieName, _movieDB.directorName, _index)),
      );
    },
    itemCount: _movieBox.length,
  );
}

ListTile _listTileMaker(BuildContext _context, String _posterLink,
    String _movieName, String _dirName, int _index) {
  return ListTile(
    leading: _thumbnailMaker(_posterLink),
    horizontalTitleGap: 20,
    title: Text(_movieName,
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black)),
    subtitle: Text(_dirName,
        style: TextStyle(
          fontSize: 14,
        )),
    trailing: IconButton(
      color: Colors.black,
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.of(_context).push(MaterialPageRoute(
            builder: (context) => UpdateDBForm(index: _index)));
      },
    ),
  );
}

Widget _thumbnailMaker(String posterLink) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: SizedBox(
      height: 60,
      width: 60,
      child: Image.network(
        posterLink,
        fit: BoxFit.fill,
        // height: 75,
        // width: 75,
        //width: 50,
      ),
    ),
  );
}
