import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi_mobile/core/service_locator.dart';
import 'package:movi_mobile/domain/usecases/movie/get_favorites_user_movies.dart';
import 'package:movi_mobile/presentation/bloc/favorite_bloc.dart';
import 'package:movi_mobile/presentation/widgets/bottom_bar.dart';
import 'package:movi_mobile/presentation/widgets/medias_list.dart';
import 'package:movi_mobile/presentation/widgets/top_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FavoriteBloc(
        getUserFavoriteMovies: sl<GetFavoritesUserMovies>(),
      )..add(LoadFavorites()),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: const TopBar(opacity: 0), // Remplacez 0 par une valeur dynamique si nécessaire
        body: BlocBuilder<FavoriteBloc, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriteLoaded) {
              return CustomScrollView(
                scrollDirection: Axis.vertical,
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(
                      height: 120,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: MediasList(
                      medias: state.favoriteMovies,
                      title: 'Films favoris',
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: MediasList(
                      medias: state.favoriteSeries,
                      title: 'Séries favorites',
                    ),
                  ),
                ],
              );
            } else if (state is FavoriteError) {
              return Center(
                child: Text(state.message),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}
