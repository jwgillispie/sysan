// lib/features/social/components/social_search_bar.dart

import 'package:flutter/material.dart';

class SocialSearchBar extends StatelessWidget {
  const SocialSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search friends...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}