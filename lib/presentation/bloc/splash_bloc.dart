import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/provider.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/usecases/movie/get_movie_genres.dart';
import 'package:movi_mobile/domain/usecases/movie/get_movie_providers.dart';
import 'package:movi_mobile/domain/usecases/movie/get_movies_by_category.dart';
import 'package:movi_mobile/domain/usecases/movie/get_movies_by_provider.dart';
import 'package:movi_mobile/domain/usecases/movie/get_trending_movies.dart';
import 'package:movi_mobile/domain/usecases/user/get_users.dart';
import 'package:dartz/dartz.dart';
import 'package:movi_mobile/data/datasources/local/lists.dart';

// Événements
abstract class SplashEvent {}

class LoadAppDataEvent extends SplashEvent {}

// États
abstract class SplashState {}

class SplashInitialState extends SplashState {}

class SplashLoadingState extends SplashState {}

class SplashDataLoadedState extends SplashState {
  final bool hasUsers;
  SplashDataLoadedState({required this.hasUsers});
}

class SplashErrorState extends SplashState {
  final String message;
  SplashErrorState({required this.message});
}

// Bloc
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final GetTrendingMovies getTrendingMovies;
  final GetMovieGenres getMovieGenres;
  final GetMovieProviders getMovieProviders;
  final GetMoviesByCategory getMoviesByCategory;
  final GetMoviesByProvider getMoviesByProvider;
  final GetUsers getUsers;

  SplashBloc({
    required this.getTrendingMovies,
    required this.getMovieGenres,
    required this.getMovieProviders,
    required this.getMoviesByCategory,
    required this.getMoviesByProvider,
    required this.getUsers,
  }) : super(SplashInitialState()) {
    on<LoadAppDataEvent>(_loadAppData);
  }

  Future<void> _loadAppData(
      LoadAppDataEvent event, Emitter<SplashState> emit) async {
    emit(SplashLoadingState());

    try {
      // 1. Vérifier s'il y a des utilisateurs dans l'application
      final Either<Failure, List<User>> usersResult = await getUsers();
      final bool hasUsers = usersResult.fold(
        (failure) {
          print("Erreur lors de la récupération des utilisateurs: $failure");
          return false; // Considérer qu'il n'y a pas d'utilisateurs en cas d'erreur
        },
        (users) => users.isNotEmpty,
      );

      // 2. Charger les films tendances
      // print("Chargement des films tendances...");
      // Either<Failure, List<Movie>> trendingMoviesResult =
      //     await getTrendingMovies();
      // MovieLists.trendingMovies = trendingMoviesResult.fold(
      //   (failure) {
      //     print("Erreur : $failure");
      //     return [];
      //   },
      //   (movies) => movies,
      // );

      // 3. Charger les genres de films
      print("Chargement des genres de films...");
      Either<Failure, List<MovieGenre>> genresResult = await getMovieGenres();
      List<MovieGenre> genres = genresResult.fold(
        (failure) {
          print("Erreur : $failure");
          return [];
        },
        (genres) => genres,
      );

      // 4. Charger les films par genre
      MovieLists.actionMovies = await _getMoviesByGenre(genres, 'Action');
      MovieLists.sciFiMovies = await _getMoviesByGenre(genres, 'Science-Fiction');
      MovieLists.comedyMovies = await _getMoviesByGenre(genres, 'Comédie');

      // 5. Charger les films Netflix via le provider
      MovieLists.netflixMovies = await _getMoviesFromProvider('Netflix');

      // 6. Émettre l'état final avec la présence ou non d'utilisateurs
      emit(SplashDataLoadedState(hasUsers: hasUsers));
    } catch (e) {
      print("Erreur lors du chargement des données : $e");
      emit(SplashErrorState(message: "Erreur lors du chargement des données"));
    }
  }

  Future<List<Movie>> _getMoviesByGenre(
      List<MovieGenre> genres, String genreName) async {
    MovieGenre? genre = genres.firstWhere(
      (g) => g.title == genreName,
      orElse: () => MovieGenre(id: -1, title: ''),
    );

    if (genre.id != -1) {
      final result = await getMoviesByCategory(genre);
      return result.fold(
        (failure) => [],
        (movies) => movies,
      );
    }
    return [];
  }

  Future<List<Movie>> _getMoviesFromProvider(String providerName) async {
    final providersResult = await getMovieProviders();
    final providers = providersResult.fold(
      (failure) => [],
      (providers) => providers,
    );

    final provider = providers.firstWhere(
      (p) => p.title == providerName,
      orElse: () => Provider(id: -1, title: '', logoPath: ''),
    );

    if (provider.id != -1) {
      final result = await getMoviesByProvider(provider);
      return result.fold(
        (failure) => [],
        (movies) => movies,
      );
    }
    return [];
  }
}
