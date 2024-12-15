import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class GetMovieGenres {
  final MovieRepository repository;

  GetMovieGenres(this.repository);

  Future<Either<Failure, List<MovieGenre>>> call() {
    return repository.getMovieGenres();
  }
}
