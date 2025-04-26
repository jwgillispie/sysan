// Path: lib/features/home/ui/components/home_app_bar.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(0.7),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PulsingDot(),
          const SizedBox(width: 8),
          Text(
            'SYSTEMS HOME',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
      centerTitle: true,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}