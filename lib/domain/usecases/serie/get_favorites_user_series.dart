import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/serie_repository.dart';

class GetFavoritesUserSeries {
  final SerieRepository repository;

  GetFavoritesUserSeries(this.repository);

  Future<Either<Failure,List<Serie>>> call(User user) {
    return repository.getFavoritesUserSeries(user);
  }
}