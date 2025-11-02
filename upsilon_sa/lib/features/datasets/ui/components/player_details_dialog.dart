// lib/features/datasets/ui/components/player_details_dialog.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/datasets/ui/components/detail_row.dart';

class PlayerDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> player;

  const PlayerDetailsDialog({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
              child: Icon(
                Icons.person,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              player["name"],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DetailRow(icon: Icons.sports_basketball, label: 'Position', value: player["position"]),
            DetailRow(icon: Icons.calendar_today, label: 'Age', value: '${player["age"]} years'),
            DetailRow(icon: Icons.timeline, label: 'Experience', value: '${player["experience"]} years'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: const Text('CLOSE'),
            ),
          ],
        ),
      ),
    );
  }
}