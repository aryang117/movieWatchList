import 'package:flutter/material.dart';

// 3rd party packages
import 'package:hive_flutter/hive_flutter.dart';

// model file
import '/Models/movieDB.dart';

// api operations
import '/API/api.dart';

// file containing common widgets used throughout the app
import '/Widgets/commonWidgets.dart';

String _posterURL = "";

// stores the status of the updation of posterURL, happens when the user may directly
// click on the update values and not save the field (i.e click on the cta and not submit the value)
String _prevURL = "";

// This is the form that allows the user to add new movies
// The user can specify the movie name and director name
// if the user enters the movie name and press the enter/submit key on their mobil keyboard,
// the poster of the movie is then loaded
// if the user directly presses the CTA, the movie poster is still loaded
// the CTA will display a snackbar if the movie is not found by the api
// if the movie poster is found by the api, there's a placeholder img link [line 44], that is put instead of a NA or null

class AddToDBForm extends StatefulWidget {
  const AddToDBForm({Key? key}) : super(key: key);

  @override
  _AddToDBFormState createState() => _AddToDBFormState();
}

class _AddToDBFormState extends State<AddToDBForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _movieNameController = TextEditingController();
  final TextEditingController _dirNameController = TextEditingController();

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

  //add new values in the DB
  Future<void> _addtoDB() async {
    if (_posterURL.length == 0 ||
        _posterURL == "null" ||
        _posterURL == _prevURL) await _getMoviePosterLink();

    if (_posterURL.length != 0 && _posterURL != "null") {
      final newMovieData = MovieDB(
          _movieNameController.text, _dirNameController.text, _posterURL);

      setState(() {
        Hive.box('movieDB').add(newMovieData);
        _prevURL = _posterURL;
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
              // cannot be separated into it's own stl/stf widget, onEditingComplete won't work!!
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
                  label: 'Director Name'),
              vertPaddingbetweenElements(),
              _submitButton(_widthWidgets, _addtoDB),
            ],
          ),
        ),
      ),
    );
  }
}

// main CTA of the updateDB Form, updates the values into the DB
Widget _submitButton(double _widgetWidth, Function addtoDB) {
  return Container(
      height: 60,
      width: _widgetWidth,
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: Colors.black,
          child: Text('Add to DB',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white)),
          onPressed: () => addtoDB()));
}
