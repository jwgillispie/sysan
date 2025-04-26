// Path: lib/features/news/ui/components/video_carousel.dart
import 'package:flutter/material.dart';
import 'video_card.dart';

class VideoCarousel extends StatelessWidget {
  final List<Map<String, String>> videos;
  final Function(Map<String, String>) onVideoTap;

  const VideoCarousel({
    super.key,
    required this.videos,
    required this.onVideoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return VideoCard(
            video: videos[index],
            onTap: () => onVideoTap(videos[index]),
          );
        },
      ),
    );
  }
}