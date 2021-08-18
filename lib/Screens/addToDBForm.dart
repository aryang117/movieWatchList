import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '/Models/movieDB.dart';
import 'package:http/http.dart' as http;

String posterURL = "";

class AddToDBForm extends StatefulWidget {
  const AddToDBForm({Key? key}) : super(key: key);

  @override
  _AddToDBFormState createState() => _AddToDBFormState();
}

class _AddToDBFormState extends State<AddToDBForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _movieNameController = TextEditingController();
  final TextEditingController _dirNameController = TextEditingController();

  // actually adds data to the db
  void addtoBox(MovieDB _movieDB) {
    Hive.box('movieDB').add(_movieDB);
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
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  height: 250,
                  width: 175,
                  child: Card(
                    // child: FadeInImage(
                    //     image: NetworkImage(posterURL),
                    //     fit: BoxFit.fill,
                    //     placeholder: NetworkImage(
                    //         'https://pbs.twimg.com/media/E7VuaNRXEAEloYi.jpg')),
                    color: Colors.white,
                    elevation: 5,
                  ),
                ),
              ),
              _vertPaddingbetweenElements(),
              TextFormField(
                controller: _movieNameController,
                decoration: InputDecoration(
                    labelText: 'Movie Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              _vertPaddingbetweenElements(),
              TextFormField(
                controller: _dirNameController,
                decoration: InputDecoration(
                    labelText: 'Director Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
              _vertPaddingbetweenElements(),
              Container(
                  height: 60,
                  width: _widthWidgets,
                  child: MaterialButton(
                    color: Colors.redAccent[400],
                    child: Text('Add to DB',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    onPressed: () async {
                      final apiData =
                          await _loadMoviePoster(_movieNameController.text);
                      posterURL = apiData;

                      if (posterURL.toString() == "null") {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Movie not Found! Please Enter a valid movie name!')));
                      } else {
                        //TODO : Handle N/A as poster URL, some movies' Poster is not available so the link we get is N/A
                        final newMovieData = MovieDB(_movieNameController.text,
                            _dirNameController.text, posterURL);

                        setState(() {
                          addtoBox(newMovieData);
                        });
                        Navigator.pop(context);
                      }
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

Padding _vertPaddingbetweenElements() {
  return Padding(padding: const EdgeInsets.only(top: 20.0));
}

Future<String> _loadMoviePoster(String _movieName) async {
  final responseData = await _getDataFromApi(_movieName);
  Map<String, dynamic> values =
      jsonDecode(responseData.body.toString()) as Map<String, dynamic>;

  //debug
  print(values["Poster"].toString() +
      responseData.statusCode.toString() +
      responseData.body.toString());

  return values["Poster"].toString();
}

Future<http.Response> _getDataFromApi(String _movieName) {
  return http
      .get(Uri.parse('http://www.omdbapi.com/?t=$_movieName&apikey=3688955'));
}
