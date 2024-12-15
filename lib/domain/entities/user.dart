import 'package:movi_mobile/core/constants/paths/app_images.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/serie.dart';

/// Classe représentant un utilisateur avec ses informations personnelles
/// et ses contenus favoris.
///
/// ### Propriétés principales :
/// - [id] : Identifiant unique de l'utilisateur.
/// - [name] : Nom de l'utilisateur.
/// - [apiKey] : Clé API associée à l'utilisateur (facultatif).
/// - [isAdult] : Indique si l'utilisateur est majeur (1 = oui, 0 = non).
/// - [favorites] : Contient les favoris de l'utilisateur (films et séries).
/// - [imagePath] : Chemin vers l'image de profil de l'utilisateur.
class User {
  /// Identifiant unique de l'utilisateur.
  final int id;

  /// Nom de l'utilisateur.
  final String name;

  /// Clé API associée à l'utilisateur (facultatif).
  final String? apiKey;

  /// Indique si l'utilisateur est majeur (1 = oui, 0 = non).
  final int isAdult;

  /// Contient les favoris de l'utilisateur (films et séries).
  final UserFavorites favorites;

  /// Chemin vers l'image de profil de l'utilisateur.
  ///
  /// Par défaut, il utilise l'image définie dans [AppImages.userPath].
  String imagePath;

  /// Constructeur pour initialiser un objet [User].
  ///
  /// - [id], [name], [isAdult] et [favorites] sont requis.
  /// - [apiKey] et [imagePath] sont facultatifs, avec une valeur par défaut 
  ///   pour [imagePath].
  User({
    required this.id,
    required this.name,
    this.apiKey,
    required this.isAdult,
    required this.favorites,
    this.imagePath = AppImages.userPath,
  });
}

/// Classe représentant les contenus favoris d'un utilisateur.
///
/// ### Propriétés principales :
/// - [movies] : Liste des films favoris (facultatif).
/// - [series] : Liste des séries favorites (facultatif).
class UserFavorites {
  /// Liste des films favoris de l'utilisateur (facultatif).
  List<Movie>? movies;

  /// Liste des séries favorites de l'utilisateur (facultatif).
  List<Serie>? series;

  /// Constructeur pour initialiser un objet [UserFavorites].
  ///
  /// Les deux propriétés [movies] et [series] sont facultatives.
  UserFavorites({
    this.movies,
    this.series,
  });
}
