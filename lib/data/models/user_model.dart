import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/data/models/movie_model.dart';
import 'package:movi_mobile/data/models/serie_model.dart';
import 'package:movi_mobile/core/constants/paths/app_images.dart';

class UserModel {
  final int id;
  final String name;
  final String? apiKey;
  final int isAdult;
  final String imagePath;
  final List<MovieModel>? favoriteMovies;
  final List<SerieModel>? favoriteSeries;

  UserModel({
    required this.id,
    required this.name,
    this.apiKey,
    required this.isAdult,
    this.imagePath = AppImages.userPath,
    this.favoriteMovies,
    this.favoriteSeries,
  });

  // Convertir UserModel en entité User
  User toEntity() {
    return User(
      id: id,
      name: name,
      apiKey: apiKey,
      isAdult: isAdult,
      imagePath: imagePath,
      favorites: UserFavorites(
        movies: favoriteMovies?.map((movie) => movie.toEntity()).toList(),
        series: favoriteSeries?.map((serie) => serie.toEntity()).toList(),
      ),
    );
  }

  // Factory pour créer un UserModel à partir d'une entité User
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      apiKey: user.apiKey,
      isAdult: user.isAdult,
      imagePath: user.imagePath,
      favoriteMovies: user.favorites.movies
          ?.map((movie) => MovieModel.fromEntity(movie))
          .toList(),
      favoriteSeries: user.favorites.series
          ?.map((serie) => SerieModel.fromEntity(serie))
          .toList(),
    );
  }

  // Factory pour créer un UserModel à partir d'une Map JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      apiKey: json['api_key'],
      isAdult: json['is_adult'],
      imagePath: json['image_path'] ?? AppImages.userPath,
      favoriteMovies: (json['favorite_movies'] as List<dynamic>?)
          ?.map((movie) => MovieModel.fromJson(movie))
          .toList(),
      favoriteSeries: (json['favorite_series'] as List<dynamic>?)
          ?.map((serie) => SerieModel.fromJson(serie))
          .toList(),
    );
  }

  // Méthode pour convertir un UserModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'api_key': apiKey,
      'is_adult': isAdult,
      'image_path': imagePath,
      'favorite_movies':
          favoriteMovies?.map((movie) => movie.toJson()).toList(),
      'favorite_series':
          favoriteSeries?.map((serie) => serie.toJson()).toList(),
    };
  }
}
