import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/provider.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/domain/repositories/serie_repository.dart';

class GetSeriesByProvider {
  final SerieRepository repository;

  GetSeriesByProvider(this.repository);

  Future<Either<Failure,List<Serie>>> call(Provider provider) {
    return repository.getSeriesByProvider(provider);
  }
}
