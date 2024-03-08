//import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pmsn2024/model/popular_model.dart';

class ApiPopular {
  final URL =
      "https://api.themoviedb.org/3/movie/popular?api_key=73c295392359efe7df0a34433173fd7e&language=es-MX&page=1";
  final dio = Dio();
  Future<List<PopularModel>?> getPopularMovie() async {
    Response response = await dio.get(URL);
    if (response.statusCode == 200) {
      //print(response.data['results'].runtimeType);
      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}