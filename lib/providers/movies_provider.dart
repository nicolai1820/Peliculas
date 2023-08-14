import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/models/Movie.dart';
import 'package:peliculas/models/credits_response.dart';
import 'package:peliculas/models/now_playing_response.dart';
import 'package:peliculas/models/popular_response.dart';
import 'package:peliculas/models/search_movies_response.dart';
class MoviesProvider  extends ChangeNotifier{

  String _baseUrl ='api.themoviedb.org';
  String _apiKey ='c9dfe16a7b48cfe1da9b109871970828';
  String _language ='es-ES';
  bool _peticionEnProgreso = false;
  List<Movie> onDisplayMovies =[];
   List<Movie> popularMovies =[];

   Map<int,List<Cast>> moviesCast = {};
   int _popularPage = 0;

  MoviesProvider() {
    print('Movies provider inicializado');
    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

   Future<String> _getJsonData(String endPoint,[int page = 1]) async{ 

  var url = Uri.https(_baseUrl, endPoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    print('esta es la url $url');
final response = await http.post(url, body: {'name': 'doodle', 'color': 'blue'});
  return response.body;
  }

     Future<String> _getJsonData_cast(String endPoint,[int page = 1]) async{ 

  var url = Uri.https(_baseUrl, endPoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });
    print('esta es la url $url');
final response = await http.get(url);
  return response.body;
  }

  getOnDisplayMovies() async{ 

  final jsonData = await this._getJsonData('3/movie/now_playing');  

final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
onDisplayMovies = nowPlayingResponse.results;
notifyListeners();
  }

  getPopularMovies()async{
    _popularPage++;
    print('pagina es $_popularPage');

    if(!_peticionEnProgreso){
      _peticionEnProgreso = true;
    final jsonData = await this._getJsonData('3/movie/popular',_popularPage); 
 
    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovies = [...popularMovies, ...popularResponse.results ];
    _peticionEnProgreso = false;
    notifyListeners();
    }
 

  }
  Future <List<Cast>>getMoviecast(int movieId) async{
    print('este es el id $movieId');

    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    final jsonData = await this._getJsonData_cast('3/movie/$movieId/credits'); 
    print('esta es la respuesta $jsonData');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    notifyListeners();

    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;

  }

  Future<List<Movie>>searchMovies(String query)async{
      final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query':query,
    });
    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }
}