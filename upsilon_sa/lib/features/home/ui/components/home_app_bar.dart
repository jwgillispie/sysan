// Path: lib/features/home/ui/components/home_app_bar.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/widgets/ui_components.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.black.withOpacity(0.7),
      expandedHeight: 100,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
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
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.8),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}