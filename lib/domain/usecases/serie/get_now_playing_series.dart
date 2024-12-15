import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/serie_repository.dart';

class GetNowPlayingSeries {
  final SerieRepository repository;

  GetNowPlayingSeries(this.repository);

  Future<Either<Failure,List<Serie>>> call(User user) {
    return repository.getNowPlayingSeries(user);
  }
}
