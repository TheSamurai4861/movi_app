import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class SearchMovie {
  final MovieRepository repository;

  SearchMovie(this.repository);

  Future<Either<Failure, List<Movie>>> call(String query) {
    return repository.searchMovie(query);
  }
}
