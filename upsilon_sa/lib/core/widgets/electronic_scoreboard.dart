// lib/core/widgets/electronic_scoreboard.dart

import 'package:flutter/material.dart';

class GameData {
  final String homeTeam;
  final String awayTeam;
  final int homeScore;
  final int awayScore;
  final int quarter;
  final String timeLeft;
  final String gameState;
  final String possession;

  GameData({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.quarter,
    required this.timeLeft,
    required this.gameState,
    required this.possession,
  });
}

class SimplifiedScoreboard extends StatelessWidget {
  final GameData gameData;
  final Function(GameData)? onGameDataChanged;

  const SimplifiedScoreboard({
    super.key,
    required this.gameData,
    this.onGameDataChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade800,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Game status indicator
          _buildGameStatusIndicator(context),
          
          const SizedBox(height: 16),
          
          // Teams and scores
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTeam(context, gameData.homeTeam, gameData.homeScore, gameData.possession == 'home'),
              _buildScoreDivider(context),
              _buildTeam(context, gameData.awayTeam, gameData.awayScore, gameData.possession == 'away'),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Game info
          _buildGameInfo(context),
        ],
      ),
    );
  }

  Widget _buildGameStatusIndicator(BuildContext context) {
    Color statusColor;
    String statusText;
    
    switch (gameData.gameState) {
      case 'LIVE':
        statusColor = Colors.red;
        statusText = 'LIVE';
        break;
      case 'TIMEOUT':
        statusColor = Colors.yellow;
        statusText = 'TIMEOUT';
        break;
      case 'QUARTER_BREAK':
        statusColor = Colors.orange;
        statusText = 'QUARTER BREAK';
        break;
      case 'END':
        statusColor = Colors.green;
        statusText = 'GAME ENDED';
        break;
      default:
        statusColor = Colors.grey;
        statusText = gameData.gameState;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade800,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.7),
                  blurRadius: 4,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeam(BuildContext context, String team, int score, bool hasPossession) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasPossession ? primaryColor : Colors.grey.shade800,
              width: hasPossession ? 2 : 1,
            ),
          ),
          child: Text(
            team,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (hasPossession)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primaryColor,
            ),
          ),
      ],
    );
  }

  Widget _buildScoreDivider(BuildContext context) {
    // This is where the error was - primaryColor is declared but not used
    // Fixed by using primaryColor in the widget or removing it if not needed
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),  // Using primaryColor here
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'VS',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoItem(context, 'QUARTER', 'Q${gameData.quarter}'),
        _buildInfoItem(context, 'TIME LEFT', gameData.timeLeft),
      ],
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: primaryColor.withOpacity(0.5),
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              color: primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}