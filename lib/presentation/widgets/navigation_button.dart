import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationButton extends StatelessWidget {
  final String path;
  final String iconPath;
  const NavigationButton(
      {super.key, required this.path, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(path);
      },
      child: Image.asset(
        iconPath,
        height: 40,
        fit: BoxFit.contain,
      ),
    );
  }
}
