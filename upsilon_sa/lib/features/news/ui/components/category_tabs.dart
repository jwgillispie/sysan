// Path: lib/features/news/ui/components/category_tabs.dart
import 'package:flutter/material.dart';

class CategoryTabs extends StatelessWidget implements PreferredSizeWidget {
  final TabController tabController;
  final List<String> categories;

  const CategoryTabs({
    super.key,
    required this.tabController,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: tabController,
      isScrollable: true,
      tabs: categories.map((category) {
        return Tab(
          child: Text(
            category,
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
      indicatorColor: Theme.of(context).colorScheme.primary,
      indicatorWeight: 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}