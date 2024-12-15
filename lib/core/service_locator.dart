import 'package:get_it/get_it.dart';
import 'package:movi_mobile/data/datasources/local/local_database.dart';
import 'package:movi_mobile/data/datasources/local/movie_local_datasource.dart';
import 'package:movi_mobile/data/datasources/local/user_local_datasource.dart';
import 'package:movi_mobile/data/datasources/remote/movie_remote_datasource.dart';
import 'package:movi_mobile/data/repositories/movie_repository_impl.dart';
import 'package:movi_mobile/data/repositories/user_repository_impl.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';
import 'package:movi_mobile/domain/repositories/user_repository.dart';
import 'package:movi_mobile/domain/usecases/movie/get_favorites_user_movies.dart';
import 'package:movi_mobile/domain/usecases/movie/get_movie_genres.dart';
import 'package:movi_mobile/domain/usecases/movie/get_movie_providers.dart';
import 'package:movi_mobile/domain/usecases/movie/get_movies_by_category.dart';
import 'package:movi_mobile/domain/usecases/movie/get_movies_by_provider.dart';
import 'package:movi_mobile/domain/usecases/movie/get_trending_movies.dart';
import 'package:movi_mobile/domain/usecases/user/get_users.dart';
import 'package:movi_mobile/presentation/bloc/splash_bloc.dart';

final sl = GetIt.instance;

Future<void> initializeApp() async {
  print("Initializing application...");

  // Étape 1 : Initialiser la base de données
  final localDatabase = LocalDatabase();
  await localDatabase.database;
  sl.registerLazySingleton<LocalDatabase>(() => localDatabase);
  print("Database initialized and registered.");

  // Étape 2 : Enregistrer d'autres services si nécessaire
  // sl.registerLazySingleton<OtherService>(() => OtherService());

  print("Application initialized successfully.");
}

Future<void> init() async {
  print("Starting dependency injection initialization...");

  try {

    // Data Sources
    print("Registering UserLocalDataSource...");
    sl.registerLazySingleton<UserLocalDataSource>(
        () => UserLocalDataSourceImpl(sl<LocalDatabase>()));
    print("UserLocalDataSource registered successfully.");

    print("Registering MovieLocalDatasource...");
    sl.registerLazySingleton<MovieLocalDatasource>(
        () => MovieLocalDatasourceImpl(sl<LocalDatabase>()));
    print("MovieLocalDatasource registered successfully.");

    print("Registering MovieRemoteDataSource...");
    sl.registerLazySingleton<MovieRemoteDataSource>(
        () => MovieRemoteDataSourceImpl());
    print("MovieRemoteDataSource registered successfully.");

    // Repositories
    print("Registering MovieRepository...");
    sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
          remoteDataSource: sl(),
          localDataSource: sl(),
        ));
    print("MovieRepository registered successfully.");

    print("Registering UserRepository...");
    sl.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(userLocalDataSource: sl()));
    print("UserRepository registered successfully.");

    // Usecases
    print("Registering GetTrendingMovies...");
    sl.registerLazySingleton(() => GetTrendingMovies(sl<MovieRepository>()));
    print("GetTrendingMovies registered successfully.");

    print("Registering GetFavoritesUserMovies...");
    sl.registerLazySingleton(() => GetFavoritesUserMovies(sl<MovieRepository>()));
    print("GetFavoritesUserMovies registered successfully.");

    print("Registering GetMovieGenres...");
    sl.registerLazySingleton(() => GetMovieGenres(sl<MovieRepository>()));
    print("GetMovieGenres registered successfully.");

    print("Registering GetMoviesByCategory...");
    sl.registerLazySingleton(() => GetMoviesByCategory(sl<MovieRepository>()));
    print("GetMoviesByCategory registered successfully.");

    print("Registering GetMoviesByProvider...");
    sl.registerLazySingleton(() => GetMoviesByProvider(sl<MovieRepository>()));
    print("GetMoviesByProvider registered successfully.");

    print("Registering GetMovieProviders...");
    sl.registerLazySingleton(() => GetMovieProviders(sl<MovieRepository>()));
    print("GetMovieProviders registered successfully.");

    print("Registering GetUsers...");
    sl.registerLazySingleton(() => GetUsers(sl<UserRepository>()));
    print("GetUsers registered successfully.");

    // Blocs
    print("Registering SplashBloc...");
    sl.registerFactory(() {
      return SplashBloc(
        getTrendingMovies: sl<GetTrendingMovies>(),
        getMovieGenres: sl<GetMovieGenres>(),
        getMoviesByCategory: sl<GetMoviesByCategory>(),
        getMoviesByProvider: sl<GetMoviesByProvider>(), getMovieProviders: sl<GetMovieProviders>(), getUsers: sl<GetUsers>(),
      );
    });
    print("SplashBloc registered successfully.");

    print("Dependency injection initialization completed successfully.");
  } catch (e, stacktrace) {
    print("Error during dependency injection initialization: $e");
    print("Stacktrace: $stacktrace");
    rethrow; // Rejette l'exception pour aider au débogage.
  }
}
