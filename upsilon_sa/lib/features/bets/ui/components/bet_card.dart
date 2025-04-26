// lib/features/bets/ui/components/bet_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:upsilon_sa/features/bets/models/bet_model.dart';
import 'package:upsilon_sa/core/config/themes.dart';

class BetCard extends StatelessWidget {
  final Bet bet;
  final String selectedBetType;
  final String? appliedSystem;
  final Function(Bet) onBetSelected;

  const BetCard({
    Key? key,
    required this.bet,
    required this.selectedBetType,
    required this.onBetSelected,
    this.appliedSystem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isWebPlatform = kIsWeb;
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
    final isWebPlatform = kIsWeb;
    final fontSize = isWebPlatform ? 16.0 : 14.0;

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
                  style: TextStyle(
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
                  style: TextStyle(
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
    switch (selectedBetType) {
      case 'moneyline':
        return _buildMoneylineContent(context);
      case 'spread':
        return _buildSpreadContent(context);
      case 'totals':
        return _buildTotalsContent(context);
      default:
        return _buildMoneylineContent(context);
    }
  }

  Widget _buildMoneylineContent(BuildContext context) {
    final moneylineOdds = bet.getBestMoneylineOdds();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOddsBox(
            context,
            team: bet.awayTeam,
            odds: moneylineOdds['away']['odds'] != null
                ? _formatOdds(moneylineOdds['away']['odds'])
                : 'N/A',
            bookmaker: moneylineOdds['away']['bookmaker'] ?? 'N/A',
          ),
          _buildOddsBox(
            context,
            team: bet.homeTeam,
            odds: moneylineOdds['home']['odds'] != null
                ? _formatOdds(moneylineOdds['home']['odds'])
                : 'N/A',
            bookmaker: moneylineOdds['home']['bookmaker'] ?? 'N/A',
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSpreadContent(BuildContext context) {
    final spreadOdds = bet.getBestSpreadOdds();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOddsBox(
            context,
            team: bet.awayTeam,
            odds: spreadOdds['away']['odds'] != null
                ? '${_formatOdds(spreadOdds['away']['odds'])} (${_formatPoint(spreadOdds['away']['point'])})'
                : 'N/A',
            bookmaker: spreadOdds['away']['bookmaker'] ?? 'N/A',
          ),
          _buildOddsBox(
            context,
            team: bet.homeTeam,
            odds: spreadOdds['home']['odds'] != null
                ? '${_formatOdds(spreadOdds['home']['odds'])} (${_formatPoint(spreadOdds['home']['point'])})'
                : 'N/A',
            bookmaker: spreadOdds['home']['bookmaker'] ?? 'N/A',
            isHighlighted: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalsContent(BuildContext context) {
    final totalsOdds = bet.getBestTotalsOdds();
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOddsBox(
            context,
            team: 'Over',
            odds: totalsOdds['over']['odds'] != null
                ? '${_formatOdds(totalsOdds['over']['odds'])} (${_formatPoint(totalsOdds['over']['point'])})'
                : 'N/A',
            bookmaker: totalsOdds['over']['bookmaker'] ?? 'N/A',
          ),
          _buildOddsBox(
            context,
            team: 'Under',
            odds: totalsOdds['under']['odds'] != null
                ? '${_formatOdds(totalsOdds['under']['odds'])} (${_formatPoint(totalsOdds['under']['point'])})'
                : 'N/A',
            bookmaker: totalsOdds['under']['bookmaker'] ?? 'N/A',
            isHighlighted: true,
          ),
        ],
      ),
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
    final isWebPlatform = kIsWeb;
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
    final isWebPlatform = kIsWeb;

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