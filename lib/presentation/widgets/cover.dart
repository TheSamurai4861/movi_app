import 'package:flutter/material.dart';
import 'package:movi_mobile/presentation/screens/media_screen.dart';

class Cover extends StatefulWidget {
  final dynamic media;

  const Cover({super.key, required this.media});

  @override
  State<Cover> createState() => _CoverState();
}

class _CoverState extends State<Cover> {
  void _showMediaDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.90,
          minChildSize: 0.6,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return MediaDetailModal(
              media: widget.media,
              scrollController: scrollController,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMediaDetails(context),
      child: Container(
        height: 200,
        width: 133,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://www.themoviedb.org/t/p/original' + widget.media.coverWithTextPath),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              right: 15,
              top: -2,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.media.isFavorite.value =
                        !widget.media.isFavorite.value;
                  });
                },
                child: ValueListenableBuilder<bool>(
                  valueListenable: widget.media.isFavorite,
                  builder: (context, isFavorite, child) {
                    return Image.asset(
                      isFavorite
                          ? 'assets/icons/bookmarked.png'
                          : 'assets/icons/bookmark.png',
                      height: 35,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
