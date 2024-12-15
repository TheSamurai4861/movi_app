import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class UpdateFavoriteMovie {
  final MovieRepository repository;

  UpdateFavoriteMovie(this.repository);

  Future<Either<Failure, void>> call(Movie movie, User user) {
    return repository.updateFavoriteMovie(movie, user);
  }
}
