import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/usecases/movie/get_favorites_user_movies.dart';

// --- EVENTS ---
abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

// --- STATES ---
abstract class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Movie> favoriteMovies;
  final List<Movie> favoriteSeries;

  FavoriteLoaded({
    required this.favoriteMovies,
    required this.favoriteSeries,
  });

  @override
  List<Object?> get props => [favoriteMovies, favoriteSeries];
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);

  @override
  List<Object?> get props => [message];
}

// --- BLOC ---
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetFavoritesUserMovies getUserFavoriteMovies;

  FavoriteBloc({required this.getUserFavoriteMovies})
      : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());

    try {
      final Either<Failure, List<Movie>> favoriteMoviesResult =
          await getUserFavoriteMovies(User(
        id: 1,
        name: 'Matt',
        isAdult: 1,
        favorites: UserFavorites(),
      ));

      favoriteMoviesResult.fold(
        (failure) => emit(FavoriteError('Failed to load favorites')),
        (movies) {
          // Si vous avez une logique pour séparer films et séries, appliquez-la ici.
          final favoriteMovies =
              movies.toList();
          final favoriteSeries =
              movies.toList();

          emit(FavoriteLoaded(
            favoriteMovies: favoriteMovies,
            favoriteSeries: favoriteSeries,
          ));
        },
      );
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}
