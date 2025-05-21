// lib/features/bets/ui/components/compact_bet_card.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'package:upsilon_sa/core/config/themes.dart';

class CompactBetCard extends StatelessWidget {
  final Bet bet;
  final String? appliedSystem;
  final Function(Bet) onBetSelected;

  const CompactBetCard({
    super.key,
    required this.bet,
    required this.onBetSelected,
    this.appliedSystem,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    // Get confidence score for the system (mock data)
    final double confidenceScore = appliedSystem != null ? _getSystemConfidence() : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: -3,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onBetSelected(bet),
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game header - more compact
            _buildGameHeader(context),
            
            // Betting odds content - 3 columns with 2 rows layout
            _buildCompactBettingGrid(context),
            
            // Apply system indicator if a system is applied
            if (appliedSystem != null)
              _buildSystemConfidenceIndicator(context, confidenceScore),
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Sport icon and title
          Row(
            children: [
              _getSportIcon(bet.sportKey, context),
              const SizedBox(width: 6),
              Text(
                bet.sportTitle,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          // Game time
          Text(
            _formatDateTime(bet.commenceTime),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompactBettingGrid(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    // Get the odds data
    final moneylineOdds = bet.getBestMoneylineOdds();
    final spreadOdds = bet.getBestSpreadOdds();
    final totalsOdds = bet.getBestTotalsOdds();
    
    // Background color for the column headers
    final headerBgColor = primaryColor.withOpacity(0.05);
    
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 4),
      child: Column(
        children: [
          // Column headers
          Container(
            decoration: BoxDecoration(
              color: headerBgColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
            ),
            child: Row(
              children: [
                // Team name column
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: Text(
                      'TEAM',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Spread column
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: primaryColor.withOpacity(0.1)),
                      ),
                    ),
                    child: Text(
                      'SPREAD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Total column
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: primaryColor.withOpacity(0.1)),
                      ),
                    ),
                    child: Text(
                      'TOTAL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Money line (winner) column
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: primaryColor.withOpacity(0.1)),
                      ),
                    ),
                    child: Text(
                      'WINNER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Away team row
          _buildTeamRow(
            context,
            bet.awayTeam,
            spreadValue: spreadOdds['away']['point'],
            spreadOddsValue: spreadOdds['away']['odds'],
            totalValue: totalsOdds['over']['point'],
            totalOddsValue: totalsOdds['over']['odds'],
            totalLabel: 'O',
            moneylineValue: moneylineOdds['away']['odds'],
            isHome: false,
          ),
          
          // Home team row
          _buildTeamRow(
            context,
            bet.homeTeam,
            spreadValue: spreadOdds['home']['point'],
            spreadOddsValue: spreadOdds['home']['odds'],
            totalValue: totalsOdds['under']['point'],
            totalOddsValue: totalsOdds['under']['odds'],
            totalLabel: 'U',
            moneylineValue: moneylineOdds['home']['odds'],
            isHome: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTeamRow(
    BuildContext context, 
    String teamName, 
    {
      dynamic spreadValue,
      dynamic spreadOddsValue,
      dynamic totalValue,
      dynamic totalOddsValue,
      required String totalLabel,
      dynamic moneylineValue,
      required bool isHome,
    }
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final bgColor = isHome ? primaryColor.withOpacity(0.05) : Colors.transparent;
    
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: isHome ? const BorderRadius.only(
          bottomLeft: Radius.circular(6),
          bottomRight: Radius.circular(6),
        ) : null,
      ),
      child: Row(
        children: [
          // Team name column
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      teamName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Spread column
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: primaryColor.withOpacity(0.1)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Spread point
                  Text(
                    spreadValue != null ? _formatPoint(spreadValue) : '--',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Spread odds
                  if (spreadOddsValue != null)
                    Text(
                      _formatOdds(spreadOddsValue),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Total column
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: primaryColor.withOpacity(0.1)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total point with over/under label
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: totalLabel,
                          style: TextStyle(
                            color: totalLabel == 'O' ? Colors.green[300] : Colors.grey[400],
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: totalValue != null ? ' ${_formatPoint(totalValue)}' : ' --',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Total odds
                  if (totalOddsValue != null)
                    Text(
                      _formatOdds(totalOddsValue),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Money line (winner) column
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: primaryColor.withOpacity(0.1)),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    moneylineValue != null ? _formatOdds(moneylineValue) : '--',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (moneylineValue != null)
                    const Text(
                      'ML',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 9,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSystemConfidenceIndicator(BuildContext context, double confidence) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border(
          top: BorderSide(
            color: primaryColor.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // System name
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: primaryColor,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    appliedSystem!,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          
          // Test button
          InkWell(
            onTap: () => onBetSelected(bet),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: primaryColor.withOpacity(0.5),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.science_outlined,
                    color: primaryColor,
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'TEST',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatDateTime(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final hour = localDateTime.hour > 12
        ? localDateTime.hour - 12
        : localDateTime.hour == 0
            ? 12
            : localDateTime.hour;
    final minute = localDateTime.minute.toString().padLeft(2, '0');
    final period = localDateTime.hour >= 12 ? 'PM' : 'AM';
    final month = localDateTime.month;
    final day = localDateTime.day;

    return '$month/$day · $hour:$minute $period';
  }

  String _formatOdds(dynamic odds) {
    if (odds == null) return '--';

    final oddsValue = odds as num;
    if (oddsValue > 0) {
      return '+$oddsValue';
    }
    return '$oddsValue';
  }

  String _formatPoint(dynamic point) {
    if (point == null) return '--';

    final pointValue = point as num;
    if (pointValue > 0) {
      return '+$pointValue';
    }
    return '$pointValue';
  }

  double _getSystemConfidence() {
    // This would be replaced with actual logic to get the system confidence
    // For now, just return a random value
    return 75.5;
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) {
      return Colors.green;
    } else if (confidence >= 65) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
  
  Color _getValueColor(dynamic value, bool isHome, BuildContext context) {
    if (value == null) return Colors.grey;
    return Colors.white;
  }
  
  Widget _getSportIcon(String sportKey, BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    IconData iconData;
    
    // Determine the sport icon based on the sport key
    if (sportKey.contains('basketball')) {
      iconData = Icons.sports_basketball;
    } else if (sportKey.contains('football') || sportKey.contains('nfl')) {
      iconData = Icons.sports_football;
    } else if (sportKey.contains('baseball') || sportKey.contains('mlb')) {
      iconData = Icons.sports_baseball;
    } else if (sportKey.contains('hockey') || sportKey.contains('nhl')) {
      iconData = Icons.sports_hockey;
    } else if (sportKey.contains('soccer')) {
      iconData = Icons.sports_soccer;
    } else {
      iconData = Icons.sports;
    }
    
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          iconData,
          color: primaryColor,
          size: 12,
        ),
      ),
    );
  }
}