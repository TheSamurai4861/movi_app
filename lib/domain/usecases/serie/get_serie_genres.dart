import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/domain/repositories/serie_repository.dart';

class GetSerieGenres {
  final SerieRepository repository;

  GetSerieGenres(this.repository);

  Future<Either<Failure, List<SerieGenre>>> call() {
    return repository.getSerieGenres();
  }
}
