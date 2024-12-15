import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/constants/dp_paths/movi_db_paths.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/data/datasources/local/local_database.dart';
import 'package:movi_mobile/data/models/serie_model.dart';
import 'package:movi_mobile/data/models/user_model.dart';
import 'package:movi_mobile/domain/entities/provider.dart';

abstract class SerieLocalDatasource {
  Future<Either<Failure, void>> addNewSerie(SerieModel serie);
  Future<Either<Failure, List<SerieModel>>> getFavoritesUserSeries(UserModel user);
  Future<Either<Failure, List<SerieModel>>> getNowPlayingSeries(UserModel user);
  Future<Either<Failure, List<SerieGenreModel>>> getSerieGenres();
  Future<Either<Failure, List<Provider>>> getSerieProviders();
  Future<Either<Failure, List<SerieModel>>> getSeriesByGenre();
  Future<Either<Failure, List<SerieModel>>> getSeriesByProvider();
  Future<Either<Failure, List<SerieModel>>> searchSerie(String query);
  Future<Either<Failure, bool>> isFavoriteSerie(SerieModel serie);
  Future<Either<Failure, void>> updateFavoriteSerie(SerieModel serie);
}

class SerieLocalDatasourceImpl implements SerieLocalDatasource {
  final LocalDatabase db;

  SerieLocalDatasourceImpl(this.db);

  // Méthodes utilitaires pour réduire les répétitions
  Future<List<SerieGenreModel>> _getMovieGenres(int serieId) async {
    final database = await db.database;
    final genres = await database.rawQuery('''
      SELECT g.id, g.title
      FROM ${MoviDbPaths.serieGenreTable} g
      JOIN ${MoviDbPaths.serieSerieGenreTable} mmg ON mmg.genre_id = g.id
      WHERE mmg.movie_id = ?
    ''', [serieId]);

    return genres.map((genre) => SerieGenreModel.fromJson(genre)).toList();
  }

  Future<List<SeasonModel>> _getSeasons(int serieId) async {
    final database = await db.database;
    List<SeasonModel> seasonsFinal = [];
    final seasons = await database.query('season', where: 'serie_id = ?', whereArgs: [serieId]);
    for(var season in seasons) {
      List<EpisodeModel> episodes = await _getEpisodes(season["season_id"] as int);
      SeasonModel seasonModel = SeasonModel(title: season['title'] as String, episodes: episodes);
      seasonsFinal.add(seasonModel);
    }
    return seasonsFinal;
  }

  Future<List<EpisodeModel>> _getEpisodes(int serieId) async {
    final database = await db.database;
    List<EpisodeModel> episodesFinal = [];
    final episodes = await database.query('season', where: 'serie_id = ?', whereArgs: [serieId]);
    for(var episode in episodes) {
      List<SerieLinkModel> links = await _getSerieLinks(episode['id'] as int);
      //  time à faire
      EpisodeModel episodeModel = EpisodeModel(title: episode['title'] as String, backdropPath: episode['backdrop_path'] as String, duration: episode['duration'] as String, releaseDate: episode['release_date'] as String, links: links, synopsis: episode['synopsis'] as String? ?? 'Pas de synopsis', timeWatched: 0);
      episodesFinal.add(episodeModel);
    }
    return episodesFinal;
  }

  Future<List<SerieLinkModel>> _getSerieLinks(int episodeId) async {
    final database = await db.database;
    List<SerieLinkModel> linksFinal = [];
    final links = await database.query(MoviDbPaths.serieLinkTable, where: 'episode_id = ?', whereArgs: [episodeId]);
    for(var link in links) {
      SerieLinkModel serieLinkModel = SerieLinkModel(url: link['url'] as String, hoster: link['hoster'] as String, quality: link['quality'] as String, language: link['language'] as String);
      linksFinal.add(serieLinkModel);
    }
    return linksFinal;
  }

  Future<SerieModel> _buildSerieModel(Map<String, dynamic> serieMap) async {
  final id = serieMap['id'] as int? ?? -1;
  
  return SerieModel(
    id: id,
    added: serieMap['added'],
    title: serieMap['title'] as String? ?? 'Titre inconnu',
    synopsis: serieMap['synopsis'] as String? ?? 'Synopsis non disponible',
    categories: await _getMovieGenres(id),
    coverPath: serieMap['cover_path'] as String? ?? '',
    coverWithTextPath: serieMap['cover_text_path'] as String? ?? '',
    year: serieMap['year'] as String? ?? 'Année inconnue',
    backdropPath: serieMap['backdrop_path'] as String? ?? '', 
    isFavorite: false,
    seasons: await _getSeasons(id),
  );
}

  @override
  Future<Either<Failure, void>> addNewSerie(SerieModel serie) async {
    try {
      final database = await db.database;
      await database.insert('serie', serie.toJson());
      for (var categorie in serie.categories) {
        await database.insert('serie_serie_genre', categorie.toJson(serie.id));
      }
      for (var season in serie.seasons) {
        await database.insert('season', season.toJson(serie.id));
        for (var episode in season.episodes) {
          int seasonId = int.parse('00${serie.id}');
          await database.insert('episode', episode.toJson(seasonId));
          if(episode.links != null) {
            for (var link in episode.links!){
              int episodeId = int.parse('00$seasonId');
              await database.insert('serie_link', link.toJson(episodeId));
            }
          }
        }
      }
      return Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to add new serie : ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<SerieModel>>> getFavoritesUserSeries(UserModel user) {
    // TODO: implement getFavoritesUserSeries
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SerieModel>>> getNowPlayingSeries(UserModel user) {
    // TODO: implement getNowPlayingSeries
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SerieGenreModel>>> getSerieGenres() {
    // TODO: implement getSerieGenres
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Provider>>> getSerieProviders() {
    // TODO: implement getSerieProviders
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SerieModel>>> getSeriesByGenre() {
    // TODO: implement getSeriesByGenre
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SerieModel>>> getSeriesByProvider() {
    // TODO: implement getSeriesByProvider
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isFavoriteSerie(SerieModel serie) {
    // TODO: implement isFavoriteSerie
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<SerieModel>>> searchSerie(String query) {
    // TODO: implement searchSerie
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> updateFavoriteSerie(SerieModel serie) {
    // TODO: implement updateFavoriteSerie
    throw UnimplementedError();
  }
  
}
