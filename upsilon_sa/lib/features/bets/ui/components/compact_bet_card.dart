// lib/features/bets/ui/components/compact_bet_card.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'clickable_bet_option.dart';

class CompactBetCard extends StatelessWidget {
  final Bet bet;
  final String? appliedSystem;
  final Function(Bet) onBetSelected;
  final Function(Bet, String, String, dynamic) onBetOptionSelected;

  const CompactBetCard({
    super.key,
    required this.bet,
    required this.onBetSelected,
    required this.onBetOptionSelected,
    this.appliedSystem,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.1),
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
          ],
        ),
      ),
    );
  }

  Widget _buildGameHeader(BuildContext context) {
    
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
                style: const TextStyle(
                  color: Colors.blue,
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
    
    // Get the odds data
    final moneylineOdds = bet.getBestMoneylineOdds();
    final spreadOdds = bet.getBestSpreadOdds();
    final totalsOdds = bet.getBestTotalsOdds();
    
    // Background color for the column headers
    final headerBgColor = Colors.blue.withValues(alpha: 0.05);
    
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
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: Text(
                      'TEAM',
                      style: TextStyle(
                        color: Colors.blue,
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
                        left: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: const Text(
                      'SPREAD',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
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
                        left: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: const Text(
                      'TOTAL',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
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
                        left: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: const Text(
                      'WINNER',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blue,
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
    final bgColor = isHome ? Colors.blue.withValues(alpha: 0.05) : Colors.transparent;
    
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
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
                ),
              ),
              child: spreadValue != null
                  ? ClickableBetOption(
                      mainValue: _formatPoint(spreadValue),
                      subValue: spreadOddsValue != null ? _formatOdds(spreadOddsValue) : null,
                      onTap: () {
                        onBetOptionSelected(
                          bet,
                          'spread',
                          isHome ? 'home' : 'away',
                          {
                            'point': spreadValue,
                            'odds': spreadOddsValue,
                            'team': teamName,
                          },
                        );
                      },
                      hasSystemApplied: appliedSystem != null,
                    )
                  : const Center(
                      child: Text(
                        '--',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
          
          // Total column
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
                ),
              ),
              child: totalValue != null
                  ? ClickableBetOption(
                      mainValue: _formatPoint(totalValue),
                      subValue: totalOddsValue != null ? _formatOdds(totalOddsValue) : null,
                      label: totalLabel,
                      labelColor: totalLabel == 'O' ? Colors.green[300] : Colors.grey[400],
                      onTap: () {
                        onBetOptionSelected(
                          bet,
                          'total',
                          totalLabel == 'O' ? 'over' : 'under',
                          {
                            'point': totalValue,
                            'odds': totalOddsValue,
                            'type': totalLabel == 'O' ? 'over' : 'under',
                          },
                        );
                      },
                      hasSystemApplied: appliedSystem != null,
                    )
                  : const Center(
                      child: Text(
                        '--',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
          
          // Money line (winner) column
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Colors.blue.withValues(alpha: 0.1)),
                ),
              ),
              child: moneylineValue != null
                  ? ClickableBetOption(
                      mainValue: _formatOdds(moneylineValue),
                      subValue: 'ML',
                      onTap: () {
                        onBetOptionSelected(
                          bet,
                          'moneyline',
                          isHome ? 'home' : 'away',
                          {
                            'odds': moneylineValue,
                            'team': teamName,
                          },
                        );
                      },
                      hasSystemApplied: appliedSystem != null,
                    )
                  : const Center(
                      child: Text(
                        '--',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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


  
  Widget _getSportIcon(String sportKey, BuildContext context) {
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
        color: Colors.blue.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          iconData,
          color: Colors.blue,
          size: 12,
        ),
      ),
    );
  }
}