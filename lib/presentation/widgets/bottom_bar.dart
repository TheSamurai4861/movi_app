import 'package:flutter/material.dart';
import 'package:movi_mobile/core/constants/theme/app_colors.dart';
import 'package:movi_mobile/presentation/widgets/navigation_button.dart';
import 'package:movi_mobile/presentation/screens/search_screen.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  void _showSearchOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 1.0,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 24, 24, 24),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: SearchModalContent(scrollController: scrollController),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 95,
      decoration: BoxDecoration(color: AppColors.background.withOpacity(0.9)),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const NavigationButton(
                path: '/movies', iconPath: 'assets/icons/movie.png'),
            const SizedBox(width: 35),
            const NavigationButton(
                path: '/tvs', iconPath: 'assets/icons/tv.png'),
            const SizedBox(width: 35),
            const NavigationButton(
                path: '/home', iconPath: 'assets/icons/home.png'),
            const SizedBox(width: 35),
            GestureDetector(
              onTap: () => _showSearchOverlay(context),
              child: Image.asset(
                'assets/icons/search.png',
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 35),
            const NavigationButton(
                path: '/fav', iconPath: 'assets/icons/star.png'),
          ],
        ),
      ),
    );
  }
}
