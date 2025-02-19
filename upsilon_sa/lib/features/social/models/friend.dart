// lib/features/social/models/friend.dart
class Friend {
  final String username;
  final String displayName;
  final String? avatarUrl;
  final List<String> systemIds;
  final bool isFollowing;

  Friend({
    required this.username,
    required this.displayName,
    this.avatarUrl,
    this.systemIds = const [],
    this.isFollowing = false,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      username: json['username'] as String,
      displayName: json['display_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      systemIds: List<String>.from(json['system_ids'] ?? []),
      isFollowing: json['is_following'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'system_ids': systemIds,
      'is_following': isFollowing,
    };
  }
}