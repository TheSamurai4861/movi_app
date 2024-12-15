import '../../domain/entities/movie.dart';

class MovieModel {
  final int id;
  final String title;
  final String duration;
  final String? synopsis;
  final List<MovieGenreModel> categories;
  final bool? isFavorite;
  final int? timeWatched;
  final List<MovieLinkModel> links;
  final int added;
  final String coverPath;
  final String coverWithTextPath;
  final String year;
  final String backdropPath;

  MovieModel(
      {required this.id,
      required this.title,
      required this.duration,
      this.synopsis,
      required this.categories,
      this.isFavorite,
      this.timeWatched,
      required this.links,
      required this.added,
      required this.coverPath,
      required this.coverWithTextPath,
      required this.year,
      required this.backdropPath});

  // Méthode pour convertir en entité de domaine
  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      duration: duration,
      synopsis: synopsis ?? 'Pas de synopsis disponible.',
      categories: categories.map((e) => e.toEntity()).toList(),
      isFavorite: isFavorite ?? false,
      timeWatched: timeWatched ?? 0,
      links: links.map((e) => e.toEntity()).toList(),
      added: added,
      coverPath: coverPath,
      year: year,
      coverWithTextPath: coverWithTextPath,
      backdropPath: backdropPath,
    );
  }

  factory MovieModel.fromEntity(Movie movie) {
  return MovieModel(
    id: movie.id,
    title: movie.title,
    duration: movie.duration,
    synopsis: movie.synopsis,
    categories: movie.categories
        .map((category) => MovieGenreModel.fromEntity(category))
        .toList(),
    isFavorite: movie.isFavorite.value,
    timeWatched: movie.timeWatched,
    links: movie.links
        .map((link) => MovieLinkModel.fromEntity(link))
        .toList(),
    added: movie.added,
    coverPath: movie.coverPath,
    year: movie.year,
    coverWithTextPath: movie.coverWithTextPath,
    backdropPath: movie.backdropPath,
  );
}


  // Factory method for JSON deserialization
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      duration: json['duration'],
      synopsis: json['synopsis'],
      categories: (json['categories'] as List)
          .map((e) => MovieGenreModel.fromJson(e))
          .toList(),
      isFavorite: json['is_favorite'] ?? false,
      timeWatched: json['time_watched'] ?? 0,
      links: (json['links'] as List?)
          ?.map((e) => MovieLinkModel.fromJson(e))
          .toList() ?? [],
      added: json['added'],
      coverPath: json['cover_path'],
      coverWithTextPath: json['cover_text_path'],
      year: json['year'],
      backdropPath: json['backdrop_path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'synopsis': synopsis,
      'is_favorite': isFavorite,
      'time_watched': timeWatched,
      'added': added,
      'cover_path': coverPath,
      'cover_text_path': coverWithTextPath,
      'year': year,
      'backdrop_path': backdropPath,
    };
  }
}


class MovieGenreModel {
  final String title;
  final int id;

  MovieGenreModel({
    required this.title,
    required this.id,
  });

  // Convertir en entité
  MovieGenre toEntity() {
    return MovieGenre(
      title: title,
      id: id,
    );
  }

  // Factory pour créer un modèle à partir d'une entité
  factory MovieGenreModel.fromEntity(MovieGenre genre) {
    return MovieGenreModel(
      title: genre.title,
      id: genre.id,
    );
  }

  // Factory pour créer un modèle à partir d'une Map JSON
  factory MovieGenreModel.fromJson(Map<String, dynamic> json) {
    return MovieGenreModel(
      title: json['title'],
      id: json['id'],
    );
  }

  // Convertir en Map JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
    };
  }
}

class MovieLinkModel {
  final String url;
  final String hoster;
  final String quality;
  final String language;

  MovieLinkModel({
    required this.url,
    required this.hoster,
    required this.quality,
    required this.language,
  });

  // Convertir en entité
  MovieLink toEntity() {
    return MovieLink(
      url: url,
      hoster: hoster,
      quality: quality,
      language: language,
    );
  }

  // Factory pour créer un modèle à partir d'une entité
  factory MovieLinkModel.fromEntity(MovieLink link) {
    return MovieLinkModel(
      url: link.url,
      hoster: link.hoster,
      quality: link.quality,
      language: link.language,
    );
  }

  // Factory pour créer un modèle à partir d'une Map JSON
  factory MovieLinkModel.fromJson(Map<String, dynamic> json) {
    return MovieLinkModel(
      url: json['url'],
      hoster: json['hoster'] ?? 1,
      quality: json['quality'],
      language: json['language'],
    );
  }

  // Convertir en Map JSON
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'hoster': hoster,
      'quality': quality,
      'language': language,
    };
  }
}
