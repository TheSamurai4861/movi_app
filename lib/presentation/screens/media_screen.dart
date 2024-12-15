import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:movi_mobile/core/constants/theme/app_colors.dart';
import 'package:movi_mobile/data/datasources/local/lists.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/presentation/widgets/add_button.dart';
import 'package:movi_mobile/presentation/widgets/genre_info.dart';
import 'package:movi_mobile/presentation/widgets/medias_list.dart';
import 'package:movi_mobile/presentation/widgets/play_button.dart';

class MediaDetailModal extends StatefulWidget {
  final dynamic media;
  final ScrollController scrollController;

  const MediaDetailModal({
    super.key,
    required this.media,
    required this.scrollController,
  });

  @override
  State<MediaDetailModal> createState() => _MediaDetailModalState();
}

class _MediaDetailModalState extends State<MediaDetailModal> {
  int selectedSeasonIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // Barre draggable
          Container(
            width: 80,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Expanded(
            child: CustomScrollView(
              controller: widget.scrollController,
              slivers: [
                // Image en arrière-plan
                SliverToBoxAdapter(
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://www.themoviedb.org/t/p/original' +
                                    widget.media.backdropPath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height / 3,
                        color: const Color.fromARGB(73, 0, 0, 0),
                      ),
                      Positioned(
                        bottom: 80,
                        left: 20,
                        child: Text(
                          widget.media.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: 20,
                        child: Text(
                          widget.media is Serie
                              ? '${widget.media.year} • ${widget.media.seasons.length} saisons'
                              : '${widget.media.year} • ${widget.media.duration}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children:
                              widget.media.categories.map<Widget>((category) {
                            return GenreInfo(genreName: category.title);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PlayButton(
                              width: screenSize.width / 1.4,
                              height: 45,
                              media: widget.media,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            AddButton(
                              width: 45,
                              media: widget.media,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.media.synopsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                // Boutons des saisons ou MediasList
                if (widget.media is Serie)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.media.numberOfSeasons,
                          itemBuilder: (context, index) {
                            final isSelected = selectedSeasonIndex == index;
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSeasonIndex = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Saison ${index + 1}',
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey,
                                        fontSize: 18,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 3,
                                      width: 90,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                if (widget.media is Serie)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final episode = widget
                            .media
                            .seasons[selectedSeasonIndex]
                            .episodes[index]; // Exemple d'accès aux épisodes
                        return GestureDetector(
                          onTap: () => context.push('/player', extra: [
                            widget.media,
                            selectedSeasonIndex + 1,
                            index + 1
                          ]),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    episode.image,
                                    width: 150,
                                    height: 84,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        episode.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${episode.duration}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        episode.description,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: widget
                          .media.seasons[selectedSeasonIndex].episodes.length,
                    ),
                  ),
                if (widget.media is! Serie)
                  SliverToBoxAdapter(
                    child: MediasList(
                      medias: MovieLists.actionMovies,
                      title: 'Recommandations',
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
