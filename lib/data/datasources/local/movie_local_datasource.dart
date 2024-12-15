import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/constants/dp_paths/movi_db_paths.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/data/datasources/local/local_database.dart';
import 'package:movi_mobile/data/models/movie_model.dart';
import 'package:movi_mobile/data/models/provider_model.dart';
import 'package:movi_mobile/data/models/user_model.dart';

abstract class MovieLocalDatasource {
  Future<Either<Failure, List<MovieModel>>> getMoviesByGenre(
      MovieGenreModel genre);
  Future<Either<Failure, List<MovieModel>>> getMoviesByProvider(
      ProviderModel provider);
  Future<Either<Failure, List<MovieModel>>> searchMovie(String query);
  Future<Either<Failure, List<MovieModel>>> getFavoritesUserMovies(
      UserModel user);
  Future<Either<Failure, List<MovieModel>>> getNowPlayingMovies(UserModel user);
  Future<Either<Failure, void>> addNewMovie(MovieModel movie);
  Future<Either<Failure, List<MovieGenreModel>>> getMovieGenres();
  Future<Either<Failure, List<ProviderModel>>> getMovieProviders();
  Future<Either<Failure, void>> updateFavoriteMovie(
      MovieModel movie, UserModel user);
  Future<Either<Failure, bool>> isFavoriteMovie(
      MovieModel movie, UserModel user);
}

class MovieLocalDatasourceImpl implements MovieLocalDatasource {
  final LocalDatabase db;

  MovieLocalDatasourceImpl(this.db);

  // Méthodes utilitaires pour réduire les répétitions
  Future<List<MovieGenreModel>> _getMovieGenres(int movieId) async {
    final database = await db.database;
    final genres = await database.rawQuery('''
      SELECT g.id, g.title
      FROM ${MoviDbPaths.movieGenreTable} g
      JOIN ${MoviDbPaths.movieMovieGenreTable} mmg ON mmg.genre_id = g.id
      WHERE mmg.movie_id = ?
    ''', [movieId]);

    return genres.map((genre) => MovieGenreModel.fromJson(genre)).toList();
  }

  Future<List<MovieLinkModel>> _getMovieLinks(int movieId) async {
    final database = await db.database;
    final links = await database.rawQuery('''
      SELECT url, hoster, quality, language
      FROM ${MoviDbPaths.movieLinkTable}
      WHERE movie_id = ?
    ''', [movieId]);

    return links.map((link) => MovieLinkModel.fromJson(link)).toList();
  }

  Future<MovieModel> _buildMovieModel(Map<String, dynamic> movieMap) async {
  final id = movieMap['id'] as int? ?? -1; // ID par défaut si absent
  
  return MovieModel(
    id: id,
    title: movieMap['title'] as String? ?? 'Titre inconnu',
    duration: movieMap['duration'] as String? ?? 'Durée non spécifiée',
    synopsis: movieMap['synopsis'] as String? ?? 'Synopsis non disponible',
    categories: await _getMovieGenres(id),
    links: await _getMovieLinks(id),
    added: movieMap['added'] as int? ?? 0,
    coverPath: movieMap['cover_path'] as String? ?? '',
    coverWithTextPath: movieMap['cover_text_path'] as String? ?? '',
    year: movieMap['year'] as String? ?? 'Année inconnue',
    backdropPath: movieMap['backdrop_path'] as String? ?? '',
  );
}


  @override
  Future<Either<Failure, void>> addNewMovie(MovieModel movie) async {
    try {
      final database = await db.database;
      await database.insert(MoviDbPaths.movieTable, movie.toJson());
      for (var category in movie.categories) {
        await database.insert(
            MoviDbPaths.movieMovieGenreTable, category.toJson());
      }
      for (var link in movie.links) {
        await database.insert(MoviDbPaths.movieLinkTable, link.toJson());
      }
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to add new movie: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getMoviesByGenre(
      MovieGenreModel genre) async {
    try {
      final database = await db.database;
      final movies = await database.rawQuery('''
        SELECT * 
        FROM ${MoviDbPaths.movieTable} m
        JOIN ${MoviDbPaths.movieMovieGenreTable} mmg ON m.id = mmg.movie_id
        WHERE mmg.genre_id = ?
      ''', [genre.id]);

      final result =
          await Future.wait(movies.map((movie) => _buildMovieModel(movie)));
      return Right(result);
    } catch (e) {
      return Left(
          DatabaseFailure(message: 'Failed to fetch movies by genre: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getMoviesByProvider(
      ProviderModel provider) async {
    try {
      final database = await db.database;
      final movies = await database.rawQuery('''
        SELECT * 
        FROM ${MoviDbPaths.movieTable} m
        JOIN ${MoviDbPaths.movieMovieProviderTable} mmp ON m.id = mmp.movie_id
        WHERE mmp.provider_id = ?
      ''', [provider.id]);

      final result =
          await Future.wait(movies.map((movie) => _buildMovieModel(movie)));
      return Right(result);
    } catch (e) {
      return Left(
          DatabaseFailure(message: 'Failed to fetch movies by provider: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> searchMovie(String query) async {
    try {
      final database = await db.database;
      final movies = await database.rawQuery('''
        SELECT * 
        FROM ${MoviDbPaths.movieTable}
        WHERE title LIKE ?
      ''', ['%$query%']);

      final result =
          await Future.wait(movies.map((movie) => _buildMovieModel(movie)));
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to search movies: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getFavoritesUserMovies(
      UserModel user) async {
    try {
      final database = await db.database;
      final favorites = await database.query(MoviDbPaths.userFavoriteMovieTable,
          where: 'user_id = ?', whereArgs: [user.id]);

      List<Map<String, dynamic>> movies = [];
      if(favorites.isNotEmpty) {
        for (var favorite in favorites) {
        final result = await database.query('movie', where: 'id = ?', whereArgs: [favorite['movie_id']]);
        if(result.isNotEmpty){
          movies.add(result.first);
        }
      }
      }

      final result = await Future.wait(
          movies.map((movie) => _buildMovieModel(movie)));
      return Right(result);
    } catch (e) {
      print(e.toString());
      return Left(
          DatabaseFailure(message: 'Failed to fetch favorite movies: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getNowPlayingMovies(
      UserModel user) async {
    try {
      final database = await db.database;
      final nowPlaying = await database.rawQuery('''
        SELECT movie_id
        FROM ${MoviDbPaths.userNowPlayingMovieTable}
        WHERE user_id = ?
        ORDER BY added DESC
      ''', [user.id]);

      final result = await Future.wait(nowPlaying
          .map((movie) => _buildMovieModel({'id': movie['movie_id']})));
      return Right(result);
    } catch (e) {
      return Left(
          DatabaseFailure(message: 'Failed to fetch now playing movies: $e'));
    }
  }

  @override
  Future<Either<Failure, List<MovieGenreModel>>> getMovieGenres() async {
    try {
      final database = await db.database;
      final genres = await database.query(MoviDbPaths.movieGenreTable);
      return Right(
          genres.map((genre) => MovieGenreModel.fromJson(genre)).toList());
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch movie genres: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ProviderModel>>> getMovieProviders() async {
    try {
      final database = await db.database;
      final providers = await database.query(MoviDbPaths.providerTable);
      return Right(providers
          .map((provider) => ProviderModel.fromJson(provider))
          .toList());
    } catch (e) {
      return Left(
          DatabaseFailure(message: 'Failed to fetch movie providers: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateFavoriteMovie(
      MovieModel movie, UserModel user) async {
    try {
      final database = await db.database;

      // Vérifie si le film est déjà dans les favoris
      final result = await database.query(
        'user_favorite_movie',
        where: 'user_id = ? AND movie_id = ?',
        whereArgs: [user.id, movie.id],
      );

      if (result.isEmpty) {
        // Ajoute le film si ce n'est pas un favori
        int newLastUpdated = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        Map<String, dynamic> favoriteMovie = {
          'user_id': user.id,
          'movie_id': movie.id,
          'added': newLastUpdated,
        };
        await database.insert('user_favorite_movie', favoriteMovie);
      } else {
        // Supprime le film si c'est déjà un favori
        await database.delete(
          'user_favorite_movie',
          where: 'user_id = ? AND movie_id = ?',
          whereArgs: [user.id, movie.id],
        );
      }

      return const Right(null);
    } catch (e) {
      return Left(
        DatabaseFailure(
            message: 'Failed to update favorite movie: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> isFavoriteMovie(
      MovieModel movie, UserModel user) async {
    try {
      final database = await db.database;
      final result = await database.query('user_favorite_movie',
          where: 'user_id = ? and movie_id = ?',
          whereArgs: [user.id, movie.id]);
      bool isFavorite = false;
      if (result.isNotEmpty) {
        isFavorite = true;
      }
      return Right(isFavorite);
    } catch (e) {
      return Left(DatabaseFailure(
          message: "Failed to fetch favorite movie : ${e.toString()}"));
    }
  }
}
