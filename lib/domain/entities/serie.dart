import 'package:flutter/material.dart';

/// Classe représentant une série TV avec ses métadonnées, ses saisons, 
/// et ses genres.
///
/// ### Propriétés principales :
/// - [id] : Identifiant unique de la série.
/// - [added] : Timestamp indiquant quand la série a été ajoutée.
/// - [year] : Année de sortie de la série.
/// - [coverPath] : Chemin vers l'image de couverture de la série.
/// - [coverWithTextPath] : Chemin vers l'image de couverture avec texte.
/// - [backdropPath] : Chemin vers l'image de fond de la série.
/// - [title] : Titre de la série.
/// - [synopsis] : Résumé de la série (par défaut : "Pas de synopsis disponible.").
/// - [isFavorite] : Indique si la série est marquée comme favori.
/// - [seasons] : Liste des saisons associées à la série.
/// - [categories] : Liste des genres associés à la série.
class Serie {
  /// Identifiant unique de la série.
  final int id;

  /// Timestamp indiquant quand la série a été ajoutée (format Unix).
  final int added;

  /// Année de sortie de la série.
  final String year;

  /// Chemin vers l'image de couverture de la série.
  final String coverPath;

  /// Chemin vers l'image de couverture avec texte intégré.
  final String coverWithTextPath;

  /// Chemin vers l'image de fond de la série.
  final String backdropPath;

  /// Titre de la série.
  final String title;

  /// Résumé de la série (facultatif).
  final String? synopsis;

  /// Indique si la série est marquée comme favori.
  final ValueNotifier<bool> isFavorite;

  /// Liste des saisons associées à la série.
  final List<Season> seasons;

  /// Liste des genres associés à la série.
  final List<SerieGenre> categories;

  /// Constructeur pour initialiser un objet [Serie].
  ///
  /// - [id], [added], [year], [coverPath], [coverWithTextPath], [backdropPath], 
  ///   [title], [seasons], et [categories] sont requis.
  /// - [synopsis] est facultatif, avec une valeur par défaut "Pas de synopsis disponible.".
  /// - [isFavorite] est initialisé à `false` par défaut.
  Serie({
    required this.id,
    required this.added,
    required this.coverPath,
    required this.title,
    required this.year,
    required this.coverWithTextPath,
    required this.backdropPath,
    required this.seasons,
    required this.categories,
    this.synopsis = 'Pas de synopsis disponible.',
    bool isFavorite = false,
  }) : isFavorite = ValueNotifier<bool>(isFavorite);
}

/// Classe représentant une saison d'une série.
///
/// ### Propriétés principales :
/// - [title] : Titre de la saison (ex. "Saison 1").
/// - [episodes] : Liste des épisodes de la saison.
class Season {
  /// Titre de la saison (ex. "Saison 1").
  final String title;

  /// Liste des épisodes de la saison.
  final List<Episode> episodes;

  /// Constructeur pour initialiser un objet [Season].
  Season({
    required this.title,
    required this.episodes,
  });
}

/// Classe représentant un épisode d'une série.
///
/// ### Propriétés principales :
/// - [title] : Titre de l'épisode.
/// - [backdropPath] : Chemin vers l'image de fond de l'épisode.
/// - [duration] : Durée de l'épisode (ex. "45 min").
/// - [releaseDate] : Date de sortie de l'épisode.
/// - [synopsis] : Résumé de l'épisode (facultatif).
/// - [links] : Liste des liens de streaming pour l'épisode (facultatif).
/// - [timeWatched] : Temps visionné en minutes (facultatif).
class Episode {
  /// Titre de l'épisode.
  final String title;

  /// Chemin vers l'image de fond de l'épisode.
  final String backdropPath;

  /// Durée de l'épisode (ex. "45 min").
  final String duration;

  /// Date de sortie de l'épisode.
  final String releaseDate;

  /// Résumé de l'épisode (facultatif).
  final String? synopsis;

  /// Liste des liens de streaming pour l'épisode (facultatif).
  final List<SerieLink>? links;

  /// Temps visionné en minutes (facultatif).
  int? timeWatched;

  /// Constructeur pour initialiser un objet [Episode].
  Episode({
    required this.title,
    required this.backdropPath,
    required this.duration,
    required this.releaseDate,
    this.synopsis,
    this.links,
    this.timeWatched,
  });
}

/// Classe représentant un genre associé à une série (ex. Drame, Comédie).
///
/// ### Propriétés principales :
/// - [id] : Identifiant unique du genre (ex. 35 pour Comédie).
/// - [title] : Nom du genre (ex. "Comédie").
class SerieGenre {
  /// Nom du genre (ex. "Comédie").
  final String title;

  /// Identifiant unique du genre (ex. 35).
  final int id;

  /// Constructeur pour initialiser un objet [SerieGenre].
  SerieGenre({
    required this.title,
    required this.id,
  });
}

/// Classe représentant un lien de streaming pour un épisode.
///
/// ### Propriétés principales :
/// - [url] : URL du lien de streaming.
/// - [hoster] : Nom de l'hébergeur (ex. "YouTube").
/// - [quality] : Qualité du lien (ex. "1080p").
/// - [language] : Langue du contenu (ex. "FR", "EN").
class SerieLink {
  /// URL du lien de streaming.
  final String url;

  /// Nom de l'hébergeur (ex. "YouTube").
  final String hoster;

  /// Qualité du lien (ex. "1080p").
  final String quality;

  /// Langue du contenu (ex. "FR", "EN").
  final String language;

  /// Constructeur pour initialiser un objet [SerieLink].
  SerieLink({
    required this.url,
    required this.hoster,
    required this.quality,
    required this.language,
  });
}
