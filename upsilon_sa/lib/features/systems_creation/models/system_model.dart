// lib/features/analytics/models/system_model.dart

import 'factor_model.dart';

class SystemModel {
  final String id;
  final String name;
  final String sport;
  final List<Factor> factors;
  final DateTime createdAt;
  final double confidence;
  final int gamesBack; // System-wide games back setting

  SystemModel({
    required this.id,
    required this.name,
    required this.sport,
    required this.factors,
    required this.createdAt,
    this.confidence = 0.0,
    this.gamesBack = 10, // Default to 10 games
  });

  SystemModel copyWith({
    String? name,
    String? sport,
    List<Factor>? factors,
    double? confidence,
    int? gamesBack,
  }) {
    return SystemModel(
      id: id,
      name: name ?? this.name,
      sport: sport ?? this.sport,
      factors: factors ?? this.factors,
      createdAt: createdAt,
      confidence: confidence ?? this.confidence,
      gamesBack: gamesBack ?? this.gamesBack,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sport': sport,
      'factors': factors.map((factor) => factor.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'confidence': confidence,
      'gamesBack': gamesBack,
    };
  }

  factory SystemModel.fromJson(Map<String, dynamic> json) {
    return SystemModel(
      id: json['id'],
      name: json['name'],
      sport: json['sport'],
      factors: (json['factors'] as List)
          .map((factorJson) => Factor.fromJson(factorJson))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      confidence: json['confidence'] ?? 0.0,
      gamesBack: json['gamesBack'] ?? 10,
    );
  }
}