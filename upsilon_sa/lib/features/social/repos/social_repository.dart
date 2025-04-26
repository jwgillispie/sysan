// lib/features/social/repositories/social_repository.dart
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:upsilon_sa/core/config/constants.dart';
import 'package:upsilon_sa/features/social/models/social_system.dart';
import 'package:upsilon_sa/features/social/models/story.dart';
import 'package:upsilon_sa/features/social/models/friend.dart';

class SocialRepository {
  final String baseUrl = ApiConstants.baseUrl;

  Future<List<SocialSystem>> getFriendsSystems() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      return [
        SocialSystem(
          name: 'Infinite Money Glitch',
          username: '@jozo666',
          winRate: 92.5,
          description: 'Advanced neural network for NBA predictions',
          followers: 1234,
        ),
        SocialSystem(
          name: 'Rapper Money System',
          username: '@bbw',
          winRate: 88.7,
          description: 'MLB specialized prediction system',
          followers: 892,
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch friends systems: $e');
    }
  }

  Future<List<SocialSystem>> getWorldBestSystems() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      return [
        SocialSystem(
          name: 'Master AI',
          username: '@pro_trader',
          winRate: 95.8,
          description: 'World leading sports prediction system',
          followers: 45678,
        ),
        SocialSystem(
          name: 'Upper Echelon',
          username: '@ai_master',
          winRate: 94.3,
          description: 'Advanced deep learning system',
          followers: 32145,
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch world systems: $e');
    }
  }

  Future<List<Story>> getStories() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      return [
        Story(
          username: '@jozo666',
          game: 'NBA',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          systemId: '123',
        ),
        Story(
          username: '@bbw',
          game: 'NFL',
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          systemId: '456',
        ),
      ];
    } catch (e) {
      throw Exception('Failed to fetch stories: $e');
    }
  }

  Future<List<Friend>> searchFriends(String query) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      return [
        Friend(
          username: '@jozo666',
          displayName: 'John Doe',
          systemIds: ['123', '456'],
          isFollowing: true,
        ),
        Friend(
          username: '@bbw',
          displayName: 'Jane Smith',
          systemIds: ['789'],
          isFollowing: false,
        ),
      ];
    } catch (e) {
      throw Exception('Failed to search friends: $e');
    }
  }

  Future<void> followSystem(String systemId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to follow system: $e');
    }
  }

  Future<void> unfollowSystem(String systemId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to unfollow system: $e');
    }
  }

  Future<void> shareSystem(String systemId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to share system: $e');
    }
  }

  Future<void> postStory(String game, String? systemId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to post story: $e');
    }
  }
}
