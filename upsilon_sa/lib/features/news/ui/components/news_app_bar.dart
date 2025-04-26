// Path: lib/features/news/ui/components/news_app_bar.dart
import 'package:flutter/material.dart';

class NewsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSearchTap;

  const NewsAppBar({
    super.key,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return AppBar(
      backgroundColor: Colors.black,
      title: Text(
        'NEWS CENTER',
        style: TextStyle(
          color: primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.search, color: primaryColor),
          onPressed: onSearchTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
