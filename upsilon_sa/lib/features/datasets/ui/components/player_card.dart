// lib/features/datasets/ui/components/player_card.dart

import 'package:flutter/material.dart';
import 'package:upsilon_sa/features/datasets/models/player_model.dart';

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.2),
          child: Text(
            player.name.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          player.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              '${player.position} • Age: ${player.age}',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${player.experience} years experience',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.primary,
        ),
        onTap: () {
          // Show player details if needed
        },
      ),
    );
  }
}
