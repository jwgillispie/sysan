import 'package:cloud_firestore/cloud_firestore.dart';

/// Marketplace listing for a system
class MarketplaceSystem {
  final String id;
  final String creatorId;
  final String creatorName;
  final String systemId; // Reference to the actual system
  final String name;
  final String description;
  final double price;
  final String sport; // MLB, NBA, NFL, etc.
  final List<String> tags;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Performance stats
  final SystemStats? stats;

  // Marketplace stats
  final int totalPurchases;
  final double averageRating;
  final int totalReviews;

  MarketplaceSystem({
    required this.id,
    required this.creatorId,
    required this.creatorName,
    required this.systemId,
    required this.name,
    required this.description,
    required this.price,
    required this.sport,
    this.tags = const [],
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.stats,
    this.totalPurchases = 0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
  });

  /// Converts to JSON for FastAPI (snake_case)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'creator_name': creatorName,
      'system_id': systemId,
      'name': name,
      'description': description,
      'price': price,
      'sport': sport,
      'tags': tags,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'stats': stats?.toJson(),
      'total_purchases': totalPurchases,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
    };
  }

  /// Converts to JSON for Firebase (camelCase, Timestamp)
  Map<String, dynamic> toFirebaseJson() {
    return {
      'id': id,
      'creatorId': creatorId,
      'creatorName': creatorName,
      'systemId': systemId,
      'name': name,
      'description': description,
      'price': price,
      'sport': sport,
      'tags': tags,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'stats': stats?.toFirebaseJson(),
      'totalPurchases': totalPurchases,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }

  factory MarketplaceSystem.fromJson(Map<String, dynamic> json, String docId) {
    return MarketplaceSystem(
      id: docId,
      creatorId: json['creator_id'] ?? json['creatorId'] ?? '',
      creatorName: json['creator_name'] ?? json['creatorName'] ?? 'Unknown',
      systemId: json['system_id'] ?? json['systemId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      sport: json['sport'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      isActive: json['is_active'] ?? json['isActive'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      stats: json['stats'] != null ? SystemStats.fromJson(json['stats']) : null,
      totalPurchases: json['total_purchases'] ?? json['totalPurchases'] ?? 0,
      averageRating: (json['average_rating'] ?? json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? json['totalReviews'] ?? 0,
    );
  }

  MarketplaceSystem copyWith({
    String? name,
    String? description,
    double? price,
    String? sport,
    List<String>? tags,
    bool? isActive,
    SystemStats? stats,
    int? totalPurchases,
    double? averageRating,
    int? totalReviews,
  }) {
    return MarketplaceSystem(
      id: id,
      creatorId: creatorId,
      creatorName: creatorName,
      systemId: systemId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      sport: sport ?? this.sport,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      stats: stats ?? this.stats,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
    );
  }
}

/// System performance statistics
class SystemStats {
  final double roi; // Return on investment percentage
  final double winRate; // Win percentage
  final int totalBets;
  final double profitLoss;
  final int wins;
  final int losses;

  SystemStats({
    required this.roi,
    required this.winRate,
    required this.totalBets,
    required this.profitLoss,
    required this.wins,
    required this.losses,
  });

  /// Converts to JSON for FastAPI (snake_case)
  Map<String, dynamic> toJson() {
    return {
      'roi': roi,
      'win_rate': winRate,
      'total_bets': totalBets,
      'profit_loss': profitLoss,
      'wins': wins,
      'losses': losses,
    };
  }

  /// Converts to JSON for Firebase (camelCase)
  Map<String, dynamic> toFirebaseJson() {
    return {
      'roi': roi,
      'winRate': winRate,
      'totalBets': totalBets,
      'profitLoss': profitLoss,
      'wins': wins,
      'losses': losses,
    };
  }

  factory SystemStats.fromJson(Map<String, dynamic> json) {
    return SystemStats(
      roi: (json['roi'] ?? 0).toDouble(),
      winRate: (json['win_rate'] ?? json['winRate'] ?? 0).toDouble(),
      totalBets: json['total_bets'] ?? json['totalBets'] ?? 0,
      profitLoss: (json['profit_loss'] ?? json['profitLoss'] ?? 0).toDouble(),
      wins: json['wins'] ?? 0,
      losses: json['losses'] ?? 0,
    );
  }
}
