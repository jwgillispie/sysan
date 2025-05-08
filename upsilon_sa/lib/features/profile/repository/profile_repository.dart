// lib/features/profile/repository/profile_repository.dart

import 'dart:async';
import 'package:upsilon_sa/core/config/constants.dart';

class ProfileRepository {
  final String baseUrl = ApiConstants.baseUrl;

  Future<Map<String, dynamic>> getProfile() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      return {
        'username': '@your_mom',
        'displayName': 'Your mom',
        'role': 'Analyst',
        'joinDate': '2024-01-15',
        'activeSystems': 3,
        'totalFollowers': 1234,
        'avgWinRate': 92.5,
        'status': 'active',
      };
    } catch (e) {
      throw Exception('Failed to fetch profile: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getProfileSystems() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      return [
        {
          'name': 'LeBron Picks',
          'winRate': 92.5,
          'status': 'active',
          'followers': 523,
        },
        {
          'name': 'Underdog Special',
          'winRate': 88.7,
          'status': 'active',
          'followers': 342,
        },
        {
          'name': 'Home Team Edge',
          'winRate': 85.3,
          'status': 'active',
          'followers': 278,
        },
      ];
    } catch (e) {
      throw Exception('Failed to fetch systems: $e');
    }
  }

  Future<Map<String, dynamic>> getProfileStats() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      return {
        'totalBets': 1234,
        'winRate': 92.5,
        'profitability': 27.8,
        'averageOdds': 1.95,
        'roiData': [
          {'x': 0, 'y': 65},
          {'x': 1, 'y': 72},
          {'x': 2, 'y': 85},
          {'x': 3, 'y': 78},
          {'x': 4, 'y': 92},
          {'x': 5, 'y': 88},
        ],
        'recentActivity': [
          {
            'type': 'bet',
            'description': 'Won bet on LAL vs GSW',
            'time': '2h ago',
            'result': 'win',
          },
          {
            'type': 'system',
            'description': 'Created new system "3-Point Kings"',
            'time': '5h ago',
            'result': null,
          },
          {
            'type': 'bet',
            'description': 'Bet placed on KC vs BAL',
            'time': '1d ago',
            'result': 'pending',
          },
          {
            'type': 'system',
            'description': 'Updated "First Half Heroes" system',
            'time': '2d ago',
            'result': null,
          },
        ],
      };
    } catch (e) {
      throw Exception('Failed to fetch stats: $e');
    }
  }

  Future<Map<String, dynamic>> getSubscription() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      return {
        'currentPlan': 'Pro',
        'startDate': '2024-01-15',
        'expiryDate': '2025-01-15',
        'autoRenew': true,
        'paymentMethod': 'Credit Card (**** 1234)',
      };
    } catch (e) {
      throw Exception('Failed to fetch subscription: $e');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> userData) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> updateSubscription(String planName) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      // In a real application, you would send the new plan name to the server
    } catch (e) {
      throw Exception('Failed to update subscription: $e');
    }
  }

  Future<void> cancelSubscription() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      // In a real application, you would send a cancellation request to the server
    } catch (e) {
      throw Exception('Failed to cancel subscription: $e');
    }
  }
}