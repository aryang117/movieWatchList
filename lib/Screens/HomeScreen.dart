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
      extendBody: true,
      bottomNavigationBar:
          _bottomNavigationBar(_firebaseAuth, context, refreshDBData),
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
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

// Implemented a quick bottomnavbar
BottomNavigationBar _bottomNavigationBar(
    FirebaseAuth _firebaseAuth, BuildContext _context, Function _refreshList) {
  return BottomNavigationBar(currentIndex: 0, items: [
    BottomNavigationBarItem(
        label: 'Refresh',
        icon: IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () => _refreshList())),
    BottomNavigationBarItem(
        label: 'Sign Out',
        icon: IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () {
              _firebaseAuth.signOut();

              ScaffoldMessenger.of(_context).showSnackBar(
                  SnackBar(content: Text('Signed Out Successfully')));

              Navigator.pop(_context);
            }))
  ]);
}

// fab, shows an add button if the user is logged in, reload button if the user is not
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

// Building the list of DB items
ListView _movieListBuilder(
    BuildContext _context, Function _updatedDB, Function _deleteValueFromDB) {
  // opening the box to render the list
  final _movieBox = Hive.box('movieDB');
  return ListView.builder(
    itemBuilder: (_context, _index) {
      // current item object in hive
      final _curMovieDBItem = _movieBox.getAt(_index) as MovieDB;
      // current item index in hive
      final _curItemIndex = _movieBox.length;

      return Container(
        padding: const EdgeInsets.only(top: 20),
        height: 100,
        child: Dismissible(
            key: Key(_curItemIndex.toString()),
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
            child: _listTileMaker(
                _context,
                _curMovieDBItem.posterLink,
                _curMovieDBItem.movieName,
                _curMovieDBItem.directorName,
                _index)),
      );
    },
    itemCount: _movieBox.length,
  );
}

// Maker for each ListTile
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
    //TODO : add a delete icon as well, as per requirements
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

// Maker for ListTile's thumbnail
Widget _thumbnailMaker(String posterLink) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(5),
    child: SizedBox(
      height: 60,
      width: 60,
      child: Image.network(
        posterLink,
        fit: BoxFit.fill,
      ),
    ),
  );
}
