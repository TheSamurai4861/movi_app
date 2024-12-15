import 'package:go_router/go_router.dart';
import 'package:movi_mobile/presentation/exports/screens.dart';

import '../../domain/entities/player.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: '/home',
    builder: (context, state) {
      return const HomeScreen();
    },
  ),
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/player',
    builder: (context, state) {
      final args = state.extra as PlayerRouteArguments;

      return PlayerScreen(
        media: args.media,
        season: args.season,
        episode: args.episode,
      );
    },
  ),
  GoRoute(
    path: '/movies',
    builder: (context, state) => const MoviesScreen(),
  ),
  GoRoute(
    path: '/tvs',
    builder: (context, state) => const SeriesScreen(),
  ),
  GoRoute(
    path: '/fav',
    builder: (context, state) => const FavoritesScreen(),
  ),
  GoRoute(
    path: '/profiles_screen',
    builder: (context, state) => const FavoritesScreen(),
  ),
  GoRoute(
    path: '/add_user_screen',
    builder: (context, state) => const FavoritesScreen(),
  ),
]);
