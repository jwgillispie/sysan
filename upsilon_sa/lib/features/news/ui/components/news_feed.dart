// Path: lib/features/news/ui/components/news_feed.dart
import 'package:flutter/material.dart';
import 'news_card.dart';

class NewsFeed extends StatelessWidget {
  final List<Map<String, String>> news;
  final Function(String) onNewsTap;

  const NewsFeed({
    super.key,
    required this.news,
    required this.onNewsTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: news.length,
      itemBuilder: (context, index) {
        final item = news[index];
        return NewsCard(
          title: item['title']!,
          description: item['description']!,
          imageUrl: item['imageUrl']!,
          url: item['url']!,
          onTap: () => onNewsTap(item['url']!),
        );
      },
    );
  }
}