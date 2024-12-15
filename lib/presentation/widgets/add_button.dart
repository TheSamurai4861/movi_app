import 'package:flutter/material.dart';
import 'package:movi_mobile/core/constants/theme/app_colors.dart';
import 'package:movi_mobile/core/service_locator.dart';
import 'package:movi_mobile/domain/entities/movie.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/movie_repository.dart';
import 'package:movi_mobile/domain/usecases/movie/is_favorite_movie.dart';

class AddButton extends StatefulWidget {
  final double width;
  final dynamic media;
  const AddButton({super.key, required this.width, required this.media});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> isFavoriteMovie() async {
    IsFavoriteMovie isFavoriteMovie = IsFavoriteMovie(sl());
    final result = await isFavoriteMovie(widget.media,
        User(id: 1, name: 'Matt', isAdult: 1, favorites: UserFavorites()));
    widget.media.isFavorite.value =
        result.fold((failure) => false, (isFavorite) => isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        MovieRepository movieRepository = sl();

        // Effectuer les opérations asynchrones
        if (widget.media is Movie) {
          await movieRepository.updateFavoriteMovie(
              widget.media,
              User(
                  id: 1, name: 'Matt', isAdult: 1, favorites: UserFavorites()));
        }

        // Une fois les futures terminées, mettez à jour l'état
        await isFavoriteMovie(); // Attendez que la fonction soit terminée
        setState(() {}); // Appelez setState pour mettre à jour l'UI
      },
      child: Container(
          width: widget.width,
          height: widget.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.width / 2),
              color: AppColors.secondary),
          child: ValueListenableBuilder<bool>(
            valueListenable: widget.media.isFavorite,
            builder: (BuildContext context, bool value, Widget? child) {
              return Center(
                child: Image.asset(
                  widget.media.isFavorite.value
                      ? 'assets/icons/added.png'
                      : 'assets/icons/add.png',
                  height: 30,
                ),
              );
            },
          )),
    );
  }
}
