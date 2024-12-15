import 'package:flutter/material.dart';

/// Classe qui donne toutes les caractéristiques d'un objet [Movie].
///
/// Cet objet représente un film avec ses métadonnées, ses catégories, 
/// et les liens de streaming associés.
///
/// ### Propriétés principales :
/// - [id] : Identifiant unique du film.
/// - [added] : Timestamp indiquant quand le film a été ajouté.
/// - [timeWatched] : Temps visionné en minutes (optionnel).
/// - [year] : Année de sortie du film.
/// - [coverPath] : Chemin vers l'image de couverture du film.
/// - [coverWithTextPath] : Chemin vers l'image de couverture avec texte.
/// - [backdropPath] : Chemin vers l'image de fond du film.
/// - [title] : Titre du film.
/// - [duration] : Durée du film (ex. "2h30").
/// - [synopsis] : Résumé du film (par défaut "Pas de synopsis disponible.").
/// - [isFavorite] : Indique si le film est marqué comme favori.
/// - [categories] : Liste des genres associés au film.
/// - [links] : Liste des liens de streaming disponibles pour le film.
class Movie {
  /// Identifiant unique du film.
  final int id;

  /// Timestamp indiquant la date d'ajout (format Unix).
  final int added;

  /// Temps visionné en minutes (optionnel).
  int? timeWatched;

  /// Année de sortie du film.
  final String year;

  /// Chemin vers l'image de couverture du film.
  final String coverPath;

  /// Chemin vers l'image de couverture avec texte intégré.
  final String coverWithTextPath;

  /// Chemin vers l'image de fond du film.
  final String backdropPath;

  /// Titre du film.
  final String title;

  /// Durée du film (ex. "2h30").
  final String duration;

  /// Résumé du film.
  final String synopsis;

  /// Indique si le film est marqué comme favori.
  final ValueNotifier<bool> isFavorite;

  /// Liste des genres associés au film.
  final List<MovieGenre> categories;

  /// Liste des liens de streaming disponibles pour le film.
  final List<MovieLink> links;

  /// Constructeur pour initialiser un objet [Movie].
  ///
  /// - [id], [added], [year], [coverPath], [coverWithTextPath], [backdropPath], 
  ///   [title], [duration], [categories], et [links] sont requis.
  /// - [synopsis] est facultatif, avec une valeur par défaut : "Pas de synopsis disponible."
  /// - [timeWatched] est optionnel.
  /// - [isFavorite] est initialisé avec la valeur par défaut `false`.
  Movie({
    required this.id,
    required this.coverPath,
    required this.title,
    required this.duration,
    required this.year,
    required this.coverWithTextPath,
    required this.backdropPath,
    required this.added,
    required this.categories,
    this.synopsis = 'Pas de synopsis disponible.',
    required this.links,
    this.timeWatched,
    bool isFavorite = false,
  }) : isFavorite = ValueNotifier<bool>(isFavorite);
}

/// Classe qui décrit un genre de film (par exemple, Action, Drame).
///
/// Chaque objet [MovieGenre] contient :
/// - [id] : Identifiant unique du genre (ex. 28 pour Action).
/// - [title] : Nom du genre (ex. "Action").
class MovieGenre {
  /// Nom du genre (ex. "Action").
  final String title;

  /// Identifiant unique du genre (ex. 28).
  final int id;

  /// Constructeur pour initialiser un objet [MovieGenre].
  MovieGenre({required this.title, required this.id});
}

/// Classe qui décrit un lien de streaming pour un film.
///
/// Chaque objet [MovieLink] contient :
/// - [url] : URL du lien de streaming.
/// - [hoster] : Nom de l'hébergeur (ex. "YouTube").
/// - [quality] : Qualité du lien (ex. "1080p").
/// - [language] : Langue du contenu (ex. "FR", "EN").
class MovieLink {
  /// URL du lien de streaming.
  final String url;

  /// Nom de l'hébergeur (ex. "YouTube").
  final String hoster;

  /// Qualité du lien (ex. "1080p").
  final String quality;

  /// Langue du contenu (ex. "FR", "EN").
  final String language;

  /// Constructeur pour initialiser un objet [MovieLink].
  MovieLink({
    required this.url,
    required this.hoster,
    required this.quality,
    required this.language,
  });
}
