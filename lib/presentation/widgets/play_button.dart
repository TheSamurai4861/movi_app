import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movi_mobile/core/constants/theme/app_colors.dart';
import 'package:movi_mobile/domain/entities/player.dart';

class PlayButton extends StatelessWidget {
  final double width;
  final double height;
  final dynamic media;
  final int? season;
  final int? episode;

  const PlayButton({
    super.key,
    required this.width,
    required this.height,
    required this.media,
    this.season,
    this.episode
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(season != null && episode != null) {
          context.push(
          '/player',
          extra: PlayerRouteArguments(media: media, season: season, episode: episode),
        );  
        } else {
          context.push(
          '/player',
          extra: PlayerRouteArguments(media: media),
        );
        }
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width / 2),
          color: AppColors.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/play.png',
              height: 25,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 20),
            const Text(
              'Regarder',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
