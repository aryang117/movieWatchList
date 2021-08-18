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

  //returns moviePosterLink
  Future<String> _returnMoviePosterLink() async {
    return await getMoviePoster(_movieNameController.text);
  }

  //adds values to the DB
  Future<void>? _addtoDB() async {
    _posterURL = await _returnMoviePosterLink();

    if (_posterURL.toString() == "null") {
      ScaffoldMessenger.of(context).showSnackBar(_snackBar());
    } else {
      if (_posterURL == "N/A")
        _posterURL =
            "https://cdn.mos.cms.futurecdn.net/j6reMf3QEuGWFE7FkVmoyT-1200-80.jpg";

      final newMovieData = MovieDB(
          _movieNameController.text, _dirNameController.text, _posterURL);

      setState(() {
        Hive.box('movieDB').add(newMovieData);
      });
      Navigator.pop(context);
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
              CustomTextFormField(
                  textEditingController: _movieNameController,
                  label: 'Movie Name'),
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
          child: Text('Update Values',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          onPressed: () => addtoDB()));
}

//scaffold message in case adding to DB fails
SnackBar _snackBar() {
  return SnackBar(
      content: Text('Movie not Found! Please Enter a valid movie name!'));
}
