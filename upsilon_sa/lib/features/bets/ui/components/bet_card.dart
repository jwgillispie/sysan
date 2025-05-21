// lib/features/bets/ui/components/bet_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'package:upsilon_sa/core/config/themes.dart';

class BetCard extends StatelessWidget {
  final Bet bet;
  final String? appliedSystem;
  final Function(Bet) onBetSelected;

  const BetCard({
    super.key,
    required this.bet,
    required this.onBetSelected,
    this.appliedSystem,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;

    // Get confidence score for the system (mock data)
    final double confidenceScore =
        appliedSystem != null ? _getSystemConfidence() : 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: primaryColor.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => onBetSelected(bet),
        child: Column(
          children: [
            // Game header
            _buildGameHeader(context),

            // Divider
            Divider(color: primaryColor.withOpacity(0.3), height: 1),

            // Bet type content (moneyline, spread, or totals)
            _buildBetTypeContent(context),

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
    const isWebPlatform = kIsWeb;
    const fontSize = isWebPlatform ? 16.0 : 14.0;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bet.sportTitle,
                style: TextStyle(
                  color: primaryColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _formatDateTime(bet.commenceTime),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: fontSize,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  bet.awayTeam,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: isWebPlatform ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '@',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: isWebPlatform ? 16 : 14,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  bet.homeTeam,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: isWebPlatform ? 18 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBetTypeContent(BuildContext context) {
    final moneylineOdds = bet.getBestMoneylineOdds();
    final spreadOdds = bet.getBestSpreadOdds();
    final totalsOdds = bet.getBestTotalsOdds();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          // Odds header row
          _buildOddsHeader(context),
          const SizedBox(height: 8),
          // Teams with all odds types in a compact format
          _buildCompactOddsRow(
            context, 
            bet.awayTeam, 
            moneylineOdds['away'], 
            spreadOdds['away'], 
            false
          ),
          const SizedBox(height: 8),
          _buildCompactOddsRow(
            context, 
            bet.homeTeam, 
            moneylineOdds['home'], 
            spreadOdds['home'],
            true
          ),
          const SizedBox(height: 8),
          // Totals row
          _buildTotalsRow(context, totalsOdds),
        ],
      ),
    );
  }
  
  Widget _buildOddsHeader(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    const fontSize = isWebPlatform ? 14.0 : 12.0;
    
    return Row(
      children: [
        // Team column
        Expanded(
          flex: 3,
          child: Text(
            'TEAM',
            style: TextStyle(
              color: primaryColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Money line column
        Expanded(
          flex: 2,
          child: Text(
            'ML',
            style: TextStyle(
              color: primaryColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        // Spread column
        Expanded(
          flex: 2,
          child: Text(
            'SPREAD',
            style: TextStyle(
              color: primaryColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
  
  Widget _buildCompactOddsRow(BuildContext context, String team, Map<String, dynamic> moneylineData, Map<String, dynamic> spreadData, bool isHome) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    final textColor = isHome ? primaryColor : Colors.white;
    const fontSize = isWebPlatform ? 16.0 : 14.0;
    const oddsSize = isWebPlatform ? 15.0 : 13.0;
    
    return Row(
      children: [
        // Team name
        Expanded(
          flex: 3,
          child: Text(
            team,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Money line
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              color: isHome ? primaryColor.withOpacity(0.1) : Colors.black,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isHome ? primaryColor : primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              moneylineData['odds'] != null
                  ? _formatOdds(moneylineData['odds'])
                  : 'N/A',
              style: TextStyle(
                color: textColor,
                fontSize: oddsSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Spread
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            decoration: BoxDecoration(
              color: isHome ? primaryColor.withOpacity(0.1) : Colors.black,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: isHome ? primaryColor : primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              spreadData['point'] != null
                  ? _formatPoint(spreadData['point'])
                  : 'N/A',
              style: TextStyle(
                color: textColor,
                fontSize: oddsSize,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTotalsRow(BuildContext context, Map<String, dynamic> totalsOdds) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    const fontSize = isWebPlatform ? 14.0 : 12.0;
    const oddsSize = isWebPlatform ? 15.0 : 13.0;
    
    return Row(
      children: [
        // Label
        Expanded(
          flex: 3,
          child: Text(
            'TOTAL',
            style: TextStyle(
              color: primaryColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Over
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'O',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: primaryColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  totalsOdds['over']['point'] != null
                      ? _formatPoint(totalsOdds['over']['point'])
                      : 'N/A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: oddsSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Under
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'U',
                style: TextStyle(
                  color: primaryColor, 
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: primaryColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  totalsOdds['under']['point'] != null
                      ? _formatPoint(totalsOdds['under']['point'])
                      : 'N/A',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: oddsSize,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOddsBox(
    BuildContext context, {
    required String team,
    required String odds,
    required String bookmaker,
    bool isHighlighted = false,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    const isWebPlatform = kIsWeb;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Adjust width based on platform and screen size
    final double boxWidth = isWebPlatform 
        ? (screenWidth > 600 ? 180 : 130)
        : 150;

    return Container(
      width: boxWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighlighted ? primaryColor.withOpacity(0.1) : Colors.black,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? primaryColor : primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            team,
            style: TextStyle(
              color: isHighlighted ? primaryColor : Colors.white,
              fontSize: isWebPlatform ? 16 : 14,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            odds,
            style: TextStyle(
              color: isHighlighted ? primaryColor : Colors.white,
              fontSize: isWebPlatform ? 18 : 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            bookmaker,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSystemConfidenceIndicator(
      BuildContext context, double confidence) {
    final color = _getConfidenceColor(confidence);
    const isWebPlatform = kIsWeb;

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                'SYSTEM: $appliedSystem',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: isWebPlatform ? 14 : 12,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CONF: ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: isWebPlatform ? 14 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${confidence.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: color,
                    fontSize: isWebPlatform ? 14 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ));
  }

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

    return '$month/$day - $hour:$minute $period';
  }

  String _formatOdds(dynamic odds) {
    if (odds == null) return 'N/A';

    final oddsValue = odds as num;
    if (oddsValue > 0) {
      return '+$oddsValue';
    }
    return '$oddsValue';
  }

  String _formatPoint(dynamic point) {
    if (point == null) return 'N/A';

    final pointValue = point as num;
    if (pointValue > 0) {
      return '+$pointValue';
    }
    return '$pointValue';
  }

  double _getSystemConfidence() {
    // This would be replaced with actual logic to get the system confidence
    // For now, just return a random value between 50 and 95
    return 75.5; // Example value
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
}