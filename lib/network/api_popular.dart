//import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pmsn2024/model/cast_model.dart';
import 'package:pmsn2024/model/popular_model.dart';
import 'package:pmsn2024/model/videos_model.dart';

class ApiPopular {
  final URL =
      "https://api.themoviedb.org/3/movie/";
  final dio = Dio();
  final api_key = "?api_key=6485bbf12ef20840ab3cf462c8cac566&language=es-MX&page=1";

  Future<List<PopularModel>?> getPopularMovie(String endpoint) async {
    var consultUrl=URL+endpoint+api_key;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      //print(response.data['results'].runtimeType);
      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}

class ApiVideos {
  final URL = "https://api.themoviedb.org/3/movie/";
  final api_key = "/videos?api_key=6485bbf12ef20840ab3cf462c8cac566";
  final dio = Dio();
  Future<List<Result>?> getTrailer(String endpoint) async {
    var consultUrl = URL + endpoint + api_key;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      //print(response.data['results'].runtimeType);
      final listTrailer = response.data['results'] as List;
      return listTrailer.map((trailer) => Result.fromMap(trailer)).toList();
    }
    return null;
  }
}

class ApiCast {
  final URL = "https://api.themoviedb.org/3/movie/";
  final api_key = "/credits?api_key=6485bbf12ef20840ab3cf462c8cac566";
  final dio = Dio();
  Future<List<CastMovie>?> getCast(String endpoint) async {
    var consultUrl = URL + endpoint + api_key;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      final List<dynamic> castData = response.data['cast'];
      final List<dynamic> actingCastData = castData
          .where((cast) => cast['known_for_department'] == 'Acting')
          .toList();
      return actingCastData.map((cast) => CastMovie.fromMap(cast)).toList();
    }
    return null;
  }
}

class ApiDetail {
  final URL = "https://api.themoviedb.org/3/movie/";
  final api_key = "?api_key=6485bbf12ef20840ab3cf462c8cac566";
  final dio = Dio();

  Future<Map<String, dynamic>?> getDetail(String endpoint) async {
    var consultUrl = URL + endpoint + api_key;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    }
    return null;
  }
}

class ApiGetFavorite {
  final URL =
      "https://api.themoviedb.org/3/account/21101127/favorite/movies?api_key=6485bbf12ef20840ab3cf462c8cac566&session_id=6b1ac25d9dc5b22ace3bb7a7cca7096d58a64faa";
  final dio = Dio();
  Future<List<PopularModel>?> getFavoriteMovie() async {
    var consultUrl = URL;
    Response response = await dio.get(consultUrl);
    if (response.statusCode == 200) {
      //print(response.data['results'].runtimeType);
      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}

class ApiAddFavorite {
  final URL =
      "https://api.themoviedb.org/3/account/21061248/favorite?api_key=6485bbf12ef20840ab3cf462c8cac566&session_id=6b1ac25d9dc5b22ace3bb7a7cca7096d58a64faa";
  final dio = Dio();

  Future<void> postFavoriteMovie(int mediaId) async {
    try {
      final String postUrl = URL;
      Map<String, dynamic> body = {
        "media_type": "movie",
        "media_id": mediaId,
        "favorite": true
      };
      Response response = await dio.post(postUrl, data: body);
      if (response.statusCode == 200) {
        print('Película marcada como favorita exitosamente.');
      } else {
        print(
            'Error al marcar la película como favorita. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud POST: $e');
    }
  }
}

class ApiDeleteFavorite {
  final URL =
      "https://api.themoviedb.org/3/account/21061248/favorite?api_key=6485bbf12ef20840ab3cf462c8cac566&session_id=6b1ac25d9dc5b22ace3bb7a7cca7096d58a64faa";
  final dio = Dio();

  Future<void> deleteFavoriteMovie(int mediaId) async {
    try {
      final String postUrl = URL;
      Map<String, dynamic> body = {
        "media_type": "movie",
        "media_id": mediaId,
        "favorite": false
      };
      Response response = await dio.post(postUrl, data: body);
      if (response.statusCode == 200) {
        print('Película eliminada como favorita exitosamente.');
      } else {
        print(
            'Error al marcar la película como favorita. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error en la solicitud POST: $e');
    }
  }
}
