// lib/features/bets/ui/components/sport_selector.dart

import 'package:flutter/material.dart';

class SportSelector extends StatelessWidget {
  final String selectedSport;
  final Function(String) onSportSelected;

  const SportSelector({
    super.key,
    required this.selectedSport,
    required this.onSportSelected,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    
    // List of available sports with their display names and icons
    final sports = [
      {'id': 'basketball_nba', 'name': 'NBA', 'icon': Icons.sports_basketball},
      {'id': 'americanfootball_nfl', 'name': 'NFL', 'icon': Icons.sports_football},
      {'id': 'baseball_mlb', 'name': 'MLB', 'icon': Icons.sports_baseball},
      {'id': 'icehockey_nhl', 'name': 'NHL', 'icon': Icons.sports_hockey},
      {'id': 'soccer_epl', 'name': 'Soccer', 'icon': Icons.sports_soccer},
    ];

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
            'SELECT SPORT:',
            style: TextStyle(
              color: primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var sport in sports) ...[
                  _buildSportButton(
                    context,
                    sport['id'] as String,
                    sport['name'] as String,
                    sport['icon'] as IconData,
                    selectedSport == sport['id'],
                    () => onSportSelected(sport['id'] as String),
                  ),
                  const SizedBox(width: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportButton(
    BuildContext context,
    String sportId,
    String sportName,
    IconData icon,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected 
            ? primaryColor.withOpacity(0.3) 
            : primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
              ? primaryColor 
              : primaryColor.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primaryColor,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              sportName,
              style: TextStyle(
                color: primaryColor,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.check_circle,
                color: primaryColor,
                size: 14,
              ),
            ],
          ],
        ),
      ),
    );
  }
}