// lib/features/home/repos/live_games_repository.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:upsilon_sa/core/utils/helpers.dart';

// Import reference to our global environment variables
import 'package:upsilon_sa/main.dart' show environmentVariables;

class LiveGame {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final String status;
  final String period;
  final String timeRemaining;
  final String possession; // 'home', 'away', or 'none'

  LiveGame({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.status,
    required this.period,
    required this.timeRemaining,
    required this.possession,
  });
}

class LiveGamesRepository {
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

  /// Gets currently live games from the API
  Future<LiveGame?> getLiveGame() async {
    try {
      if (apiKey.isEmpty || apiKey == 'YOUR_ODDS_API_KEY') {
        print('❌ No valid Odds API key found, using mock data for live games');
        return _getMockLiveGame();
      }

      // Get scores from the API (includes live games)
      final liveGames = await _fetchLiveGames();

      if (liveGames.isEmpty) {
        print('❌ No live games found, using mock data');
        return _getMockLiveGame();
      }

      // Return the first live game (in a real app, you might let users choose)
      print(
          '✅ Found live game: ${liveGames[0].homeTeam} vs ${liveGames[0].awayTeam}');
      return liveGames[0];
    } catch (e) {
      print('Error getting live games: $e');
      return _getMockLiveGame();
    }
  }

  /// Fetches live games from the Odds API
  Future<List<LiveGame>> _fetchLiveGames() async {
    final List<LiveGame> liveGames = [];

    // We'll check multiple sports to increase chance of finding a live game
    final sports = ['basketball_nba'];

    for (final sport in sports) {
      try {
        // Define the parameters for the API request
        final Map<String, String> params = {
          'apiKey': apiKey,
          'daysFrom': '5', // Include games from today and yesterday
        };

        // Make the API request
        final uri = Uri.parse('$_baseUrl/sports/$sport/scores')
            .replace(queryParameters: params);

        print('📡 Requesting scores for $sport');
        final response = await http.get(uri);

        if (response.statusCode == 200) {
          final List<dynamic> games = jsonDecode(response.body);

          for (var game in games) {
            // Check if the game is live
            final bool isCompleted = game['completed'] ?? false;
            final bool hasScores = game['scores'] != null;

            // We want games that have scores but aren't completed
            if (hasScores && !isCompleted) {
              // This is likely a live game

              // Get home and away scores
              int homeScore = 0;
              int awayScore = 0;

              if (game['scores'] != null) {
                for (var score in game['scores']) {
                  if (score['name'] == game['home_team']) {
                    homeScore = score['score'] ?? 0;
                  } else if (score['name'] == game['away_team']) {
                    awayScore = score['score'] ?? 0;
                  }
                }
              }

              // Game status and timing
              String status = 'LIVE';
              String period = 'Unknown';
              String timeRemaining = '--:--';

              // Some APIs provide more detailed status info
              if (game['status'] != null) {
                status = game['status'] ?? 'LIVE';
              }

              // Get period/quarter info if available
              if (game['period'] != null) {
                period = 'Q${game['period']}';
              } else if (sport.contains('basketball')) {
                // Assume basketball has 4 quarters
                if (homeScore + awayScore < 50) {
                  period = 'Q1';
                } else if (homeScore + awayScore < 100) {
                  period = 'Q2';
                } else if (homeScore + awayScore < 150) {
                  period = 'Q3';
                } else {
                  period = 'Q4';
                }
              } else if (sport.contains('football')) {
                // Assume football has 4 quarters
                if (homeScore + awayScore < 14) {
                  period = 'Q1';
                } else if (homeScore + awayScore < 28) {
                  period = 'Q2';
                } else if (homeScore + awayScore < 42) {
                  period = 'Q3';
                } else {
                  period = 'Q4';
                }
              }

              // Make a guess at time remaining (not usually provided)
              // This would be better with a real-time API that includes clock data
              final now = DateTime.now();
              final secondsInMinute = now.second;
              timeRemaining =
                  '${now.minute % 12}:${secondsInMinute < 10 ? '0$secondsInMinute' : secondsInMinute}';

              // Determine possession (a bit random for demo purposes)
              String possession = 'none';
              if (now.millisecond % 3 == 0) {
                possession = 'home';
              } else if (now.millisecond % 3 == 1) {
                possession = 'away';
              }

              liveGames.add(LiveGame(
                id: game['id'] ?? '',
                homeTeam: game['home_team'] ?? 'Home',
                awayTeam: game['away_team'] ?? 'Away',
                homeScore: homeScore,
                awayScore: awayScore,
                status: status,
                period: period,
                timeRemaining: timeRemaining,
                possession: possession,
              ));
            }
          }
        } else {
          print('❌ API error for $sport: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching scores for $sport: $e');
      }
    }

    return liveGames;
  }

  /// Returns a mock live game when API is unavailable or no live games found
  LiveGame _getMockLiveGame() {
    return LiveGame(
      id: 'mock-game-1',
      homeTeam: 'BOS',
      awayTeam: 'GSW',
      homeScore: 108,
      awayScore: 102,
      status: 'LIVE',
      period: 'Q4',
      timeRemaining: '4:32',
      possession: 'home',
    );
  }
}
