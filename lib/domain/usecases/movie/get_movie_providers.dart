import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/provider.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class GetMovieProviders {
  final MovieRepository repository;

  GetMovieProviders(this.repository);

  Future<Either<Failure, List<Provider>>> call() {
    return repository.getMovieProviders();
  }
}
