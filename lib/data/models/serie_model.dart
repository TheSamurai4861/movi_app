import 'package:movi_mobile/domain/entities/serie.dart';

class SerieModel {
  final int id;
  final int added;
  final String year;
  final String coverPath;
  final String coverWithTextPath;
  final String backdropPath;
  final String title;
  final String? synopsis;
  final bool isFavorite;
  final List<SeasonModel> seasons;
  final List<SerieGenreModel> categories;

  SerieModel({
    required this.id,
    required this.added,
    required this.year,
    required this.coverPath,
    required this.coverWithTextPath,
    required this.backdropPath,
    required this.title,
    this.synopsis,
    required this.isFavorite,
    required this.seasons,
    required this.categories,
  });

  // Méthode pour convertir en entité de domaine
  Serie toEntity() {
    return Serie(
      id: id,
      added: added,
      year: year,
      coverPath: coverPath,
      coverWithTextPath: coverWithTextPath,
      backdropPath: backdropPath,
      title: title,
      synopsis: synopsis,
      isFavorite: isFavorite,
      seasons: seasons.map((e) => e.toEntity()).toList(),
      categories: categories.map((e) => e.toEntity()).toList(),
    );
  }

  // Méthode toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'added': added,
      'year': year,
      'cover_path': coverPath,
      'cover_text_path': coverWithTextPath,
      'backdrop_path': backdropPath,
      'title': title,
      'synopsis': synopsis,
      'is_favorite': isFavorite,
    };
  }

  // Factory pour désérialiser depuis JSON
  factory SerieModel.fromJson(Map<String, dynamic> json) {
    return SerieModel(
      id: json['id'],
      added: json['added'],
      year: json['year'],
      coverPath: json['cover_path'],
      coverWithTextPath: json['cover_text_path'],
      backdropPath: json['backdrop_path'],
      title: json['title'],
      synopsis: json['synopsis'],
      isFavorite: json['is_favorite'],
      seasons: (json['seasons'] as List<dynamic>)
          .map((e) => SeasonModel.fromJson(e))
          .toList(),
      categories: (json['categories'] as List<dynamic>)
          .map((e) => SerieGenreModel.fromJson(e))
          .toList(),
    );
  }

  factory SerieModel.fromEntity(Serie serie) {
    return SerieModel(
      added: serie.added,
      id: serie.id,
      title: serie.title,
      year: serie.year,
      coverPath: serie.coverPath,
      coverWithTextPath: serie.coverWithTextPath,
      backdropPath: serie.backdropPath,
      synopsis: serie.synopsis,
      isFavorite: serie.isFavorite.value,
      categories: serie.categories
          .map((genre) => SerieGenreModel.fromEntity(genre))
          .toList(),
      seasons: serie.seasons
          .map((season) => SeasonModel.fromEntity(season))
          .toList(),
    );
  }
}

class SeasonModel {
  final String title;
  final List<EpisodeModel> episodes;

  SeasonModel({
    required this.title,
    required this.episodes,
  });

  // Convertir SeasonModel en entité Season
  Season toEntity() {
    return Season(
      title: title,
      episodes: episodes.map((e) => e.toEntity()).toList(),
    );
  }

  // Factory pour créer un SeasonModel à partir d'une entité Season
  factory SeasonModel.fromEntity(Season season) {
    return SeasonModel(
      title: season.title,
      episodes: season.episodes
          .map((episode) => EpisodeModel.fromEntity(episode))
          .toList(),
    );
  }

  Map<String, dynamic> toJson(int serieId) {
  return {
    'id': int.parse('00$serieId'), // Ajoute des zéros à gauche pour une longueur de 3
    'serie_id': serieId,
    'title': title,
  };
}


  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      title: json['title'],
      episodes: (json['episodes'] as List<dynamic>)
          .map((e) => EpisodeModel.fromJson(e))
          .toList(),
    );
  }
}

class SerieGenreModel {
  final String title;
  final int id;

  SerieGenreModel({required this.title, required this.id});

  // Convertir SerieGenreModel en entité SerieGenre
  SerieGenre toEntity() {
    return SerieGenre(
      title: title,
      id: id,
    );
  }

  // Factory pour créer un SerieGenreModel à partir d'une entité SerieGenre
  factory SerieGenreModel.fromEntity(SerieGenre genre) {
    return SerieGenreModel(
      title: genre.title,
      id: genre.id,
    );
  }

  Map<String, dynamic> toJson(int serieId) {
    return {
      'serie_id': serieId,
      'genre_id': id,
    };
  }

  factory SerieGenreModel.fromJson(Map<String, dynamic> json) {
    return SerieGenreModel(
      title: json['title'],
      id: json['id'],
    );
  }
}

class EpisodeModel {
  final String title;
  final String backdropPath;
  final String duration;
  final String releaseDate;
  final String? synopsis;
  final List<SerieLinkModel>? links;
  int? timeWatched;

  EpisodeModel(
      {required this.title,
      required this.backdropPath,
      required this.duration,
      required this.releaseDate,
      this.synopsis,
      this.links,
      this.timeWatched});

  // Convertir EpisodeModel en entité Episode
  Episode toEntity() {
    return Episode(
        title: title,
        backdropPath: backdropPath,
        duration: duration,
        releaseDate: releaseDate,
        synopsis: synopsis,
        links: links?.map((e) => e.toEntity()).toList(),
        timeWatched: timeWatched);
  }

  // Factory pour créer un EpisodeModel à partir d'une entité Episode
  factory EpisodeModel.fromEntity(Episode episode) {
    return EpisodeModel(
        title: episode.title,
        backdropPath: episode.backdropPath,
        duration: episode.duration,
        releaseDate: episode.releaseDate,
        synopsis: episode.synopsis,
        links: episode.links
            ?.map((link) => SerieLinkModel.fromEntity(link))
            .toList(),
        timeWatched: episode.timeWatched);
  }

  Map<String, dynamic> toJson(int seasonId) {
    return {
      'title': title,
      'backdrop_path': backdropPath,
      'duration': duration,
      'release_date': releaseDate,
      'synopsis': synopsis,
      'season_id' : seasonId, 
      'id' : int.parse('00$seasonId'),
    };
  }

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
        title: json['title'],
        backdropPath: json['backdrop_path'],
        duration: json['duration'],
        releaseDate: json['release_date'],
        synopsis: json['synopsis'],
        links: (json['links'] as List<dynamic>?)
            ?.map((e) => SerieLinkModel.fromJson(e))
            .toList(),
        timeWatched: json['time_watched']);
  }
}

class SerieLinkModel {
  final String url;
  final String hoster;
  final String quality;
  final String language;

  SerieLinkModel({
    required this.url,
    required this.hoster,
    required this.quality,
    required this.language,
  });

  // Convertir SerieLinkModel en entité SerieLink
  SerieLink toEntity() {
    return SerieLink(
      url: url,
      hoster: hoster,
      quality: quality,
      language: language,
    );
  }

  // Factory pour créer un SerieLinkModel à partir d'une entité SerieLink
  factory SerieLinkModel.fromEntity(SerieLink link) {
    return SerieLinkModel(
      url: link.url,
      hoster: link.hoster,
      quality: link.quality,
      language: link.language,
    );
  }

  Map<String, dynamic> toJson(int episodeId) {
    return {
      'episode_id': episodeId,
      'url': url,
      'hoster': hoster,
      'quality': quality,
      'language': language,
    };
  }

  factory SerieLinkModel.fromJson(Map<String, dynamic> json) {
    return SerieLinkModel(
      url: json['url'],
      hoster: json['hoster'],
      quality: json['quality'],
      language: json['language'],
    );
  }
}
