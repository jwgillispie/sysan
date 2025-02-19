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
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        itemCount: bettingLines.length * 2,
        itemBuilder: (context, index) {
          final itemIndex = index % bettingLines.length;
          return TickerItem(text: tickerLines[itemIndex]);
        },
      ),
    );
  }
}

class TickerItem extends StatelessWidget {
  final String text;

  const TickerItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          Icon(
            Icons.trending_up,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}