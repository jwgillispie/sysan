// lib/features/analytics/repository/systems_creation_repository.dart

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/system_model.dart';
import '../models/factor_model.dart';

class SystemsCreationRepository {
  static const String _systemsKey = 'systems';
  final Uuid _uuid = const Uuid();

  // Create a new system
  Future<SystemModel> createSystem({
    required String name,
    required String sport,
    required List<Factor> factors,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Create the new system
    final system = SystemModel(
      id: _uuid.v4(),
      name: name,
      sport: sport,
      factors: factors,
      createdAt: DateTime.now(),
      confidence: _calculateConfidence(factors),
    );
    
    // Get existing systems
    List<SystemModel> systems = await getSystems();
    systems.add(system);
    
    // Save to SharedPreferences
    await prefs.setString(
      _systemsKey,
      jsonEncode(systems.map((s) => s.toJson()).toList()),
    );
    
    return system;
  }

  // Get all systems
  Future<List<SystemModel>> getSystems() async {
    final prefs = await SharedPreferences.getInstance();
    final String? systemsJson = prefs.getString(_systemsKey);
    
    if (systemsJson == null) {
      return [];
    }
    
    final List<dynamic> systemsList = jsonDecode(systemsJson);
    return systemsList
        .map((systemJson) => SystemModel.fromJson(systemJson))
        .toList();
  }
  
  // Delete a system
  Future<void> deleteSystem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<SystemModel> systems = await getSystems();
    
    systems.removeWhere((system) => system.id == id);
    
    await prefs.setString(
      _systemsKey,
      jsonEncode(systems.map((s) => s.toJson()).toList()),
    );
  }
  
  // Calculate system confidence
  double _calculateConfidence(List<Factor> factors) {
    if (factors.isEmpty) {
      return 0.0;
    }
    
    // Simple algorithm: average of all factor weights
    double total = factors.fold(0.0, (sum, factor) => sum + factor.weight);
    return total / factors.length;
  }
}