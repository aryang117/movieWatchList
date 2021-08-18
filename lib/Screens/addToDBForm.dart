import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '/Models/movieDB.dart';
import '/API/api.dart';

import '/Widgets/commonWidgets.dart';

String _posterURL = "";

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

    // in case if the movie poster link is given as N/A (movie poster not present/found by api) : edge case
    if (_posterURL == "N/A")
      _posterURL =
          "https://cdn.mos.cms.futurecdn.net/j6reMf3QEuGWFE7FkVmoyT-1200-80.jpg";

    //updating the UI as we have a new poster
    setState(() {
      print("updated poster!");
    });
  }

  //updates values in the DB
  Future<void> _addtoDB() async {
    // await _getMoviePosterLink();

    final newMovieData =
        MovieDB(_movieNameController.text, _dirNameController.text, _posterURL);

    setState(() {
      Hive.box('movieDB').add(newMovieData);
    });
    Navigator.pop(context);
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
          color: Colors.redAccent[400],
          child: Text('Add to DB',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          onPressed: () => addtoDB()));
}
