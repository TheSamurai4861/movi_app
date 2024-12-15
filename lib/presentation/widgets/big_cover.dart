import 'package:flutter/material.dart';
import 'package:movi_mobile/core/constants/theme/app_colors.dart';
import 'package:movi_mobile/domain/entities/serie.dart';
import 'package:movi_mobile/presentation/widgets/info_button.dart';
import 'package:movi_mobile/presentation/widgets/play_button.dart';
import 'package:refreshable_widget/refreshable_widget.dart';

class BigCover extends StatefulWidget {
  final List<dynamic> medias;
  const BigCover({super.key, required this.medias});

  @override
  State<BigCover> createState() => _BigCoverState();
}

class _BigCoverState extends State<BigCover> {
  int incr = 0;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    int mediasListLength = widget.medias.length;

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height / 1.8,
      child: RefreshableWidget(
        builder: (context, value) {
          dynamic media = widget.medias[incr];
          return Stack(
            alignment: Alignment.bottomLeft,
            children: [
              AnimatedOpacity(
                opacity: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Image.network(
                  'https://www.themoviedb.org/t/p/original' + media.coverPath,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  width: screenSize.width,
                ),
              ),
              Container(
                color: const Color.fromARGB(59, 0, 0, 0),
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  AppColors.background,
                  AppColors.background.withOpacity(0.0)
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              ),
              Container(
                height: 150,
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      media.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      media is Serie
                          ? '${media.year} • ${media.seasons.length} saisons'
                          : '${media.year} • ${media.duration}',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        PlayButton(width: screenSize.width / 1.35, height: 45, media: media,),
                        const SizedBox(
                          width: 10,
                        ),
                        InfoButton(
                          width: 45,
                          media: media,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          );
        },
        initialValue: incr,
        refreshCall: () async {
          // Commencer par rendre l'image invisible
          setState(() {
            isVisible = false;
          });

          // Attendre que l'animation d'opacité à 0.0 soit terminée
          await Future.delayed(const Duration(milliseconds: 500));

          // Mettre à jour l'image et la rendre visible
          setState(() {
            incr = (incr + 1) % mediasListLength;
            isVisible = true;
          });

          return incr;
        },
        refreshRate: const Duration(seconds: 7),
      ),
    );
  }
}
