import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/provider.dart';
import 'package:movi_mobile/domain/repositories/serie_repository.dart';

class GetSerieProviders {
  final SerieRepository repository;

  GetSerieProviders(this.repository);

  Future<Either<Failure, List<Provider>>> call() {
    return repository.getSerieProviders();
  }
}
