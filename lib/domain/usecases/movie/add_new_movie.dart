import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class AddNewMovie {
  final MovieRepository repository;

  AddNewMovie(this.repository);

  Future<Either<Failure, void>> call(Movie movie) {
    return repository.addNewMovie(movie);
  }
}
