/// Classe qui décrit les caractéristiques nécessaires pour initialiser 
/// un lecteur média via un objet [PlayerRouteArguments].
///
/// Cet objet contient : 
/// - [media] : les informations du média à lire (ex. URL, fichier, etc.).
/// - [season] : (facultatif) la saison à lire, pour les séries.
/// - [episode] : (facultatif) l'épisode à lire, pour les séries.
library;

class PlayerRouteArguments {
  /// Les informations du média à lire.
  final dynamic media;

  /// La saison (optionnel, pour les séries).
  final int? season;

  /// L'épisode (optionnel, pour les séries).
  final int? episode;

  /// Crée un objet [PlayerRouteArguments] avec les détails du média.
  ///
  /// - [media] est requis.
  /// - [season] et [episode] sont facultatifs.
  PlayerRouteArguments({
    required this.media,
    this.season,
    this.episode,
  });
}
