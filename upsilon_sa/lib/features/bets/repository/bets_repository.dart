// lib/features/bets/repository/bets_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bet_model.dart';
import 'package:upsilon_sa/core/utils/helpers.dart';

// Import reference to our global environment variables
import 'package:upsilon_sa/main.dart' show environmentVariables;

class BetsRepository {
  // Get API key using the helper (works for both web and mobile)
  String get apiKey {
    // First check if we have it in the global map (for web)
    final webApiKey = environmentVariables['ODDS_API_KEY'];
    if (webApiKey != null && webApiKey.isNotEmpty) {
      return webApiKey;
    }

    // Then try the environment helper (for mobile)
    return EnvironmentHelper.getEnvironmentValue('ODDS_API_KEY');
  }

  final String baseUrl = 'https://api.the-odds-api.com/v4';

  Future<List<Bet>> getUpcomingBets({
    String sport = 'basketball_nba',
    String regions = 'us',
    String markets = 'h2h,spreads,totals',
    String oddsFormat = 'american',
  }) async {
    try {
      // If we have a valid API key, use live data
      if (apiKey.isNotEmpty && apiKey != 'YOUR_ODDS_API_KEY') {
        // Only show first few characters for security
        String maskedKey = apiKey.length > 5
            ? '${apiKey.substring(0, 3)}...${apiKey.substring(apiKey.length - 2)}'
            : '***';
        // Using Odds API key: $maskedKey

        final Uri requestUri = Uri.parse(
          '$baseUrl/sports/$sport/odds/?apiKey=$apiKey&regions=$regions&markets=$markets&oddsFormat=$oddsFormat',
        );
        // Requesting data from: ${requestUri.toString().replaceAll(apiKey, maskedKey)}

        try {
          final response = await http.get(requestUri);

          if (response.statusCode == 200) {
            // API request successful! Parsing data...
            final List<dynamic> data = jsonDecode(response.body);
            final bets = data.map((bet) => Bet.fromJson(bet)).toList();
            // Retrieved ${bets.length} bets from the API
            return bets;
          } else {
            // API error: ${response.statusCode}
            // Error body: ${response.body}
            // Falling back to mock data...
            return _getMockBets();
          }
        } catch (e) {
          // Exception during API request: $e
          // Falling back to mock data...
          return _getMockBets();
        }
      } else {
        // No API key found or empty key provided
        // Using mock data instead
        return _getMockBets();
      }
    } catch (e) {
      // Error getting bets: $e
      // On any error, fall back to mock data
      return _getMockBets();
    }
  }

  // Mock data for testing without API key
  List<Bet> _getMockBets() {
    const String mockData = '''
[
  {
    "id": "5a935d4f284b3fcf84515f522e9079f9",
    "sport_key": "basketball_nba",
    "sport_title": "NBA",
    "commence_time": "2025-04-25T23:05:00Z",
    "home_team": "Orlando Magic",
    "away_team": "Boston Celtics",
    "bookmakers": [
      {
        "key": "draftkings",
        "title": "DraftKings",
        "last_update": "2025-04-25T08:53:47Z",
        "markets": [
          {
            "key": "h2h",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Boston Celtics", "price": -198},
              {"name": "Orlando Magic", "price": 164}
            ]
          },
          {
            "key": "spreads",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Boston Celtics", "price": -110, "point": -4.5},
              {"name": "Orlando Magic", "price": -110, "point": 4.5}
            ]
          },
          {
            "key": "totals",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Over", "price": -110, "point": 197.0},
              {"name": "Under", "price": -110, "point": 197.0}
            ]
          }
        ]
      },
      {
        "key": "fanduel",
        "title": "FanDuel",
        "last_update": "2025-04-25T08:53:48Z",
        "markets": [
          {
            "key": "h2h",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Boston Celtics", "price": -205},
              {"name": "Orlando Magic", "price": 172}
            ]
          },
          {
            "key": "spreads",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Boston Celtics", "price": -112, "point": -4.5},
              {"name": "Orlando Magic", "price": -108, "point": 4.5}
            ]
          },
          {
            "key": "totals",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Over", "price": -108, "point": 198.0},
              {"name": "Under", "price": -112, "point": 198.0}
            ]
          }
        ]
      }
    ]
  },
  {
    "id": "8af134619ff871a0b76992d76de7e224",
    "sport_key": "basketball_nba",
    "sport_title": "NBA",
    "commence_time": "2025-04-26T00:05:00Z",
    "home_team": "Milwaukee Bucks",
    "away_team": "Indiana Pacers",
    "bookmakers": [
      {
        "key": "draftkings",
        "title": "DraftKings",
        "last_update": "2025-04-25T08:53:47Z",
        "markets": [
          {
            "key": "h2h",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Indiana Pacers", "price": 170},
              {"name": "Milwaukee Bucks", "price": -205}
            ]
          },
          {
            "key": "spreads",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Indiana Pacers", "price": -110, "point": 5.0},
              {"name": "Milwaukee Bucks", "price": -110, "point": -5.0}
            ]
          },
          {
            "key": "totals",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Over", "price": -108, "point": 230.0},
              {"name": "Under", "price": -112, "point": 230.0}
            ]
          }
        ]
      },
      {
        "key": "fanduel",
        "title": "FanDuel",
        "last_update": "2025-04-25T08:53:48Z",
        "markets": [
          {
            "key": "h2h",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Indiana Pacers", "price": 176},
              {"name": "Milwaukee Bucks", "price": -210}
            ]
          },
          {
            "key": "spreads",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Indiana Pacers", "price": -108, "point": 5.0},
              {"name": "Milwaukee Bucks", "price": -112, "point": -5.0}
            ]
          },
          {
            "key": "totals",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Over", "price": -110, "point": 230.5},
              {"name": "Under", "price": -110, "point": 230.5}
            ]
          }
        ]
      }
    ]
  },
  {
    "id": "cce8a5bd08230e0c507ec925508889bc",
    "sport_key": "basketball_nba",
    "sport_title": "NBA",
    "commence_time": "2025-04-26T01:30:00Z",
    "home_team": "Minnesota Timberwolves",
    "away_team": "Los Angeles Lakers",
    "bookmakers": [
      {
        "key": "fanduel",
        "title": "FanDuel",
        "last_update": "2025-04-25T08:53:48Z",
        "markets": [
          {
            "key": "h2h",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Los Angeles Lakers", "price": 130},
              {"name": "Minnesota Timberwolves", "price": -154}
            ]
          },
          {
            "key": "spreads",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Los Angeles Lakers", "price": -110, "point": 3.0},
              {"name": "Minnesota Timberwolves", "price": -110, "point": -3.0}
            ]
          },
          {
            "key": "totals",
            "last_update": "2025-04-25T08:53:48Z",
            "outcomes": [
              {"name": "Over", "price": -110, "point": 205.5},
              {"name": "Under", "price": -110, "point": 205.5}
            ]
          }
        ]
      },
      {
        "key": "draftkings",
        "title": "DraftKings",
        "last_update": "2025-04-25T08:53:47Z",
        "markets": [
          {
            "key": "h2h",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Los Angeles Lakers", "price": 124},
              {"name": "Minnesota Timberwolves", "price": -148}
            ]
          },
          {
            "key": "spreads",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Los Angeles Lakers", "price": -108, "point": 3.0},
              {"name": "Minnesota Timberwolves", "price": -112, "point": -3.0}
            ]
          },
          {
            "key": "totals",
            "last_update": "2025-04-25T08:53:47Z",
            "outcomes": [
              {"name": "Over", "price": -110, "point": 205.5},
              {"name": "Under", "price": -110, "point": 205.5}
            ]
          }
        ]
      }
    ]
  }
]
''';

    final List<dynamic> data = jsonDecode(mockData);
    return data.map((bet) => Bet.fromJson(bet)).toList();
  }
}
