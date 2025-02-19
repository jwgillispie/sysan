// lib/features/datasets/repos/datasets_repository.dart
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:upsilon_sa/features/datasets/models/player_model.dart';
import 'package:upsilon_sa/features/datasets/models/team_model.dart';
import 'dart:convert';
import 'dart:developer';

class DatasetsRepository {
  final String baseUrl = 'http://localhost:8000';

  Future<List<Player>> fetchPlayers() async {
    try {
      log('Fetching players from $baseUrl/players');
      final response = await http.get(Uri.parse('$baseUrl/players'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log('Successfully fetched ${data.length} players');
        
        return data.map((playerJson) => Player(
          name: playerJson['name'] ?? '',
          age: playerJson['age'] ?? 0,
          experience: playerJson['experience'] ?? 0,
          position: playerJson['position'] ?? '',
        )).toList();
      } else {
        log('Error fetching players: ${response.statusCode}');
        throw Exception('Failed to fetch players: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching players: $e');
      // Optionally provide fallback data during development
      return [
        Player(name: "John Doe", age: 25, experience: 5, position: "Forward"),
        Player(name: "Jane Smith", age: 28, experience: 7, position: "Guard"),
      ];
    }
  }

  Future<List<Team>> fetchTeams() async {
    try {
      log('Fetching teams from $baseUrl/teams');
      final response = await http.get(Uri.parse('$baseUrl/teams'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        log('Successfully fetched ${data.length} teams');

        return data.map((teamJson) => Team(
          name: teamJson['name'] ?? '',
          players: (teamJson['players'] as List? ?? []).map((playerJson) => Player(
            name: playerJson['name'] ?? '',
            age: playerJson['age'] ?? 0,
            experience: playerJson['experience'] ?? 0,
            position: playerJson['position'] ?? '',
          )).toList(),
        )).toList();
      } else {
        log('Error fetching teams: ${response.statusCode}');
        throw Exception('Failed to fetch teams: ${response.statusCode}');
      }
    } catch (e) {
      log('Exception while fetching teams: $e');
      // Return fallback data during development
      return [
        Team(
          name: "Lakers",
          players: [
            Player(name: "John Doe", age: 25, experience: 5, position: "Forward")
          ],
        ),
      ];
    }
  }
}