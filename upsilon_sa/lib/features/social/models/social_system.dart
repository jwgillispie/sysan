// lib/features/social/models/social_system.dart
class SocialSystem {
  final String name;
  final String username;
  final double winRate;
  final String? description;
  final int followers;

  SocialSystem({
    required this.name,
    required this.username,
    required this.winRate,
    this.description,
    this.followers = 0,
  });

  factory SocialSystem.fromJson(Map<String, dynamic> json) {
    return SocialSystem(
      name: json['name'] as String,
      username: json['username'] as String,
      winRate: json['win_rate'] as double,
      description: json['description'] as String?,
      followers: json['followers'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'win_rate': winRate,
      'description': description,
      'followers': followers,
    };
  }
}