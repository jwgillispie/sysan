// Path: lib/features/home/ui/components/ticker_bar.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/core/config/constants.dart';

class TickerBar extends StatelessWidget {
  final ScrollController scrollController;
  final List<Map<String, dynamic>> bettingLines;

  const TickerBar({
    Key? key,
    required this.scrollController,
    required this.bettingLines,
  }) : super(key: key);

  List<String> get tickerLines => bettingLines.map((line) {
    return '${line['sport']} | ${line['teams']} | ${line['prediction']['pick']} (${line['prediction']['confidence']})';
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
          final itemIndex = index % bettingLines.length;
          return TickerItem(
            sport: bettingLines[itemIndex]['sport'],
            teams: bettingLines[itemIndex]['teams'],
            pick: bettingLines[itemIndex]['prediction']['pick'],
            confidence: bettingLines[itemIndex]['prediction']['confidence'],
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
    Key? key,
    required this.sport,
    required this.teams,
    required this.pick,
    required this.confidence,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: sport),
                const TextSpan(text: ' | '),
                TextSpan(text: teams),
                const TextSpan(text: ' | '),
                TextSpan(text: pick),
                TextSpan(
                  text: ' ($confidence)',
                  style: const TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}