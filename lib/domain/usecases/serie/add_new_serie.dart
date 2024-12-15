import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/domain/repositories/serie_repository.dart';

class AddNewSerie {
  final SerieRepository repository;

  AddNewSerie(this.repository);

  Future<Either<Failure, void>> call(Serie movie) {
    return repository.addNewSerie(movie);
  }
}
