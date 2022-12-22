import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/ApiServices/API_KEY.dart';
import 'package:movie_app/Models/Geners.dart';
import 'package:movie_app/Models/Movie_Model.dart';

import '../Models/Cast.dart';

final serviceProvider =
    FutureProvider.autoDispose(((ref) => Services.getTrendingMovies()));
final generProvider =
    FutureProvider.autoDispose(((ref) => Services.getGener()));
final generMovieProvider = FutureProvider.family
    .autoDispose((ref, id) => Services.getMovieByGener('$id'));
final generCastProvider =
    FutureProvider.family.autoDispose((ref, id) => Services.getCastList('$id'));
String _baseUrl = 'api.themoviedb.org';

class Services {
  static Future<List<Result>> getTrendingMovies() async {
    Map<String, String> parm = {'api_key': KEY.API_KEY};
    try {
      var responce =
          await http.get(Uri.https(_baseUrl, '/3/movie/now_playing', parm));

      if (responce.statusCode == 200) {
        var movie = json.decode(responce.body)['results'] as List;
        List<Result> model = movie.map((e) => Result.fromJson(e)).toList();

        return model;
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  static Future<List<Gener>> getGener() async {
    Map<String, String> parm = {'api_key': KEY.API_KEY};
    try {
      var responce =
          await http.get(Uri.https(_baseUrl, '/3/genre/movie/list', parm));

      if (responce.statusCode == 200) {
        var movie = json.decode(responce.body)['genres'] as List;

        List<Gener> model = movie.map((e) => Gener.fromJson(e)).toList();

        return model;
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  static Future<List<Result>> getMovieByGener(String movieId) async {
    Map<String, String> parm = {'api_key': KEY.API_KEY, 'with_genres': movieId};
    try {
      var responce =
          await http.get(Uri.https(_baseUrl, '/3/discover/movie', parm));

      if (responce.statusCode == 200) {
        var movie = json.decode(responce.body)['results'] as List;
        List<Result> model = movie.map((e) => Result.fromJson(e)).toList();

        return model;
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }

  static Future<String> getVideo(int movieId) async {
    Map<String, String> parm = {
      'api_key': KEY.API_KEY,
      'movie_id': movieId.toString()
    };
    try {
      var responce =
          await http.get(Uri.https(_baseUrl, '/3/movie/$movieId/videos', parm));

      if (responce.statusCode == 200) {
        var movie = json.decode(responce.body)['results'][0]['key'];

        return movie;
      }
    } catch (error) {
      throw Exception(error);
    }
    return '';
  }

  static Future<List<Cast>> getCastList(String id) async {
    Map<String, String> parm = {'api_key': KEY.API_KEY, 'movie_id': id};
    try {
      var responce =
          await http.get(Uri.https(_baseUrl, '/3/movie/$id/credits', parm));

      if (responce.statusCode == 200) {
        var list = json.decode(responce.body)['cast'] as List;
        List<Cast> castList = list.map((e) => Cast.fromJson(e)).toList();
        return castList;
      }
    } catch (error) {
      throw Exception(error);
    }
    return [];
  }
}
