// reqd for JsonDecode
import 'dart:convert';

//api calls
import 'package:http/http.dart' as http;

import '/secret/keys.dart';

// gets the api respones from _getDataFromApi() and returns the PosterLink
Future<List<String>> getMoviePoster(String _movieName) async {
  final responseData = await _getDataFromApi(_movieName);

  //decoding api response as a map
  Map<String, dynamic> values =
      jsonDecode(responseData.body.toString()) as Map<String, dynamic>;

  //debug
  print(values["Poster"].toString() +
      responseData.statusCode.toString() +
      responseData.body.toString());

  return [
    values["Title"].toString(),
    values["Director"].toString(),
    values["Poster"].toString()
  ];
}

//  gets the response from the api acc to the movieName
Future<http.Response> _getDataFromApi(String _movieName) {
  return http
      .get(Uri.parse('http://www.omdbapi.com/?t=$_movieName&apikey=$apiKey'));
}
