import 'package:flutter/material.dart';

class Movie {
  final int id;
  final int added;
  int? timeWatched;
  final String year;
  final String coverPath;
  final String coverWithTextPath;
  final String backdropPath;
  final String title;
  final String duration;
  final String synopsis;
  final ValueNotifier<bool> isFavorite;
  final List<MovieGenre> categories;
  final List<MovieLink> links;
  
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
    // Regarder pour ne pas dupliquer
    this.synopsis = 'Pas de synopsis disponible.', 
    required this.links,
    this.timeWatched,
    bool isFavorite = false,
  }) : isFavorite = ValueNotifier<bool>(isFavorite);
}

class MovieGenre {
  final String title;
  final int id;

  MovieGenre({required this.title, required this.id});
}

class MovieLink {
  final String url;
  final String hoster;
  final String quality;
  final String language;

  MovieLink({required this.url, required this.hoster, required this.quality, required this.language});
}