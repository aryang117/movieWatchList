import 'package:flutter/material.dart';

// 3rd Party Packages
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Other Screens
import '../Login/LoginScreen.dart';
import '../addToDBForm/addToDBForm.dart';
import '../updateDBForm/updateDBForm.dart';

import '/Models/movieDB.dart';

// Building the list of DB items
Widget movieListBuilder(
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
