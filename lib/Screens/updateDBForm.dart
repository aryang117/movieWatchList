import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:yellowclassactual/API/api.dart';

import '/Models/movieDB.dart';

String _posterURL = "";

//TODO : Add the api functionality to this one too! Currently it just returns a static link to Halo Infinite's cover photo, not the movie poster

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

  @override
  void initState() {
    super.initState();
    final box = Hive.box('movieDB');

    final curValues = box.getAt(widget.index) as MovieDB;
    _movieNameController.text = curValues.movieName;
    _dirNameController.text = curValues.directorName;
  }

  //returns moviePosterLink
  Future<String> _returnMoviePosterLink() async {
    return await getMoviePoster(_movieNameController.text);
  }

  //updates values in the DB
  Future<void> _updateValues() async {
    _posterURL = await _returnMoviePosterLink();
    final _updatedMovieData =
        MovieDB(_movieNameController.text, _dirNameController.text, _posterURL);

    if (_posterURL == "N/A")
      _posterURL =
          "https://cdn.mos.cms.futurecdn.net/j6reMf3QEuGWFE7FkVmoyT-1200-80.jpg";

    setState(() {
      Hive.box('movieDB').putAt(widget.index, _updatedMovieData);
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
                      child: Text('Update Values',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      onPressed: _updateValues))
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
