import 'package:flutter/material.dart';
import 'package:movi_mobile/data/datasources/local/lists.dart';

import 'package:movi_mobile/presentation/widgets/big_cover.dart';
import 'package:movi_mobile/presentation/widgets/bottom_bar.dart';
import 'package:movi_mobile/presentation/widgets/medias_list.dart';
import 'package:movi_mobile/presentation/widgets/top_bar.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final ScrollController _scrollController = ScrollController();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    double triggerHeight = MediaQuery.of(context).size.height / 3;
    setState(() {
      _opacity = (_scrollController.offset / triggerHeight).clamp(0.0, 0.85);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: TopBar(
        opacity: _opacity,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(
            child: BigCover(medias: MovieLists.actionMovies),
          ),
          SliverToBoxAdapter(
            child: MediasList(
              medias: MovieLists.comedyMovies,
              title: 'Comédie',
            ),
          ),
          SliverToBoxAdapter(
            child: MediasList(
              medias: MovieLists.netflixMovies,
              title: 'Sur Netflix',
            ),
          ),
          SliverToBoxAdapter(
            child: MediasList(
              medias: MovieLists.sciFiMovies,
              title: 'Science-Fiction',
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
