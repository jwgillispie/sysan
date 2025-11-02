// lib/features/home/repos/hot_props_repository.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:upsilon_sa/core/utils/helpers.dart';
import 'package:upsilon_sa/core/widgets/hot_props_widget.dart';

// Import reference to our global environment variables
import 'package:upsilon_sa/main.dart' show environmentVariables;

class HotPropsRepository {
  // Base URL for The Odds API
  final String _baseUrl = 'https://api.the-odds-api.com/v4';

  // Get API key from environment variables
  String get apiKey {
    // First check if we have it in the global map (for web)
    final webApiKey = environmentVariables['ODDS_API_KEY'];
    if (webApiKey != null && webApiKey.isNotEmpty) {
      return webApiKey;
    }

    // Then try the environment helper (for mobile)
    return EnvironmentHelper.getEnvironmentValue('ODDS_API_KEY');
  }

  /// Fetches hot props from the Odds API
  Future<List<HotProp>> getHotProps() async {
    try {
      if (apiKey.isEmpty || apiKey == 'YOUR_ODDS_API_KEY') {
        // No valid Odds API key found, using mock data for hot props
        return _getMockHotProps();
      }

      // Step 1: Get some upcoming events for NBA basketball
      final events = await _getUpcomingEvents('basketball_nba');
      if (events.isEmpty) {
        // No events found, using mock data
        return _getMockHotProps();
      }

      // Step 2: For the first few events, get player props
      final List<HotProp> allProps = [];
      int eventsToCheck = events.length > 3 ? 3 : events.length;

      for (int i = 0; i < eventsToCheck; i++) {
        try {
          final eventId = events[i]['id'];
          final props = await _getPlayerProps(eventId);
          allProps.addAll(props);

          // If we have enough props, we can stop early
          if (allProps.length >= 5) break;
        } catch (e) {
          // Error fetching player props for event ${events[i]['id']}: $e
        }
      }

      // If we found any props, return them, otherwise use mock data
      if (allProps.isNotEmpty) {
        // Found ${allProps.length} hot props from the API

        // Sort by confidence (descending)
        allProps.sort((a, b) => b.confidence.compareTo(a.confidence));

        // Take the top 3 (or all if less than 3)
        return allProps.take(3).toList();
      } else {
        // No hot props found, using mock data
        return _getMockHotProps();
      }
    } catch (e) {
      // Error getting hot props: $e
      return _getMockHotProps();
    }
  }

  /// Gets upcoming events for a specific sport
  Future<List<Map<String, dynamic>>> _getUpcomingEvents(String sport) async {
    try {
      // Define the parameters for the API request
      final Map<String, String> params = {
        'apiKey': apiKey,
      };

      // Make the API request to get events
      final uri = Uri.parse('$_baseUrl/sports/$sport/events')
          .replace(queryParameters: params);

      // Requesting upcoming events for $sport
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> events = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(events);
      } else {
        // API error: ${response.statusCode}
        return [];
      }
    } catch (e) {
      // Error fetching upcoming events: $e
      return [];
    }
  }

  /// Gets player props for a specific event
  Future<List<HotProp>> _getPlayerProps(String eventId) async {
    try {
      // Define the parameters for the API request
      final Map<String, String> params = {
        'apiKey': apiKey,
        'regions': 'us',
        'markets':
            'player_points,player_rebounds,player_assists', // Common NBA prop markets
        'oddsFormat': 'american'
      };

      // Make the API request to get player props for this event
      final uri =
          Uri.parse('$_baseUrl/sports/basketball_nba/events/$eventId/odds')
              .replace(queryParameters: params);

      // Requesting player props for event $eventId
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        // Process the bookmakers for player props
        final List<HotProp> hotProps = [];

        // Check if the response has bookmakers
        if (data['bookmakers'] == null ||
            (data['bookmakers'] as List).isEmpty) {
          return [];
        }

        // Extract player names and teams
        final String homeTeam = data['home_team'] ?? '';
        final String awayTeam = data['away_team'] ?? '';

        // Use the first bookmaker for simplicity
        final bookmaker = data['bookmakers'][0];

        // Process each market for player props
        for (var market in bookmaker['markets']) {
          final String marketKey = market['key'] ?? '';

          // Only process player prop markets
          if (!marketKey.startsWith('player_')) continue;

          // Process each outcome in this market
          for (var outcome in market['outcomes']) {
            // Get the player name from the description
            final String playerName =
                outcome['description'] ?? 'Unknown Player';
            final double point = outcome['point'] ?? 0.0;
            final String overUnder = outcome['name'] ?? 'Over';

            // Only use "Over" props for simplicity
            if (overUnder != 'Over') continue;

            // Format the prop name
            String propName = '';
            if (marketKey == 'player_points') {
              propName = '$playerName Over $point Points';
            } else if (marketKey == 'player_rebounds') {
              propName = '$playerName Over $point Rebounds';
            } else if (marketKey == 'player_assists') {
              propName = '$playerName Over $point Assists';
            } else {
              propName = '$playerName Over $point';
            }

            // Calculate a confidence score based on the American odds
            int americanOdds = outcome['price'] ?? -110;
            double confidence = _calculateConfidence(americanOdds);

            // Create the HotProp
            hotProps.add(HotProp(
              name: propName,
              confidence: confidence,
              odds: americanOdds.toString(),
            ));
          }
        }

        return hotProps;
      } else {
        // API error: ${response.statusCode}
        return [];
      }
    } catch (e) {
      // Error fetching player props: $e
      return [];
    }
  }

  /// Calculate a confidence score based on the American odds
  /// This is a simplistic calculation - in real life, you'd likely
  /// use more sophisticated factors to determine confidence
  double _calculateConfidence(int americanOdds) {
    // Convert American odds to implied probability
    double impliedProbability;
    if (americanOdds > 0) {
      impliedProbability = 100 / (americanOdds + 100);
    } else {
      impliedProbability = -americanOdds / (-americanOdds + 100);
    }

    // Convert to a confidence score out of 100
    double confidence = impliedProbability * 100;

    // Add some randomness to simulate proprietary algorithm
    confidence += (DateTime.now().millisecond % 10) - 5;

    // Ensure confidence is between 50 and 95
    return confidence.clamp(50.0, 95.0);
  }

  // Mock hot props data for testing or when API is unavailable
  List<HotProp> _getMockHotProps() {
    return [
      const HotProp(
        name: "Steph Curry Over 28.5 Points",
        confidence: 90.0,
        odds: "-110",
      ),
      const HotProp(
        name: "LeBron James Triple Double",
        confidence: 75.0,
        odds: "+250",
      ),
      const HotProp(
        name: "Luka Doncic Over 9.5 Assists",
        confidence: 65.0,
        odds: "-115",
      ),
    ];
  }
}
