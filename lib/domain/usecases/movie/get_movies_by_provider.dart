import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/provider.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';

class GetMoviesByProvider {
  final MovieRepository repository;

  GetMoviesByProvider(this.repository);

  Future<Either<Failure, List<Movie>>> call(Provider provider) {
    return repository.getMoviesByProvider(provider);
  }
}
