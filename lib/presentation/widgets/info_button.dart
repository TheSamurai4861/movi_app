import 'package:flutter/material.dart';
import 'package:movi_mobile/core/constants/theme/app_colors.dart';
import 'package:movi_mobile/presentation/screens/media_screen.dart';

class InfoButton extends StatefulWidget {
  final double width;
  final dynamic media;
  const InfoButton({super.key, required this.width, required this.media});

  @override
  State<InfoButton> createState() => _InfoButtonState();
}

class _InfoButtonState extends State<InfoButton> {
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
                  'assets/icons/info.png',
                  height: 25,
                ),
              );
            },
          )),
    );
  }
}
