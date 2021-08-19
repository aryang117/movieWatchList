import 'package:flutter/material.dart';

//3rd party packages
import 'package:google_fonts/google_fonts.dart';

// This File contains widgets that are being used throughout the app
// and are very similar to each other, therefore they are being standardized

// TextFormField being used throughout the app
class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField(
      {Key? key,
      required this.textEditingController,
      required this.label,
      this.getPosterLink})
      : super(key: key);

  final TextEditingController textEditingController;
  final String label;
  final Function? getPosterLink;

  @override
  Widget build(BuildContext context) {
    final _labelStyle = GoogleFonts.poppins();
    return TextFormField(
      style: _labelStyle,
      controller: textEditingController,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: _labelStyle,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }
}

// Poster Previews shown to the user when they enter the movie names in the addtoDB and UpdateDB Form
Widget posterPreview(String _posterURL) {
  if (_posterURL.length != 0) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 250,
        width: 175,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: FadeInImage(
              image: NetworkImage(_posterURL),
              fit: BoxFit.fill,
              placeholder: NetworkImage(
                  'https://pbs.twimg.com/media/E7VuaNRXEAEloYi.jpg')),
          elevation: 5,
        ),
      ),
    );
  } else {
    return Card(
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 250,
          width: 175,
          child: Image.network(
            'https://pbs.twimg.com/media/E7VuaNRXEAEloYi.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

// vertical Padding between elements
Padding vertPaddingbetweenElements() {
  return Padding(padding: const EdgeInsets.only(top: 20.0));
}

// Snackbar displays when the movie is not found
ScaffoldFeatureController displaySnackbarforNoMovieFound(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Movie not Found! Please Enter a Valid Movie Name')));
}
