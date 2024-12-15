import 'package:movi_mobile/core/constants/paths/app_images.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/serie.dart';

class User {
  final int id;
  final String name;
  final String? apiKey;
  final int isAdult;
  final UserFavorites favorites;
  String imagePath;

  User({required this.id, required this.name, this.apiKey, required this.isAdult, required this.favorites, this.imagePath = AppImages.userPath});
}

class UserFavorites {
  List<Movie>? movies;
  List<Serie>? series;

  UserFavorites({
    this.movies,
    this.series
  });
}
