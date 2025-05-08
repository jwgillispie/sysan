// lib/features/bets/ui/components/filter_section.dart
import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/bets/bloc/bets_bloc.dart';

class FilterSection extends StatelessWidget {
  final TextEditingController searchController;
  final Function(BetsSort) onSortChanged;

  const FilterSection({
    super.key,
    required this.searchController,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
        padding: const EdgeInsets.all(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SORT BY:',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortButton(
                    context,
                    'Start Time',
                    Icons.access_time,
                    () => onSortChanged(BetsSort.startTime),
                  ),
                  const SizedBox(width: 8),
                  _buildSortButton(
                    context,
                    'Best Odds',
                    Icons.trending_up,
                    () => onSortChanged(BetsSort.odds),
                  ),
                  const SizedBox(width: 8),
                  _buildSortButton(
                    context,
                    'System Confidence',
                    Icons.psychology,
                    () => onSortChanged(BetsSort.systemConfidence),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildSortButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primaryColor,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
