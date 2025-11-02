// lib/features/bets/ui/components/system_performance_dialog.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'package:upsilon_sa/features/systems_creation/models/system_model.dart';

class SystemPerformanceDialog extends StatelessWidget {
  final Bet bet;
  final SystemModel system;

  const SystemPerformanceDialog({
    super.key,
    required this.bet,
    required this.system,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    // Generate mock performance statistics for the system on this bet
    final betOutcome = _generateBetOutcome();
    final historicalStats = _generateHistoricalStats();
    final predictionScore = _generatePredictionScore();
    
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                color: primaryColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'SYSTEM TEST RESULTS',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            system.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Text(
                '${bet.homeTeam} vs ${bet.awayTeam}',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'TEST MODE',
                  style: TextStyle(
                    color: Colors.blue[300],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      content: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // System's prediction section
              _buildSection(
                context,
                'SYSTEM PREDICTION',
                [
                  _buildPredictionCard(context, betOutcome, predictionScore),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Historical performance section
              _buildSection(
                context,
                'HISTORICAL PERFORMANCE',
                [
                  _buildPerformanceMetrics(context, historicalStats),
                  const SizedBox(height: 12),
                  _buildPerformanceChart(context, historicalStats),
                ],
              ),
              
              const SizedBox(height: 20),
              
              // Factors analysis section
              _buildSection(
                context,
                'KEY FACTORS',
                [
                  _buildFactorsAnalysis(context),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'DISCARD',
            style: TextStyle(
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            // Here you would implement system saving functionality
            // Show the SnackBar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('System saved for this bet'),
                backgroundColor: primaryColor,
                behavior: SnackBarBehavior.fixed,
                duration: const Duration(seconds: 2),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.black,
          ),
          child: const Text(
            'SAVE SYSTEM',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              height: 18,
              width: 3,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
  
  Widget _buildPredictionCard(
    BuildContext context, 
    Map<String, dynamic> betOutcome,
    double predictionScore,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isStrongPrediction = predictionScore >= 75;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                betOutcome['prediction'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isStrongPrediction ? Icons.trending_up : Icons.trending_flat,
                    color: isStrongPrediction ? Colors.green : Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${predictionScore.toStringAsFixed(1)}% Confidence',
                    style: TextStyle(
                      color: isStrongPrediction ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTeamPrediction(
                context, 
                bet.homeTeam, 
                betOutcome['homeOdds'].toString(),
                betOutcome['recommendation'] == 'HOME',
              ),
              Container(
                height: 40,
                width: 1,
                color: Colors.grey[700],
              ),
              _buildTeamPrediction(
                context, 
                bet.awayTeam, 
                betOutcome['awayOdds'].toString(),
                betOutcome['recommendation'] == 'AWAY',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getRecommendationColor(betOutcome['recommendation']).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _getRecommendationColor(betOutcome['recommendation']).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getRecommendationIcon(betOutcome['recommendation']),
                  color: _getRecommendationColor(betOutcome['recommendation']),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  betOutcome['recommendationText'],
                  style: TextStyle(
                    color: _getRecommendationColor(betOutcome['recommendation']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTeamPrediction(
    BuildContext context,
    String teamName,
    String odds,
    bool recommended,
  ) {
    return Column(
      children: [
        Text(
          teamName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: recommended ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: recommended
                ? Colors.green.withValues(alpha: 0.2)
                : Colors.grey[800],
            borderRadius: BorderRadius.circular(12),
            border: recommended
                ? Border.all(color: Colors.green.withValues(alpha: 0.5))
                : null,
          ),
          child: Text(
            odds,
            style: TextStyle(
              color: recommended ? Colors.green : Colors.white,
              fontWeight: recommended ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceMetrics(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMetricItem(context, 'Win Rate', '${stats['winRate']}%', Colors.green),
        _buildMetricItem(context, 'ROI', '+${stats['roi']}%', Colors.blue),
        _buildMetricItem(context, 'Streak', stats['streak'], Colors.orange),
      ],
    );
  }
  
  Widget _buildMetricItem(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildPerformanceChart(
    BuildContext context,
    Map<String, dynamic> stats,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final results = stats['lastResults'] as List<String>;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Last ${results.length} Predictions',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: results.map((result) {
              final isWin = result == 'W';
              return Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isWin ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    result,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFactorsAnalysis(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    // Mock factors that influenced the system's decision
    final factors = [
      {
        'name': 'Home Team Momentum',
        'value': '+6.5',
        'influence': 0.8,
        'positive': true,
      },
      {
        'name': 'Away Team Injuries',
        'value': '3 starters out',
        'influence': 0.7,
        'positive': true,
      },
      {
        'name': 'Historical Matchup',
        'value': '4-1 (last 5)',
        'influence': 0.6,
        'positive': true,
      },
      {
        'name': 'Away Team Road Performance',
        'value': '2-5 recent',
        'influence': 0.4,
        'positive': false,
      },
    ];
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900]?.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var factor in factors)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: (factor['positive'] as bool)
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (factor['positive'] as bool)
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        (factor['positive'] as bool)
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        color: (factor['positive'] as bool)
                            ? Colors.green
                            : Colors.red,
                        size: 10,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          factor['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          factor['value'] as String,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildInfluenceBar(
                    context,
                    factor['influence'] as double,
                    factor['positive'] as bool,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildInfluenceBar(
    BuildContext context,
    double influence,
    bool positive,
  ) {
    const width = 60.0;
    final color = positive ? Colors.green : Colors.red;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${(influence * 100).toInt()}%',
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Container(
          width: width,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: width * influence,
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods to generate dummy data
  Map<String, dynamic> _generateBetOutcome() {
    // Generate random outcomes and odds for demo purposes
    final random = DateTime.now().millisecondsSinceEpoch % 3;
    String recommendation;
    String recommendationText;
    
    if (random == 0) {
      recommendation = 'HOME';
      recommendationText = 'SYSTEM FAVORS ${bet.homeTeam.toUpperCase()}';
    } else if (random == 1) {
      recommendation = 'AWAY';
      recommendationText = 'SYSTEM FAVORS ${bet.awayTeam.toUpperCase()}';
    } else {
      recommendation = 'NONE';
      recommendationText = 'NO CLEAR ADVANTAGE DETECTED';
    }
    
    return {
      'prediction': '${bet.homeTeam} vs ${bet.awayTeam}',
      'homeOdds': '+${(110 + (DateTime.now().millisecond % 40)).toString()}',
      'awayOdds': '-${(110 + (DateTime.now().millisecond % 40)).toString()}',
      'recommendation': recommendation,
      'recommendationText': recommendationText,
    };
  }
  
  Map<String, dynamic> _generateHistoricalStats() {
    // Generate random historical performance for demo purposes
    final winRate = 50 + (DateTime.now().millisecond % 30);
    final roi = 8 + (DateTime.now().millisecond % 12);
    
    final lastResults = <String>[];
    for (var i = 0; i < 5; i++) {
      lastResults.add((DateTime.now().millisecond + i) % 3 == 0 ? 'L' : 'W');
    }
    
    return {
      'winRate': winRate,
      'roi': roi,
      'streak': 'W3',
      'lastResults': lastResults,
    };
  }
  
  double _generatePredictionScore() {
    // Generate a random prediction confidence score
    return 65.0 + (DateTime.now().millisecond % 30);
  }
  
  Color _getRecommendationColor(String recommendation) {
    switch (recommendation) {
      case 'HOME':
      case 'AWAY':
        return Colors.green;
      case 'NONE':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
  
  IconData _getRecommendationIcon(String recommendation) {
    switch (recommendation) {
      case 'HOME':
      case 'AWAY':
        return Icons.check_circle;
      case 'NONE':
        return Icons.remove_circle;
      default:
        return Icons.info;
    }
  }
}