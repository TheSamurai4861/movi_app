import 'package:dartz/dartz.dart';
import 'package:movi_mobile/domain/entities/provider.dart';
import '../entities/movie.dart';
import '../entities/user.dart';
import '../../core/error/failures.dart';

abstract class MovieRepository {
  Future<Either<Failure, List<Movie>>> getTrendingMovies();
  Future<Either<Failure, List<Movie>>> getMostPopularMovies();
  Future<Either<Failure, List<Movie>>> getMoviesByGenre(MovieGenre genre);
  Future<Either<Failure, List<Movie>>> getMoviesByProvider(Provider provider);
  Future<Either<Failure, List<Movie>>> searchMovie(String query);
  Future<Either<Failure, List<Movie>>> getFavoritesUserMovies(User user);
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies(User user);
  Future<Either<Failure, void>> addNewMovie(Movie movie);
  Future<Either<Failure, void>> updateFavoriteMovie(Movie movie, User user);
  Future<Either<Failure, List<MovieGenre>>> getMovieGenres();
  Future<Either<Failure, List<Provider>>> getMovieProviders();
  Future<Either<Failure, bool>> isFavoriteMovie(Movie movie, User user);
}
