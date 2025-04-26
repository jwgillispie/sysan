
// lib/features/social/models/story.dart
class Story {
  final String username;
  final String game;
  final DateTime timestamp;
  final String? imageUrl;
  final String? systemId;

  Story({
    required this.username,
    required this.game,
    required this.timestamp,
    this.imageUrl,
    this.systemId,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      username: json['username'] as String,
      game: json['game'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imageUrl: json['image_url'] as String?,
      systemId: json['system_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'game': game,
      'timestamp': timestamp.toIso8601String(),
      'image_url': imageUrl,
      'system_id': systemId,
    };
  }
}
