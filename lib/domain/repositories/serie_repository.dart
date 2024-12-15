import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/provider.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/domain/entities/user.dart';

abstract class SerieRepository {
  Future<Either<Failure, List<Serie>>> getTrendingSeries();
  Future<Either<Failure, List<Serie>>> getMostPopularSeries();
  Future<Either<Failure, List<Serie>>> getSeriesByGenre(SerieGenre genre);
  Future<Either<Failure, List<Serie>>> getSeriesByProvider(Provider provider);
  Future<Either<Failure, List<Serie>>> searchSerie(String query);
  Future<Either<Failure, List<Serie>>> getFavoritesUserSeries(User user);
  Future<Either<Failure, List<Serie>>> getNowPlayingSeries(User user);
  Future<Either<Failure, void>> addNewSerie(Serie serie);
  Future<Either<Failure, List<SerieGenre>>> getSerieGenres();
  Future<Either<Failure, List<Provider>>> getSerieProviders();
}
