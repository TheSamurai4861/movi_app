import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/data/datasources/local/movie_local_datasource.dart';
import 'package:movi_mobile/data/datasources/remote/movie_remote_datasource.dart';
import 'package:movi_mobile/data/models/movie_model.dart';
import 'package:movi_mobile/data/models/provider_model.dart';
import 'package:movi_mobile/data/models/user_model.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/provider.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDatasource localDataSource;

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource
  }) {
    print("MovieRepositoryImpl initialized with remote: $remoteDataSource");
  }

  @override
  Future<Either<Failure, List<Movie>>> getTrendingMovies() async {
    try {
      // Get trending movies from the remote data source
      final result = await remoteDataSource.getTrendingMovies();

      // Using fold to handle both Left (failure) and Right (success)
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieModels) {
          // Assuming movieModels is a List<MovieModel>
          final movies = movieModels.map((model) => model.toEntity()).toList();
          return Right(movies);
        },
      );
    } catch (error) {
      // If an error occurs during the fetch process, handle it
      print("Error in getTrendingMovies: $error");
      return Left(
          NetworkFailure(message: "Failed to fetch trending movies: $error"));
    }
  }

  @override
  Future<Either<Failure, void>> addNewMovie(Movie movie) async {
    try {
      await localDataSource.addNewMovie(MovieModel.fromEntity(movie));
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to add a new movie:  ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getFavoritesUserMovies(User user) async {
    try {
      final result = await localDataSource.getFavoritesUserMovies(UserModel.fromEntity(user));
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieModels) {
          // Assuming movieModels is a List<MovieModel>
          final movies = movieModels.map((model) => model.toEntity()).toList();
          return Right(movies);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch user favorite movies:  ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(
      MovieGenre category) async {
        try {
      final result = await localDataSource.getMoviesByGenre(MovieGenreModel.fromEntity(category));
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieModels) {
          // Assuming movieModels is a List<MovieModel>
          final movies = movieModels.map((model) => model.toEntity()).toList();
          return Right(movies);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch movies by genre:  ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies(User user) async {
    try {
      final result = await localDataSource.getNowPlayingMovies(UserModel.fromEntity(user));
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieModels) {
          // Assuming movieModels is a List<MovieModel>
          final movies = movieModels.map((model) => model.toEntity()).toList();
          return Right(movies);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch user now plahying movies:  ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovie(String query) async {
    try {
      final result = await localDataSource.searchMovie(query);
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieModels) {
          // Assuming movieModels is a List<MovieModel>
          final movies = movieModels.map((model) => model.toEntity()).toList();
          return Right(movies);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to search movies:  ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMostPopularMovies() async {
    try {
      // Get trending movies from the remote data source
      final result = await remoteDataSource.getMostPopularMovies();

      // Using fold to handle both Left (failure) and Right (success)
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieModels) {
          // Assuming movieModels is a List<MovieModel>
          final movies = movieModels.map((model) => model.toEntity()).toList();
          return Right(movies);
        },
      );
    } catch (error) {
      // If an error occurs during the fetch process, handle it
      print("Error in getMostPopularMovies : $error");
      return Left(
          NetworkFailure(message: "Failed to fetch most popular movies: $error"));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getMoviesByProvider(Provider provider) async {
    try {
      final result = await localDataSource.getMoviesByProvider(ProviderModel.fromEntity(provider));
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieModels) {
          // Assuming movieModels is a List<MovieModel>
          final movies = movieModels.map((model) => model.toEntity()).toList();
          return Right(movies);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch movies by provider:  ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, List<MovieGenre>>> getMovieGenres() async {
    try {
      final result = await localDataSource.getMovieGenres();
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieGenreModels) {
          // Assuming movieModels is a List<MovieModel>
          final movieGenres= movieGenreModels.map((model) => model.toEntity()).toList();
          return Right(movieGenres);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch movie genres:  ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Provider>>> getMovieProviders() async {
    try {
      final result = await localDataSource.getMovieProviders();
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieGenreModels) {
          // Assuming movieModels is a List<MovieModel>
          final movieGenres= movieGenreModels.map((model) => model.toEntity()).toList();
          return Right(movieGenres);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch movie providers:  ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateFavoriteMovie(Movie movie, User user) async{
    try {
      final result = await localDataSource.updateFavoriteMovie(MovieModel.fromEntity(movie), UserModel.fromEntity(user));
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (movieGenreModels) {
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to add a favorite movie for user ${user.id} : ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, bool>> isFavoriteMovie(Movie movie, User user) async {
    try {
      final result = await localDataSource.isFavoriteMovie(MovieModel.fromEntity(movie), UserModel.fromEntity(user));
      return result.fold(
        // If there is a failure, return Left
        (failure) => Left(failure),

        // If movieModels is successful, convert each MovieModel to its corresponding Movie entity
        (isFavorite) {
          return Right(isFavorite);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to add a favorite movie for user ${user.id} : ${e.toString()}'));
    }
  }
}
