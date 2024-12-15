import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class IsFavoriteMovie {
  final MovieRepository repository;

  IsFavoriteMovie(this.repository);

  Future<Either<Failure, bool>> call(Movie movie, User user) {
    return repository.isFavoriteMovie(movie, user);
  }
}
