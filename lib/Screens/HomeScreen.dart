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

  void _clearAllValuesDB() {
    setState(() {
      Hive.box('movieDB').clear();
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
      body: Container(
        padding: const EdgeInsets.only(top: 0),
        child: SingleChildScrollView(
          child: Column(children: [
            // Text(Hive.box('movieDB').values.last),
            SizedBox(
                height: MediaQuery.of(context).size.height - 50,
                child:
                    _movieListBuilder(context, updateValuesDB, deleteValuesDB)),
            Row(children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    print('reload');
                  });
                },
                icon: Icon(Icons.replay_outlined),
              ),
              IconButton(
                onPressed: _clearAllValuesDB,
                icon: Icon(Icons.clear_all_rounded),
              )
            ]),
          ]),
        ),
      ),
      floatingActionButton:
          _floatingActionButton(widget.isUserLoggedIn, context, refreshDBData),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
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
          child: ListTile(
            leading: _thumbnailMaker(_movieDB.posterLink),
            horizontalTitleGap: 20,
            title: Text(_movieDB.movieName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
            subtitle: Text(_movieDB.directorName,
                style: TextStyle(
                  fontSize: 14,
                )),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(_context).push(MaterialPageRoute(
                        builder: (context) => UpdateDBForm(index: _index)));
                  },
                ),
                IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteValueFromDB(_index);
                  },
                )
              ],
            ),
          ),
        ),
      );
    },
    itemCount: _movieBox.length,
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
