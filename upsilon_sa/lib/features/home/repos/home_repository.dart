// lib/features/home/repos/home_repository.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:upsilon_sa/core/utils/helpers.dart';

// Import reference to our global environment variables
import 'package:upsilon_sa/main.dart' show environmentVariables;

class HomeRepository {
  // Base URL for The Odds API
  final String _baseUrl = 'https://api.the-odds-api.com/v4';
  
  // Get API key from environment variables
  String get apiKey {
    // First check if we have it in the global map (for web)
    final webApiKey = environmentVariables['ODDS_API_KEY'];
    if (webApiKey != null && webApiKey.isNotEmpty && webApiKey != 'YOUR_ODDS_API_KEY') {
      return webApiKey;
    }
    
    // Then try the environment helper (for mobile)
    return EnvironmentHelper.getEnvironmentValue('ODDS_API_KEY');
  }
  
  Future<List<Map<String, dynamic>>> getNews() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock news data (unchanged)
    return [
      {
        'author': 'John Smith',
        'title': 'Lakers Secure Dramatic Overtime Victory Against Celtics',
        'description': 'In a thrilling matchup that went down to the wire, the Los Angeles Lakers emerged victorious over their longtime rivals, the Boston Celtics, in a 124-120 overtime victory that showcased the best of NBA basketball.',
        'url': 'https://example.com/lakers-celtics',
        'urlToImage': 'https://picsum.photos/800/400?random=1',
        'publishedAt': '2024-12-07T18:30:00Z',
        'content': 'Full game recap and analysis...'
      },
      // Additional news items...
    ];
  }

  // New method to get betting lines from the Odds API
  Future<List<Map<String, dynamic>>> getBettingLines() async {
    try {
      // Check if we have a valid API key
      if (apiKey.isNotEmpty && apiKey != 'YOUR_ODDS_API_KEY') {
        // Define the parameters for the API request
        final Map<String, String> params = {
          'apiKey': apiKey,
          'regions': 'us',
          'markets': 'h2h,spreads,totals',
          'oddsFormat': 'american'
        };
        
        // Make API requests for different sports
        final List<Map<String, dynamic>> allBettingLines = [];
        
        // List of sports to fetch (you can expand this list)
        final List<String> sports = [
          'basketball_nba',
        ];
        
        for (String sport in sports) {
          try {
            final uri = Uri.parse('$_baseUrl/sports/$sport/odds').replace(
              queryParameters: params
            );
            
            print('📡 Requesting odds data for $sport');
            final response = await http.get(uri);
            
            if (response.statusCode == 200) {
              final List<dynamic> data = jsonDecode(response.body);
              
              // Transform the API data into our desired format
              for (var game in data) {
                // Skip games with no bookmakers
                if (game['bookmakers'] == null || (game['bookmakers'] as List).isEmpty) {
                  continue;
                }
                
                // Get the sport name in a nicer format
                String sportName = sport.split('_').last.toUpperCase();
                
                // Find the best odds available for this game
                final bestOdds = _findBestOdds(game);
                if (bestOdds == null) continue;
                
                allBettingLines.add({
                  'sport': sportName,
                  'teams': '${game['away_team']} @ ${game['home_team']}',
                  'spread': bestOdds['spread'],
                  'total': bestOdds['total'],
                  'moneyline': bestOdds['moneyline'],
                  'prediction': {
                    'confidence': '${(75 + (DateTime.now().millisecond % 20)).toString()}%',
                    'pick': bestOdds['best_pick']
                  }
                });
              }
            } else {
              print('❌ API error for $sport: ${response.statusCode}');
              print('Error body: ${response.body}');
            }
          } catch (e) {
            print('❌ Exception fetching $sport: $e');
          }
        }
        
        // If we got data, return it, otherwise fall back to mock data
        if (allBettingLines.isNotEmpty) {
          print('✅ Got ${allBettingLines.length} betting lines from the API');
          return allBettingLines;
        } else {
          print('⚠️ No betting lines found, using mock data');
          return _getMockBettingLines();
        }
      } else {
        print('⚠️ No API key found, using mock data');
        return _getMockBettingLines();
      }
    } catch (e) {
      print('Error getting betting lines: $e');
      return _getMockBettingLines();
    }
  }
  
  // Helper method to find the best odds from different bookmakers
  Map<String, dynamic>? _findBestOdds(Map<String, dynamic> game) {
    try {
      final bookmakers = game['bookmakers'] as List;
      if (bookmakers.isEmpty) return null;
      
      // Just use the first bookmaker for simplicity
      final bookmaker = bookmakers[0];
      String spread = 'N/A';
      String total = 'N/A';
      Map<String, String> moneyline = {'home': 'N/A', 'away': 'N/A'};
      String bestPick = '';
      
      // Get the different markets
      for (var market in bookmaker['markets']) {
        final key = market['key'];
        
        if (key == 'spreads') {
          // Find the home team spread
          for (var outcome in market['outcomes']) {
            if (outcome['name'] == game['home_team']) {
              final point = outcome['point'];
              final price = outcome['price'];
              spread = '${game['home_team']} ${point >= 0 ? '+$point' : point} ($price)';
              
              // Determine if this is a good pick
              if ((point < 0 && price > -120) || (point > 0 && price < 120)) {
                bestPick = spread;
              }
            }
          }
        } else if (key == 'totals') {
          // Get the over/under
          for (var outcome in market['outcomes']) {
            if (outcome['name'] == 'Over') {
              final point = outcome['point'];
              final price = outcome['price'];
              total = 'O/U $point';
              
              // Determine if this is a good pick
              if (price > -110) {
                bestPick = "Over $point ($price)";
              }
            }
          }
        } else if (key == 'h2h') {
          // Get the moneyline
          for (var outcome in market['outcomes']) {
            if (outcome['name'] == game['home_team']) {
              moneyline['home'] = outcome['price'].toString();
              // If home team is underdog with good odds, consider it
              if (outcome['price'] > 120) {
                bestPick = "${game['home_team']} ML (${outcome['price']})";
              }
            } else if (outcome['name'] == game['away_team']) {
              moneyline['away'] = outcome['price'].toString();
              // If away team is favorite with good odds, consider it
              if (outcome['price'] < -120) {
                bestPick = "${game['away_team']} ML (${outcome['price']})";
              }
            }
          }
        }
      }
      
      // If we didn't find a good pick, just use the spread
      if (bestPick.isEmpty) {
        bestPick = spread;
      }
      
      return {
        'spread': spread,
        'total': total,
        'moneyline': moneyline,
        'best_pick': bestPick
      };
    } catch (e) {
      print('Error finding best odds: $e');
      return null;
    }
  }

  // Mock betting lines data for testing or when API is unavailable
  List<Map<String, dynamic>> _getMockBettingLines() {
    return [
      {
        'sport': 'NBA',
        'teams': 'Lakers vs Warriors',
        'spread': 'LAL -4.5',
        'total': 'O/U 224.5',
        'moneyline': {'home': '+165', 'away': '-185'},
        'prediction': {'confidence': '87%', 'pick': 'Lakers -4.5'}
      },
      {
        'sport': 'NFL',
        'teams': 'Chiefs vs Ravens',
        'spread': 'BAL -3.0',
        'total': 'O/U 47.5',
        'moneyline': {'home': '-150', 'away': '+130'},
        'prediction': {'confidence': '92%', 'pick': 'Over 47.5'}
      },
      {
        'sport': 'MLB',
        'teams': 'Yankees vs Red Sox',
        'spread': 'NYY -1.5',
        'total': 'O/U 8.5',
        'moneyline': {'home': '-135', 'away': '+115'},
        'prediction': {'confidence': '85%', 'pick': 'Yankees ML'}
      },
      {
        'sport': 'NHL',
        'teams': 'Bruins vs Maple Leafs',
        'spread': 'BOS -1.5',
        'total': 'O/U 5.5',
        'moneyline': {'home': '-110', 'away': '-110'},
        'prediction': {'confidence': '78%', 'pick': 'Under 5.5'}
      }
    ];
  }

  Future<List<String>> getTitles() async {
    final newsList = await getNews();
    return newsList.map((article) => article['title'] as String).toList();
  }

  Future<List<String>> getUrls() async {
    final newsList = await getNews();
    return newsList.map((article) => article['url'] as String).toList();
  }

  Future<List<String>> getImageUrls() async {
    final newsList = await getNews();
    return newsList.map((article) => article['urlToImage'] as String).toList();
  }

  Future<List<String>> getDescriptions() async {
    final newsList = await getNews();
    return newsList.map((article) => article['description'] as String).toList();
  }
}