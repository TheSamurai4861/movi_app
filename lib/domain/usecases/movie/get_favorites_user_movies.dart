import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class GetFavoritesUserMovies {
  final MovieRepository repository;

  GetFavoritesUserMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call(User user) {
    return repository.getFavoritesUserMovies(user);
  }
}
