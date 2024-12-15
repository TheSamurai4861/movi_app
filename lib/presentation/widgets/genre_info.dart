import 'package:flutter/material.dart';
import 'package:movi_mobile/core/constants/theme/app_colors.dart';

class GenreInfo extends StatelessWidget {
  final String genreName;
  const GenreInfo({super.key, required this.genreName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary)),
      child: Center(
        child: Text(
          genreName,
          style: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
