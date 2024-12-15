import 'package:flutter/material.dart';
import 'package:movi_mobile/core/constants/theme/app_colors.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final double opacity;
  final double height;

  const TopBar({super.key, required this.opacity, this.height = 120.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(opacity),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => _showOverlay(context),
              child: Image.asset(
                'assets/icons/sources.png',
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              "Movi",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                'assets/icons/settings.png',
                height: 35,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(195, 190, 190, 190),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Sélectionner le fournisseur",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GridView.builder(
                        controller: scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          return buildGridItem(
                            context,
                            screenSize,
                            'https://taplink.st/a/c/5/5/8/922a4e.png?2',
                            'Movie Box Pro',
                            'https://em-content.zobj.net/source/apple/391/flag-united-states_1f1fa-1f1f8.png',
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildGridItem(
    BuildContext context,
    Size screenSize,
    String imageUrl,
    String title,
    String flagUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenSize.width / 8,
            width: screenSize.width / 8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(flagUrl),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
