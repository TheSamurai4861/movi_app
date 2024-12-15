import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/domain/repositories/serie_repository.dart';

class GetMostPopularSeries {
  final SerieRepository repository;

  GetMostPopularSeries(this.repository);

  Future<Either<Failure,List<Serie>>> call() {
    return repository.getMostPopularSeries();
  }
}
