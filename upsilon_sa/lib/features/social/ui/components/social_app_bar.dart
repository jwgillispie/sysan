// lib/features/social/components/social_app_bar.dart
import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';

class SocialAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SocialAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PulsingDot(),
          const SizedBox(width: 10),
          Text(
            "SOCIAL",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}
