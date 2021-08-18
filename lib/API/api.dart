import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yellowclassactual/secret/keys.dart';

Future<String> getMoviePoster(String _movieName) async {
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
      .get(Uri.parse('http://www.omdbapi.com/?t=$_movieName&apikey=$apiKey'));
}
