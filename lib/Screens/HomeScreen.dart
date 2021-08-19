import 'package:flutter/material.dart';

// 3rd party packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Other Screens
import 'addToDBForm.dart';
import 'updateDBForm.dart';
import '/Screens/LoginScreen.dart';

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
          _bottomNavigationBar(_firebaseAuth, context, _clearAllData),
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

// Implemented a quick bottomnavbar, allows you to sign out or clear all values [only if u're logged in]
BottomNavigationBar _bottomNavigationBar(FirebaseAuth _firebaseAuth,
    BuildContext _context, Function _clearAllValues) {
  return BottomNavigationBar(items: [
    BottomNavigationBarItem(
        label: 'Clear',
        icon: IconButton(
            icon: Icon(Icons.clear_all_rounded),
            onPressed: () => _clearAllValues())),
    BottomNavigationBarItem(
        label: 'Sign Out',
        icon: IconButton(
            icon: Icon(Icons.logout_rounded),
            onPressed: () {
              _firebaseAuth.signOut();

              ScaffoldMessenger.of(_context).showSnackBar(
                  SnackBar(content: Text('Signed Out Successfully')));

              Navigator.push(_context,
                  MaterialPageRoute(builder: (_context) => LoginScreen()));
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
Widget _movieListBuilder(
    BuildContext _context, Function _updatedDB, Function _deleteValueFromDB) {
  // opening the box to render the list
  final _movieBox = Hive.box('movieDB');
  return ValueListenableBuilder(
      valueListenable: _movieBox.listenable(),
      builder: (_context, _movieBox, _) {
        final _movieListBuilder = Hive.box('movieDB');
        return ListView.builder(
          itemBuilder: (_context, _index) {
            // current item object in hive
            final _curMovieDBItem = _movieListBuilder.getAt(_index) as MovieDB;

            return Container(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              height: 120,
              child: _listTileMaker(
                  _context,
                  _curMovieDBItem.posterLink,
                  _curMovieDBItem.movieName,
                  _curMovieDBItem.directorName,
                  _index,
                  _deleteValueFromDB),
            );
          },
          itemCount: _movieListBuilder.length,
        );
      });
}

// Maker for each ListTile
Widget _listTileMaker(
  BuildContext _context,
  String _posterLink,
  String _movieName,
  String _dirName,
  int _index,
  Function _deleteValueFromDB,
) {
  return Container(
    alignment: Alignment.center,
    height: 100,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Colors.white70),
    child: Row(
      //shape: RoundedRectangleBorder(),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _listContent(_movieName, _dirName, _posterLink),
        Container(
          width: 100,
          child: Row(
            children: [
              _editIcon(_index, _context),
              _deleteIcon(_index, _deleteValueFromDB),
            ],
          ),
        ),
      ],
    ),
  );
}

// Makes the List Content, i.e, Name, Director Name and thumnail
Widget _listContent(String _movieName, String _dirName, String _posterLink) {
  return Expanded(
    child: Row(
      children: [
        _thumbnailMaker(_posterLink),
        Padding(padding: const EdgeInsets.only(left: 30)),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_movieName,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87)),
              Padding(padding: const EdgeInsets.only(top: 5)),
              Text(_dirName,
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
            ],
          ),
        ),
      ],
    ),
  );
}

// the delete icon for each list tile
Widget _deleteIcon(int _index, Function _deleteValueFromDB) {
  return IconButton(
    color: Colors.black,
    icon: Icon(Icons.delete),
    onPressed: () => _deleteValueFromDB(_index),
  );
}

// the edit icon for each list tile
Widget _editIcon(int _index, BuildContext _context) {
  return IconButton(
    color: Colors.black,
    icon: Icon(Icons.edit),
    onPressed: () {
      Navigator.of(_context).push(
          MaterialPageRoute(builder: (context) => UpdateDBForm(index: _index)));
    },
  );
}

// Maker for ListTile's thumbnail
Widget _thumbnailMaker(String posterLink) {
  return Card(
    elevation: 2,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 100,
        width: 80,
        child: Image.network(
          posterLink,
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}
