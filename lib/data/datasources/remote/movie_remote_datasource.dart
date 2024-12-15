import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:movi_mobile/core/constants/api.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  Future<Either<Failure, List<MovieModel>>> getTrendingMovies();
  Future<Either<Failure, List<MovieModel>>> getMostPopularMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {

  @override
  Future<Either<Failure, List<MovieModel>>> getTrendingMovies() async {
    try {
      List<MovieModel> trendingMovies = [];
      int page = 1;

      while (trendingMovies.length < 10) {
        String url =
            '${Api.apiTMDBMovie}popular?language=fr-FR&page=$page';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${ApiKeys.tmdbApiKey}',
            'accept': 'application/json',
          },
        ); // Log de la page et du statut

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          // Vérifiez si 'data' et 'results' existent et sont valides
          if (data != null && data['results'] is List) {
            final results = data['results'];

            for (var result in results) {
              if (result != null) {
                int tmdbId = result['id'] ?? -1; // Défaut à -1 si 'id' est null
                bool isHorror = false;
                for (var genre in result['genre_ids']) {
                  if (genre == 27) {
                    isHorror = true;
                  }
                }
                if (tmdbId != -1 && isHorror == false) {
                  Map<String, dynamic> movieData = await getMovieData(tmdbId);
                  MovieModel movie = MovieModel.fromJson(movieData);
                  trendingMovies.add(movie);
                } else {
                  print(
                      'Movie ID is null for result: $result'); // Log d'un ID null
                }
              } else {
                print('Encountered null result'); // Log d'un résultat null
              }
            }

            page++;
          } else {
            print(
                'Unexpected results format or data is null: $data'); // Log d'erreur
            throw Exception('Unexpected results format');
          }
        } else {
          print(
              'Error fetching trending movies: ${response.statusCode}, ${response.body}');
          throw Exception('Failed to load trending movies');
        }
      }
      return Right(trendingMovies);
    } catch (e) {
      return Left(NetworkFailure(
          message: 'Failed to fetch trending movies : ${e.toString()}'));
    }
  }

  Future<Map<String, dynamic>> getMovieData(int tmdb) async {
    Map<String, dynamic> movieData = {};

    String url = '${Api.apiTMDBMovie}$tmdb?language=fr-FR';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${ApiKeys.tmdbApiKey}',
        'accept': 'application/json',
      },
    ); // Log de la page et du statut

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data != null) {
        movieData['tmdb'] = tmdb;
        movieData['title'] = data['title'];
        int runtime = data['runtime'] as int; // Ensure runtime is an int
        int hours = runtime ~/ 60; // Use integer division operator (~/)
        int minutes = runtime % 60;
        movieData['duration'] = "${hours}h ${minutes}m";
        movieData['synopsis'] = data['overview'];

        final categories = data['genres'];
        List<Map<String, dynamic>> movieCategories = [];
        for (Map<String, dynamic> category in categories) {
          movieCategories.add({"name": category['name'], "id": category['id']});
        }
        movieData['categories'] = movieCategories;
        movieData['added'] = 0;
        movieData['coverWithText'] =
            data['poster_path'];
        int yearData =
            movieData['release_date'].toString().substring(0, 3) as int;
        movieData['year'] = yearData;
      } else {
        throw Exception('Movie data is null');
      }
    }

    String imagesUrl =
        '${Api.apiTMDBMovie}$tmdb/images?language=null';
    final imagesResponse = await http.get(
      Uri.parse(imagesUrl),
      headers: {
        'Authorization': 'Bearer ${ApiKeys.tmdbApiKey}',
        'accept': 'application/json',
      },
    ); // Log de la page et du statut

    if (response.statusCode == 200) {
      final data = json.decode(imagesResponse.body);

      if (data != null) {
        final backdrops = data['backdrops'];

        for (var backdrop in backdrops) {
          String backdropPath = backdrop['file_path'];
          if (backdropPath.endsWith('.jpg') || backdropPath.endsWith('.png')) {
            movieData['backdrop'] =
                backdropPath;
          }
        }

        final covers = data['posters'];
        for (var cover in covers) {
          String coverPath = cover['file_path'];
          if (coverPath.endsWith('.jpg') || coverPath.endsWith('.png')) {
            movieData['cover'] =
                coverPath;
          }
        }
      }
    }

    return movieData;
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getMostPopularMovies() async {
    try {
      List<MovieModel> mostPopularMovies = [];
      int page = 1;

      while (mostPopularMovies.length < 10) {
        String url =
            '${Api.apiTMDBMovie}top_rated?language=fr-FR&page=$page';
        final response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer ${ApiKeys.tmdbApiKey}',
            'accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data != null && data['results'] is List) {
            final results = data['results'];

            for (var result in results) {
              if (result != null) {
                int tmdbId = result['id'] ?? -1; // Défaut à -1 si 'id' est null
                bool isHorror = false;
                for (var genre in result['genre_ids']) {
                  if (genre == 27) {
                    isHorror = true;
                  }
                }

                // Filtrer les films d'horreur et les films sans ID valide
                if (tmdbId != -1 && !isHorror) {
                  Map<String, dynamic> movieData = await getMovieData(tmdbId);
                  MovieModel movie = MovieModel.fromJson(movieData);
                  mostPopularMovies.add(movie);
                } else {
                  print(
                      'Movie ID is null or is a horror movie for result: $result');
                }
              } else {
                print('Encountered null result');
              }
            }

            page++;
          } else {
            print('Unexpected results format or data is null: $data');
            throw Exception('Unexpected results format');
          }
        } else {
          print(
              'Error fetching most popular movies: ${response.statusCode}, ${response.body}');
          throw Exception('Failed to load most popular movies');
        }
      }
      return Right(mostPopularMovies);
    } catch (e) {
      return Left(NetworkFailure(
          message: 'Failed to fetch most popular movies : ${e.toString()}'));
    }
  }
}
