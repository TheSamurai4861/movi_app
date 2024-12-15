import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class GetMostPopularMovies {
  final MovieRepository repository;

  GetMostPopularMovies(this.repository);

  Future<Either<Failure, List<Movie>>> call() {
    return repository.getMostPopularMovies();
  }
}
