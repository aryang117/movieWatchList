import 'package:flutter/material.dart';

// 3rd party packages
import 'package:hive_flutter/hive_flutter.dart';

// api operations
import '/API/api.dart';

// file containing common widgets used throughout the app
import '/Widgets/commonWidgets.dart';

import '/Models/movieDB.dart';

//store the url of the Poster
String _posterURL = "";

// stores the previous posterURL, that is loaded from the previous value
String _prevURL = "";

// This is the form that allows the user to edit existing movies
// The user can specify the movie name and director name, the name that they previously added is put in the field by default
// if the user enters the movie name and press the enter/submit key on their mobil keyboard,
// the poster of the movie is then loaded
// if the user directly presses the CTA, the movie poster is still loaded
// the CTA will display a snackbar if the movie is not found by the api
// if the movie poster is found by the api, there's a placeholder img link [line 63], that is put instead of a NA or null

class UpdateDBForm extends StatefulWidget {
  const UpdateDBForm({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  _UpdateDBFormState createState() => _UpdateDBFormState();
}

class _UpdateDBFormState extends State<UpdateDBForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _movieNameController = TextEditingController();
  final TextEditingController _dirNameController = TextEditingController();

  // gets the values for the current index and assigns them to the fields
  Future<void>? _getcurrentValues() async {
    final box = Hive.box('movieDB');

    final curValues = await box.getAt(widget.index) as MovieDB;
    _movieNameController.text = curValues.movieName;
    _dirNameController.text = curValues.directorName;
    _posterURL = curValues.posterLink;
    _prevURL = curValues.posterLink;
  }

  // we get the past values as soon as the widget initializes
  @override
  void initState() {
    super.initState();
    _getcurrentValues();
  }

  // when the user is done with editing the field, it gets the movie Poster Link
  Future<void> _getMoviePosterLink() async {
    _posterURL = await getMoviePoster(_movieNameController.text);

    if (_posterURL.length != 0 && _posterURL != "null") {
      // in case if the movie poster link is given as N/A (movie poster not present/found by api) : edge case
      if (_posterURL == "N/A")
        _posterURL =
            "https://cdn.mos.cms.futurecdn.net/j6reMf3QEuGWFE7FkVmoyT-1200-80.jpg";

      //updating the UI as we have a new poster
      setState(() {
        print("updated poster!");
      });
    } else {
      displaySnackbarforNoMovieFound(context);
    }
  }

  //updates values in the DB
  Future<void> _updateValues() async {
    if (_posterURL == _prevURL) await _getMoviePosterLink();

    print("new poster url " + _posterURL);
    if (_posterURL.length != 0 && _posterURL != "null") {
      final _updatedMovieData = MovieDB(
          _movieNameController.text, _dirNameController.text, _posterURL);

      setState(() {
        Hive.box('movieDB').putAt(widget.index, _updatedMovieData);
      });
      Navigator.pop(context);
    } else {
      displaySnackbarforNoMovieFound(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //width of widgets
    final double _widthWidgets = MediaQuery.of(context).size.width - 20;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              posterPreview(_posterURL),
              vertPaddingbetweenElements(),

              // cannot be separated into it's own stl/stf widget, if done onEditingComplete will call every frame!!
              TextFormField(
                onEditingComplete: _getMoviePosterLink,
                controller: _movieNameController,
                decoration: InputDecoration(
                    labelText: 'Movie Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              vertPaddingbetweenElements(),
              CustomTextFormField(
                  textEditingController: _dirNameController,
                  label: 'Director name'),
              vertPaddingbetweenElements(),
              _submitButton(_widthWidgets, _updateValues),
            ],
          ),
        ),
      ),
    );
  }
}

// main CTA of the updateDB Form, updates the values into the DB
Widget _submitButton(double _widgetWidth, Function _updateValues) {
  return Container(
      height: 60,
      width: _widgetWidth,
      child: MaterialButton(
          color: Colors.redAccent[400],
          child: Text('Update Values',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          onPressed: () => _updateValues()));
}
