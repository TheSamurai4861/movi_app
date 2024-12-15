import 'package:flutter/material.dart';

class Serie {
  final int id;
  final int added;
  final String year;
  final String coverPath;
  final String coverWithTextPath;
  final String backdropPath;
  final String title;
  final String? synopsis;
  final ValueNotifier<bool> isFavorite;
  final List<Season> seasons;
  final List<SerieGenre> categories;

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

class Season {
  final String title;
  final List<Episode> episodes;

  Season({
    required this.title,
    required this.episodes,
  });
}

class Episode {
  final String title;
  final String backdropPath;
  final String duration;
  final String releaseDate;
  final String? synopsis;
  final List<SerieLink>? links;
  int? timeWatched;

  Episode({
    required this.title,
    required this.backdropPath,
    required this.duration,
    required this.releaseDate,
    this.synopsis,
    this.links,
    this.timeWatched
  });
}

class SerieGenre {
  final String title;
  final int id;

  SerieGenre({required this.title, required this.id});
}

class SerieLink {
  final String url;
  final String hoster;
  final String quality;
  final String language;

  SerieLink({required this.url, required this.hoster, required this.quality, required this.language});
}
