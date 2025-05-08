// lib/features/home/ui/components/ticker_bar.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/constants.dart';

class TickerBar extends StatelessWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> bettingLines;

  const TickerBar({
    super.key,
    required this.scrollController,
    required this.bettingLines,
  });

  // Format the betting lines for display
  List<String> get tickerLines => bettingLines.map((line) {
    // Extract prediction for easier access
    final prediction = line['prediction'];
    final confidence = prediction['confidence'] ?? '';
    final pick = prediction['pick'] ?? '';
    
    // Format the ticker line
    return '${line['sport']} | ${line['teams']} | $pick ($confidence)';
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        itemCount: bettingLines.length * 10, // Repeat items for continuous scroll
        itemBuilder: (context, index) {
          // Use modulo to cycle through the available betting lines
          final itemIndex = index % bettingLines.length;
          final line = bettingLines[itemIndex];
          
          // Extract values from the betting line
          final sport = line['sport'] ?? '';
          final teams = line['teams'] ?? '';
          final pick = line['prediction']?['pick'] ?? '';
          final confidence = line['prediction']?['confidence'] ?? '';
          
          return TickerItem(
            sport: sport,
            teams: teams,
            pick: pick,
            confidence: confidence,
          );
        },
      ),
    );
  }
}

class TickerItem extends StatelessWidget {
  final String sport;
  final String teams;
  final String pick;
  final String confidence;

  const TickerItem({
    super.key,
    required this.sport,
    required this.teams,
    required this.pick,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final confidenceColor = _getConfidenceColor(confidence);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Sport indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getSportColor(sport).withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _getSportColor(sport).withOpacity(0.3),
              ),
            ),
            child: Text(
              sport,
              style: TextStyle(
                color: _getSportColor(sport),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Teams
          Text(
            teams,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          // Prediction pick
          Text(
            pick,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          // Confidence
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: confidenceColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: confidenceColor.withOpacity(0.3),
              ),
            ),
            child: Text(
              confidence,
              style: TextStyle(
                color: confidenceColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper method to get color for different sports
  Color _getSportColor(String sport) {
    switch (sport.toUpperCase()) {
      case 'NBA':
        return Colors.orange;
      case 'NFL':
        return Colors.blue;
      case 'MLB':
        return Colors.red;
      case 'NHL':
        return Colors.lightBlue;
      default:
        return Colors.green;
    }
  }
  
  // Helper method to get color based on confidence level
  Color _getConfidenceColor(String confidence) {
    // Parse the confidence percentage
    final confidenceValue = double.tryParse(
      confidence.replaceAll('%', '').trim()
    ) ?? 0.0;
    
    if (confidenceValue >= 90) {
      return Colors.green;
    } else if (confidenceValue >= 80) {
      return Colors.lightGreen;
    } else if (confidenceValue >= 70) {
      return Colors.yellow;
    } else if (confidenceValue >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}